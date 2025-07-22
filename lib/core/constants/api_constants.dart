/// API 관련 상수들을 정의하는 클래스
class ApiConstants {
  // 공공데이터 API 기본 URL
  static const String hiraBaseUrl = 'http://apis.data.go.kr/B552657';
  static const String kfdarBaseUrl = 'http://apis.data.go.kr/1471000';
  static const String emsBaseUrl = 'http://apis.data.go.kr/B552657';
  
  // API 엔드포인트
  static const String hospitalListPath = '/HsptlAsembySearchService/getHsptlMdcncListInfoInqire';
  static const String pharmacyListPath = '/PharmacyListService/getPharmacyListService';
  static const String medicineInfoPath = '/DrbEfficacyInfoService/getDrbEfficacyInfoList';
  static const String emergencyRoomPath = '/ErmctInsttInfoInqireService/getEgytListInfoInqire';
  
  // Google Maps API
  static const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String googlePlacesApiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');
  
  // 요청 관련 상수
  static const int defaultPageSize = 20;
  static const int requestTimeout = 30000; // 30초
  static const int maxRetryCount = 3;
  
  // 검색 반경 (미터)
  static const int defaultSearchRadius = 1000; // 1km
  static const int maxSearchRadius = 5000;     // 5km
  
  // API 응답 코드
  static const String successCode = '00';
  static const String noDataCode = '03';
  static const String errorCode = '99';
} 