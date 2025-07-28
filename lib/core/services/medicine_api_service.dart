import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xml/xml.dart' as xml;
import '../../data/models/medicine.dart';

class MedicineApiService {
  static const String baseUrl = 'http://apis.data.go.kr/1471000/DrbEasyDrugInfoService';
  final Dio _dio;
  final String? _apiKey;

  MedicineApiService() 
    : _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )),
      _apiKey = dotenv.env['KFDAR_API_KEY'] ?? 'WfttZEJnFYzwghaHkUFf4H/zl6ohzwcFEFPsUNy+7C0oioUH0KYsBaqnNHWacIaCsNg40Fxo1OpZGDQYiwvsiw==' {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));
  }

  /// 의약품 목록 조회
  Future<List<Medicine>> getDrugList({
    String? itemName,
    String? entpName,
    String? itemSeq,
    String? itemPermitDate,
    int pageNo = 1,
    int numOfRows = 10,
    String? type = 'xml',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'serviceKey': _apiKey,
        'pageNo': pageNo.toString(),
        'numOfRows': numOfRows.toString(),
        'type': type,
      };

      // 검색 조건 추가
      if (itemName != null && itemName.isNotEmpty) {
        queryParameters['itemName'] = itemName;
      }
      if (entpName != null && entpName.isNotEmpty) {
        queryParameters['entpName'] = entpName;
      }
      if (itemSeq != null && itemSeq.isNotEmpty) {
        queryParameters['itemSeq'] = itemSeq;
      }
      if (itemPermitDate != null && itemPermitDate.isNotEmpty) {
        queryParameters['itemPermitDate'] = itemPermitDate;
      }

      // 디버깅을 위한 로그 추가
      print('=== Medicine API Request ===');
      print('URL: $baseUrl/getDrbEasyDrugList');
      print('Parameters: $queryParameters');
      print('API Key: ${_apiKey != null ? 'Set (${_apiKey!.substring(0, 5)}...)' : 'Not set'}');

      final response = await _dio.get(
        '/getDrbEasyDrugList',
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
        final headerElements = document.findAllElements('header');
        if (headerElements.isEmpty) {
          print('ERROR: header element not found');
          throw Exception('Invalid API response: header not found');
        }
        
        final resultCodeElements = headerElements.first.findElements('resultCode');
        if (resultCodeElements.isEmpty) {
          print('ERROR: resultCode element not found');
          throw Exception('Invalid API response: resultCode not found');
        }
        
        final resultCode = resultCodeElements.first.text;
        print('Result Code: $resultCode');
        
        if (resultCode != '00') {
          final resultMsg = headerElements.first.findElements('resultMsg').first.text;
          print('API Error Message: $resultMsg');
          throw Exception('API Error: $resultMsg');
        }

        // 의약품 데이터 파싱
        final bodyElements = document.findAllElements('body');
        if (bodyElements.isEmpty) {
          return [];
        }
        
        final items = bodyElements.first.findAllElements('item');
        print('Found ${items.length} medicines');
        
        return items.map((item) => Medicine.fromXml(item)).toList();
      } else {
        throw Exception('Failed to load medicines: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDrugList: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// 총 의약품 수 조회
  Future<int> getTotalCount({
    String? itemName,
    String? entpName,
    String? itemSeq,
    String? itemPermitDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'serviceKey': _apiKey,
        'pageNo': '1',
        'numOfRows': '1',
        'type': 'xml',
      };

      // 검색 조건 추가
      if (itemName != null && itemName.isNotEmpty) {
        queryParameters['itemName'] = itemName;
      }
      if (entpName != null && entpName.isNotEmpty) {
        queryParameters['entpName'] = entpName;
      }
      if (itemSeq != null && itemSeq.isNotEmpty) {
        queryParameters['itemSeq'] = itemSeq;
      }
      if (itemPermitDate != null && itemPermitDate.isNotEmpty) {
        queryParameters['itemPermitDate'] = itemPermitDate;
      }

      final response = await _dio.get(
        '/getDrbEasyDrugList',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.data);
        
        // 응답 코드 확인
        final headerElements = document.findAllElements('header');
        if (headerElements.isEmpty) {
          throw Exception('Invalid API response: header not found');
        }
        
        final resultCode = headerElements.first.findElements('resultCode').first.text;
        if (resultCode != '00') {
          final resultMsg = headerElements.first.findElements('resultMsg').first.text;
          throw Exception('API Error: $resultMsg');
        }
        
        // totalCount 추출
        final bodyElements = document.findAllElements('body');
        if (bodyElements.isEmpty) {
          return 0;
        }
        
        final totalCountElements = bodyElements.first.findElements('totalCount');
        if (totalCountElements.isEmpty) {
          return 0;
        }
        
        final totalCount = totalCountElements.first.text;
        return int.parse(totalCount);
      } else {
        throw Exception('Failed to get total count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTotalCount: $e');
      rethrow;
    }
  }

  /// 의약품 상세 정보 조회 (품목일련번호로 조회)
  Future<Medicine?> getMedicineDetail(String itemSeq) async {
    try {
      final medicines = await getDrugList(
        itemSeq: itemSeq,
        numOfRows: 1,
      );
      
      return medicines.isNotEmpty ? medicines.first : null;
    } catch (e) {
      print('Error in getMedicineDetail: $e');
      rethrow;
    }
  }
}