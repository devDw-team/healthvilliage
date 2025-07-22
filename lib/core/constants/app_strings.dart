/// 앱에서 사용하는 문자열들을 정의하는 클래스
class AppStrings {
  // 앱 정보
  static const String appName = '헬스빌리지';
  static const String appSubtitle = '건강한 마을을 만들어가요';
  static const String appVersion = '1.0.0';
  
  // 네비게이션
  static const String home = '홈';
  static const String medicine = '의약품';
  static const String roulette = '룰렛';
  static const String calendar = '캘린더';
  static const String myPage = '마이페이지';
  static const String prescription = '처방전';
  
  // 검색 관련
  static const String search = '검색';
  static const String searchHint = '병원이나 약국을 검색해보세요';
  static const String searchResult = '검색 결과';
  static const String noSearchResult = '검색 결과가 없습니다';
  static const String searchHistory = '최근 검색어';
  static const String clearSearchHistory = '검색기록 삭제';
  
  // 병원/약국 관련
  static const String hospital = '병원';
  static const String pharmacy = '약국';
  static const String emergencyRoom = '응급실';
  static const String nearbyHospitals = '내 주변 병원';
  static const String nearbyPharmacies = '내 주변 약국';
  static const String operatingHours = '운영시간';
  static const String phoneNumber = '전화번호';
  static const String address = '주소';
  static const String distance = '거리';
  static const String closed = '휴진';
  static const String open = '진료중';
  static const String openingSoon = '곧 개방';
  static const String closingSoon = '곧 마감';
  
  // 의약품 관련
  static const String medicineInfo = '의약품 정보';
  static const String medicineSearch = '의약품 검색';
  static const String medicineName = '의약품명';
  static const String medicineEffect = '효능·효과';
  static const String medicineUsage = '용법·용량';
  static const String medicinePrecaution = '주의사항';
  static const String medicineManufacturer = '제조회사';
  
  // 룰렛 관련
  static const String dailyRoulette = '오늘의 룰렛';
  static const String rouletteDescription = '룰렛을 돌려서 포인트를 획득하세요!';
  static const String spinRoulette = '룰렛 돌리기';
  static const String rouletteResult = '축하합니다!';
  static const String alreadySpinned = '오늘은 이미 룰렛을 돌렸습니다';
  static const String comeBackTomorrow = '내일 다시 도전해보세요!';
  
  // 포인트 관련
  static const String points = '포인트';
  static const String totalPoints = '총 포인트';
  static const String earnedPoints = '획득 포인트';
  static const String pointHistory = '포인트 내역';
  static const String dailyAttendance = '일일 출석';
  static const String attendanceBonus = '출석 보너스';
  
  // 처방전 관련
  static const String prescriptionScan = '처방전 스캔';
  static const String prescriptionList = '처방전 목록';
  static const String prescriptionHistory = '처방전 내역';
  static const String takeMedicineAlarm = '복용 알림';
  static const String medicineSchedule = '복용 일정';
  static const String scanPrescription = '처방전을 스캔해주세요';
  static const String prescriptionDate = '처방일';
  static const String hospitalName = '병원명';
  
  // 권한 관련
  static const String locationPermission = '위치 권한';
  static const String locationPermissionMessage = '내 주변 병원/약국을 찾기 위해 위치 권한이 필요합니다';
  static const String cameraPermission = '카메라 권한';
  static const String cameraPermissionMessage = '처방전 스캔을 위해 카메라 권한이 필요합니다';
  static const String notificationPermission = '알림 권한';
  static const String notificationPermissionMessage = '복용 알림을 위해 알림 권한이 필요합니다';
  static const String allowPermission = '권한 허용';
  static const String denyPermission = '거부';
  static const String goToSettings = '설정으로 이동';
  
  // 에러 메시지
  static const String networkError = '네트워크 연결을 확인해주세요';
  static const String serverError = '서버에 문제가 발생했습니다';
  static const String locationError = '위치 정보를 가져올 수 없습니다';
  static const String cameraError = '카메라를 사용할 수 없습니다';
  static const String unknownError = '알 수 없는 오류가 발생했습니다';
  static const String retry = '다시 시도';
  static const String cancel = '취소';
  static const String confirm = '확인';
  
  // 로딩 메시지
  static const String loading = '로딩 중...';
  static const String loadingHospitals = '병원 정보를 가져오는 중...';
  static const String loadingPharmacies = '약국 정보를 가져오는 중...';
  static const String loadingMedicines = '의약품 정보를 가져오는 중...';
  static const String loadingLocation = '위치 정보를 가져오는 중...';
  
  // 성공 메시지
  static const String saveSuccess = '저장되었습니다';
  static const String deleteSuccess = '삭제되었습니다';
  static const String updateSuccess = '업데이트되었습니다';
  
  // 일반
  static const String yes = '예';
  static const String no = '아니오';
  static const String ok = '확인';
  static const String close = '닫기';
  static const String save = '저장';
  static const String delete = '삭제';
  static const String edit = '수정';
  static const String add = '추가';
  static const String more = '더보기';
  static const String back = '뒤로';
  static const String next = '다음';
  static const String previous = '이전';
  static const String today = '오늘';
  static const String yesterday = '어제';
  static const String tomorrow = '내일';
  
  // 설정
  static const String settings = '설정';
  static const String notification = '알림';
  static const String theme = '테마';
  static const String language = '언어';
  static const String version = '버전';
  static const String about = '앱 정보';
  static const String privacy = '개인정보처리방침';
  static const String terms = '이용약관';
  static const String logout = '로그아웃';
  
  // 시간 관련
  static const String am = '오전';
  static const String pm = '오후';
  static const String hour = '시간';
  static const String minute = '분';
  static const String second = '초';
  static const String day = '일';
  static const String week = '주';
  static const String month = '월';
  static const String year = '년';
} 