import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xml/xml.dart' as xml;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/pharmacy_model.dart';

class PharmacyApiService {
  static const String baseUrl = 'http://apis.data.go.kr/B551182/pharmacyInfoService';
  final Dio _dio;
  final String? _apiKey;
  final SupabaseClient _supabase = Supabase.instance.client;

  PharmacyApiService() 
    : _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),  // 30초로 증가
        receiveTimeout: const Duration(seconds: 30),  // 30초로 증가
      )),
      _apiKey = dotenv.env['HIRA_API_KEY'] {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));
  }

  /// 약국 목록 조회 (재시도 로직 포함)
  Future<List<PharmacyModel>> getPharmacyList({
    int pageNo = 1,
    int numOfRows = 10,
    String? sidoCd,
    String? sgguCd,
    String? emdongNm,
    String? yadmNm,
    double? xPos,
    double? yPos,
    int? radius,
  }) async {
    // 최대 3번 재시도
    int maxRetries = 3;
    int retryCount = 0;
    
    while (retryCount < maxRetries) {
      try {
        return await _getPharmacyListInternal(
          pageNo: pageNo,
          numOfRows: numOfRows,
          sidoCd: sidoCd,
          sgguCd: sgguCd,
          emdongNm: emdongNm,
          yadmNm: yadmNm,
          xPos: xPos,
          yPos: yPos,
          radius: radius,
        );
      } catch (e) {
        if (e is DioException && e.type == DioExceptionType.receiveTimeout) {
          retryCount++;
          if (retryCount >= maxRetries) {
            print('Max retries reached. Throwing exception.');
            rethrow;
          }
          print('Timeout occurred. Retrying... (Attempt ${retryCount + 1}/$maxRetries)');
          // 재시도 전 짧은 대기
          await Future.delayed(Duration(seconds: retryCount * 2));
        } else {
          // 타임아웃이 아닌 다른 오류는 바로 throw
          rethrow;
        }
      }
    }
    
    throw Exception('Failed after $maxRetries retries');
  }

  Future<List<PharmacyModel>> _getPharmacyListInternal({
    required int pageNo,
    required int numOfRows,
    String? sidoCd,
    String? sgguCd,
    String? emdongNm,
    String? yadmNm,
    double? xPos,
    double? yPos,
    int? radius,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'ServiceKey': _apiKey,
        'pageNo': pageNo.toString(),
        'numOfRows': numOfRows.toString(),
      };

      if (sidoCd != null) queryParameters['sidoCd'] = sidoCd;
      if (sgguCd != null) queryParameters['sgguCd'] = sgguCd;
      if (emdongNm != null) queryParameters['emdongNm'] = emdongNm;
      if (yadmNm != null) queryParameters['yadmNm'] = yadmNm;
      if (xPos != null) queryParameters['xPos'] = xPos.toString();
      if (yPos != null) queryParameters['yPos'] = yPos.toString();
      if (radius != null) queryParameters['radius'] = radius.toString();

      // 디버깅을 위한 로그 추가
      print('=== Pharmacy API Request ===');
      print('URL: $baseUrl/getParmacyBasisList');
      print('Parameters: $queryParameters');
      print('API Key: ${_apiKey != null ? 'Set (${_apiKey!.substring(0, 5)}...)' : 'Not set'}');

      final response = await _dio.get(
        '/getParmacyBasisList',
        queryParameters: queryParameters,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data Type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        // 응답 데이터 확인
        final responseData = response.data.toString();
        print('Response Data (first 500 chars): ${responseData.substring(0, responseData.length > 500 ? 500 : responseData.length)}');
        
        final document = xml.XmlDocument.parse(response.data);
        
        // 응답 코드 확인
        final resultCodeElements = document.findAllElements('resultCode');
        if (resultCodeElements.isEmpty) {
          print('ERROR: resultCode element not found');
          throw Exception('Invalid API response: resultCode not found');
        }
        
        final resultCode = resultCodeElements.first.text;
        print('Result Code: $resultCode');
        
        if (resultCode != '00') {
          final resultMsg = document.findAllElements('resultMsg').first.text;
          print('API Error Message: $resultMsg');
          throw Exception('API Error: $resultMsg');
        }

        // 약국 데이터 파싱
        final items = document.findAllElements('item');
        print('Found ${items.length} pharmacies');
        
        final pharmacies = <PharmacyModel>[];
        for (final item in items) {
          final pharmacy = PharmacyModel.fromXml(item);
          // Supabase에 약국 정보 저장 또는 업데이트
          final savedPharmacy = await _saveOrUpdatePharmacyInSupabase(pharmacy);
          pharmacies.add(savedPharmacy);
        }
        
        return pharmacies;
      } else {
        throw Exception('Failed to load pharmacies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getPharmacyList: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<PharmacyModel> _saveOrUpdatePharmacyInSupabase(PharmacyModel pharmacy) async {
    try {
      // ykiho로 기존 약국 검색
      final existingPharmacy = await _supabase
          .from('pharmacies')
          .select()
          .eq('ykiho', pharmacy.ykiho ?? '')
          .maybeSingle();

      if (existingPharmacy != null) {
        // 기존 약국이 있으면 UUID 사용
        return pharmacy.copyWith(id: existingPharmacy['id'] as String);
      } else {
        // 새 약국 정보 저장
        final newPharmacy = await _supabase
            .from('pharmacies')
            .insert({
              'ykiho': pharmacy.ykiho,
              'name': pharmacy.name,
              'address': pharmacy.address,
              'phone': pharmacy.phone,
              'latitude': pharmacy.latitude,
              'longitude': pharmacy.longitude,
              'operating_hours': {},
              'is_night_pharmacy': false,
              'is_holiday_open': false,
            })
            .select()
            .single();

        return pharmacy.copyWith(id: newPharmacy['id'] as String);
      }
    } catch (e) {
      // 오류 발생 시 원본 반환
      print('Supabase 저장 오류: $e');
      return pharmacy;
    }
  }

  /// 총 약국 수 조회
  Future<int> getTotalCount({
    String? sidoCd,
    String? sgguCd,
    String? emdongNm,
    String? yadmNm,
    double? xPos,
    double? yPos,
    int? radius,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'ServiceKey': _apiKey,
        'pageNo': '1',
        'numOfRows': '1',
      };

      if (sidoCd != null) queryParameters['sidoCd'] = sidoCd;
      if (sgguCd != null) queryParameters['sgguCd'] = sgguCd;
      if (emdongNm != null) queryParameters['emdongNm'] = emdongNm;
      if (yadmNm != null) queryParameters['yadmNm'] = yadmNm;
      if (xPos != null) queryParameters['xPos'] = xPos.toString();
      if (yPos != null) queryParameters['yPos'] = yPos.toString();
      if (radius != null) queryParameters['radius'] = radius.toString();

      final response = await _dio.get(
        '/getParmacyBasisList',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.data);
        final totalCount = document.findAllElements('totalCount').first.text;
        return int.parse(totalCount);
      } else {
        throw Exception('Failed to get total count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTotalCount: $e');
      rethrow;
    }
  }
} 