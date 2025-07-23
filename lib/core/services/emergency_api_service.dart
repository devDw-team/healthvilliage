import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:xml/xml.dart';
import '../../data/models/emergency_room_model.dart';

/// 응급의료정보 API 서비스
class EmergencyApiService {
  late final Dio _dio;
  late final String _apiKey;
  
  static const String _baseUrl = 'http://apis.data.go.kr/B552657/ErmctInfoInqireService';
  
  EmergencyApiService() {
    _apiKey = dotenv.env['EMS_API_KEY'] ?? '';
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': '*/*',
      },
    ));
    
    // 디버깅을 위한 로거 추가
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: false,
    ));
  }
  
  /// XML 응답을 파싱하여 JSON으로 변환
  Map<String, dynamic> _parseXmlToJson(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      
      // 에러 응답 확인
      final resultCode = document.findAllElements('resultCode').firstOrNull?.text;
      final resultMsg = document.findAllElements('resultMsg').firstOrNull?.text;
      
      if (resultCode != '00' && resultCode != null) {
        print('[EmergencyAPI] API 에러 코드: $resultCode');
        print('[EmergencyAPI] API 에러 메시지: $resultMsg');
        throw Exception('API 에러: $resultMsg');
      }
      
      final items = document.findAllElements('item');
      final List<Map<String, dynamic>> result = [];
      
      for (final item in items) {
        final Map<String, dynamic> itemMap = {};
        for (final child in item.children) {
          if (child is XmlElement) {
            // 숫자 필드 처리
            final value = child.text;
            if (['hvec', 'hvoc', 'hvcc', 'hvncc', 'hvccc', 'hvicc', 'hvgc'].contains(child.name.local)) {
              itemMap[child.name.local] = int.tryParse(value) ?? 0;
            } else {
              itemMap[child.name.local] = value;
            }
          }
        }
        result.add(itemMap);
      }
      
      print('[EmergencyAPI] XML 파싱 완료: ${result.length}개 아이템');
      
      return {
        'items': result,
        'totalCount': document.findAllElements('totalCount').firstOrNull?.text ?? '0',
      };
    } catch (e) {
      print('[EmergencyAPI] XML 파싱 에러: $e');
      print('[EmergencyAPI] XML 내용: ${xmlString.substring(0, xmlString.length > 500 ? 500 : xmlString.length)}...');
      throw Exception('XML 파싱 실패: $e');
    }
  }
  
  /// 응급실 실시간 가용병상정보 조회
  Future<List<EmergencyRoom>> getEmergencyRoomBedInfo({
    required String stage1, // 시도
    required String stage2, // 시군구
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    try {
      print('[EmergencyAPI] API Key: ${_apiKey.isNotEmpty ? "있음" : "없음"}');
      print('[EmergencyAPI] 요청 파라미터: stage1=$stage1, stage2=$stage2');
      
      final response = await _dio.get(
        '/getEmrrmRltmUsefulSckbdInfoInqire',
        queryParameters: {
          'serviceKey': _apiKey,
          'STAGE1': stage1,
          'STAGE2': stage2,
          'pageNo': pageNo,
          'numOfRows': numOfRows,
        },
        options: Options(
          responseType: ResponseType.plain,
        ),
      );
      
      print('[EmergencyAPI] 응답 상태: ${response.statusCode}');
      print('[EmergencyAPI] 응답 데이터 타입: ${response.data.runtimeType}');
      
      final jsonData = _parseXmlToJson(response.data.toString());
      final items = jsonData['items'] as List;
      
      print('[EmergencyAPI] 파싱된 아이템 수: ${items.length}');
      
      return items.map((item) => EmergencyRoom.fromJson(item)).toList();
    } catch (e, stackTrace) {
      print('[EmergencyAPI] 에러 발생: $e');
      print('[EmergencyAPI] 스택 트레이스: $stackTrace');
      throw Exception('응급실 정보를 불러오는데 실패했습니다: $e');
    }
  }
  
  /// 중증질환자 수용가능정보 조회
  Future<List<SeverePatientAcceptance>> getSeverePatientAcceptanceInfo({
    required String stage1,
    required String stage2,
    String? smType, // 질환/수술명
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    try {
      final queryParams = {
        'serviceKey': _apiKey,
        'STAGE1': stage1,
        'STAGE2': stage2,
        'pageNo': pageNo,
        'numOfRows': numOfRows,
      };
      
      if (smType != null) {
        queryParams['SM_TYPE'] = smType;
      }
      
      final response = await _dio.get(
        '/getSrsillDissAceptncPosblInfoInqire',
        queryParameters: queryParams,
      );
      
      final jsonData = _parseXmlToJson(response.data);
      final items = jsonData['items'] as List;
      
      return items.map((item) => SeverePatientAcceptance.fromJson(item)).toList();
    } catch (e) {
      throw Exception('중증질환자 수용정보를 불러오는데 실패했습니다: $e');
    }
  }
  
  /// 응급의료기관 목록정보 조회
  Future<List<EmergencyRoom>> getEmergencyRoomList({
    String? q0, // 시도
    String? q1, // 시군구
    String? qt, // 진료요일
    String? qz, // 기관분류
    String? qd, // 진료과목
    String? qn, // 기관명
    String? ord, // 순서
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    try {
      final queryParams = {
        'serviceKey': _apiKey,
        'pageNo': pageNo,
        'numOfRows': numOfRows,
      };
      
      if (q0 != null) queryParams['Q0'] = q0;
      if (q1 != null) queryParams['Q1'] = q1;
      if (qt != null) queryParams['QT'] = qt;
      if (qz != null) queryParams['QZ'] = qz;
      if (qd != null) queryParams['QD'] = qd;
      if (qn != null) queryParams['QN'] = qn;
      if (ord != null) queryParams['ORD'] = ord;
      
      final response = await _dio.get(
        '/getEgytListInfoInqire',
        queryParameters: queryParams,
      );
      
      final jsonData = _parseXmlToJson(response.data);
      final items = jsonData['items'] as List;
      
      return items.map((item) => EmergencyRoom.fromJson(item)).toList();
    } catch (e) {
      throw Exception('응급의료기관 목록을 불러오는데 실패했습니다: $e');
    }
  }
  
  /// 응급의료기관 위치정보 조회 (좌표 기반)
  Future<List<EmergencyRoom>> getEmergencyRoomByLocation({
    required double longitude,
    required double latitude,
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/getEgytLcinfoInqire',
        queryParameters: {
          'serviceKey': _apiKey,
          'WGS84_LON': longitude.toString(),
          'WGS84_LAT': latitude.toString(),
          'pageNo': pageNo,
          'numOfRows': numOfRows,
        },
      );
      
      final jsonData = _parseXmlToJson(response.data);
      final items = jsonData['items'] as List;
      
      // 디버깅: API 응답 데이터 확인
      if (items.isNotEmpty) {
        print('[getEmergencyRoomByLocation] First item from API:');
        print(items.first);
      }
      
      return items.map((item) {
        // distance 필드가 문자열로 오는 경우 처리
        if (item['distance'] is String) {
          item['distance'] = double.tryParse(item['distance']) ?? 0.0;
        }
        return EmergencyRoom.fromJson(item);
      }).toList();
    } catch (e) {
      throw Exception('위치 기반 응급실 정보를 불러오는데 실패했습니다: $e');
    }
  }
  
  /// 응급의료기관 기본정보 조회
  Future<EmergencyRoom?> getEmergencyRoomDetail({
    required String hpid,
  }) async {
    try {
      final response = await _dio.get(
        '/getEgytBassInfoInqire',
        queryParameters: {
          'serviceKey': _apiKey,
          'HPID': hpid,
          'pageNo': 1,
          'numOfRows': 1,
        },
      );
      
      final jsonData = _parseXmlToJson(response.data);
      final items = jsonData['items'] as List;
      
      if (items.isNotEmpty) {
        return EmergencyRoom.fromJson(items.first);
      }
      return null;
    } catch (e) {
      throw Exception('응급실 상세정보를 불러오는데 실패했습니다: $e');
    }
  }
  
  /// 응급실 및 중증질환 메시지 조회
  Future<List<EmergencyMessage>> getEmergencyMessages({
    String? q0, // 시도
    String? q1, // 시군구
    String? qn, // 기관명
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    try {
      final queryParams = {
        'serviceKey': _apiKey,
        'pageNo': pageNo,
        'numOfRows': numOfRows,
      };
      
      if (q0 != null) queryParams['Q0'] = q0;
      if (q1 != null) queryParams['Q1'] = q1;
      if (qn != null) queryParams['QN'] = qn;
      
      final response = await _dio.get(
        '/getEmrrmSrsillDissMsgInqire',
        queryParameters: queryParams,
      );
      
      final jsonData = _parseXmlToJson(response.data);
      final items = jsonData['items'] as List;
      
      return items.map((item) => EmergencyMessage.fromJson(item)).toList();
    } catch (e) {
      throw Exception('응급실 메시지를 불러오는데 실패했습니다: $e');
    }
  }
} 