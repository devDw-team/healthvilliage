import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/services/emergency_api_service.dart';
import '../../data/models/emergency_room_model.dart';

/// 응급실 API 서비스 프로바이더
final emergencyApiServiceProvider = Provider<EmergencyApiService>((ref) {
  return EmergencyApiService();
});

/// 시도 리스트
final sidoListProvider = Provider<List<String>>((ref) {
  return [
    '서울특별시', '부산광역시', '대구광역시', '인천광역시',
    '광주광역시', '대전광역시', '울산광역시', '세종특별자치시',
    '경기도', '강원특별자치도', '충청북도', '충청남도',
    '전북특별자치도', '전라남도', '경상북도', '경상남도', '제주특별자치도'
  ];
});

/// 선택된 시도
final selectedSidoProvider = StateProvider<String?>((ref) => null);

/// 선택된 시군구
final selectedSigunguProvider = StateProvider<String?>((ref) => null);

/// 검색어
final searchQueryProvider = StateProvider<String>((ref) => '');

/// 현재 위치
final currentLocationProvider = FutureProvider<Position?>((ref) async {
  try {
    // 위치 권한 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    
    // 현재 위치 가져오기
    return await Geolocator.getCurrentPosition();
  } catch (e) {
    return null;
  }
});

/// 응급실 목록 (지역 기반)
final emergencyRoomListProvider = FutureProvider<List<EmergencyRoom>>((ref) async {
  final apiService = ref.watch(emergencyApiServiceProvider);
  final sido = ref.watch(selectedSidoProvider);
  final sigungu = ref.watch(selectedSigunguProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  
  if (sido == null || sigungu == null) {
    return [];
  }
  
  try {
    // 먼저 응급의료기관 목록을 조회하여 기본 정보를 가져옴
    final hospitalList = await apiService.getEmergencyRoomList(
      q0: sido,
      q1: sigungu,
      numOfRows: 50,
    );
    
    if (hospitalList.isEmpty) {
      return [];
    }
    
    // 각 병원의 실시간 병상 정보를 가져와서 병합
    final resultList = <EmergencyRoom>[];
    
    // 실시간 가용병상정보 조회
    try {
      final bedInfoList = await apiService.getEmergencyRoomBedInfo(
        stage1: sido,
        stage2: sigungu,
        numOfRows: 50,
      );
      
      // 병상 정보를 Map으로 변환 (빠른 검색을 위해)
      final bedInfoMap = <String, EmergencyRoom>{};
      for (final bedInfo in bedInfoList) {
        bedInfoMap[bedInfo.hpid] = bedInfo;
      }
      
      // 병원 목록과 병상 정보를 병합
      for (final hospital in hospitalList) {
        final bedInfo = bedInfoMap[hospital.hpid];
        if (bedInfo != null) {
          // 병상 정보가 있으면 병합
          resultList.add(EmergencyRoom(
            hpid: hospital.hpid,
            dutyName: hospital.dutyName,
            dutyAddr: hospital.dutyAddr,
            dutyTel1: hospital.dutyTel1,
            dutyTel3: hospital.dutyTel3 ?? bedInfo.dutyTel3,
            longitude: hospital.longitude,
            latitude: hospital.latitude,
            dutyEmcls: hospital.dutyEmcls,
            dutyEmclsName: hospital.dutyEmclsName,
            availableGeneralBeds: bedInfo.availableGeneralBeds,
            availableOperatingRooms: bedInfo.availableOperatingRooms,
            availableGeneralICU: bedInfo.availableGeneralICU,
            availableNeonatalICU: bedInfo.availableNeonatalICU,
            availableNeuroICU: bedInfo.availableNeuroICU,
            availableChestICU: bedInfo.availableChestICU,
            availableAdmissionRooms: bedInfo.availableAdmissionRooms,
            ctAvailable: bedInfo.ctAvailable,
            mriAvailable: bedInfo.mriAvailable,
            ambulanceAvailable: bedInfo.ambulanceAvailable,
          ));
        } else {
          // 병상 정보가 없으면 병원 정보만 사용
          resultList.add(hospital);
        }
      }
      
      return resultList;
    } catch (e) {
      // 병상 정보 조회 실패 시 병원 목록만 반환
      print('[EmergencyProvider] 병상 정보 조회 실패, 병원 목록만 반환: $e');
      return hospitalList;
    }
  } catch (e) {
    print('[EmergencyProvider] 응급실 목록 조회 실패: $e');
    return [];
  }
});

/// 응급실 목록 (위치 기반)
final nearbyEmergencyRoomsProvider = FutureProvider<List<EmergencyRoom>>((ref) async {
  final apiService = ref.watch(emergencyApiServiceProvider);
  final location = await ref.watch(currentLocationProvider.future);
  
  if (location == null) {
    return [];
  }
  
  final rooms = await apiService.getEmergencyRoomByLocation(
    latitude: location.latitude,
    longitude: location.longitude,
    numOfRows: 20,
  );
  
  // 디버깅: 반환된 응급실 데이터 확인
  if (rooms.isNotEmpty) {
    print('[nearbyEmergencyRoomsProvider] First room data:');
    print('  - hpid: ${rooms.first.hpid}');
    print('  - dutyName: ${rooms.first.dutyName}');
    print('  - latitude: ${rooms.first.latitude}');
    print('  - longitude: ${rooms.first.longitude}');
    print('  - distance: ${rooms.first.distance}');
  }
  
  return rooms;
});

/// 중증질환별 수용가능 병원
final severePatientHospitalsProvider = FutureProvider.family<List<SeverePatientAcceptance>, String?>((ref, smType) async {
  final apiService = ref.watch(emergencyApiServiceProvider);
  final sido = ref.watch(selectedSidoProvider);
  final sigungu = ref.watch(selectedSigunguProvider);
  
  if (sido == null || sigungu == null) {
    return [];
  }
  
  return await apiService.getSeverePatientAcceptanceInfo(
    stage1: sido,
    stage2: sigungu,
    smType: smType,
    numOfRows: 50,
  );
});

/// 응급실 상세정보
final emergencyRoomDetailProvider = FutureProvider.family<EmergencyRoom?, String>((ref, hpid) async {
  final apiService = ref.watch(emergencyApiServiceProvider);
  return await apiService.getEmergencyRoomDetail(hpid: hpid);
});

/// 시군구 리스트 (시도에 따라 변경)
final sigunguListProvider = Provider<List<String>>((ref) {
  final selectedSido = ref.watch(selectedSidoProvider);
  
  // 전국 시군구 데이터
  final sigunguMap = {
    '서울특별시': [
      '강남구', '강동구', '강북구', '강서구', '관악구',
      '광진구', '구로구', '금천구', '노원구', '도봉구',
      '동대문구', '동작구', '마포구', '서대문구', '서초구',
      '성동구', '성북구', '송파구', '양천구', '영등포구',
      '용산구', '은평구', '종로구', '중구', '중랑구'
    ],
    '부산광역시': [
      '중구', '서구', '동구', '영도구', '부산진구', '동래구', '남구', '북구',
      '해운대구', '사하구', '금정구', '강서구', '연제구', '수영구', '사상구', '기장군'
    ],
    '대구광역시': [
      '중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군', '군위군'
    ],
    '인천광역시': [
      '중구', '동구', '미추홀구', '연수구', '남동구', '부평구', '계양구', '서구', '강화군', '옹진군'
    ],
    '광주광역시': [
      '동구', '서구', '남구', '북구', '광산구'
    ],
    '대전광역시': [
      '동구', '중구', '서구', '유성구', '대덕구'
    ],
    '울산광역시': [
      '중구', '남구', '동구', '북구', '울주군'
    ],
    '세종특별자치시': [
      '세종특별자치시'
    ],
    '경기도': [
      '수원시', '성남시', '의정부시', '안양시', '부천시',
      '광명시', '평택시', '동두천시', '안산시', '고양시',
      '과천시', '구리시', '남양주시', '오산시', '시흥시',
      '군포시', '의왕시', '하남시', '용인시', '파주시',
      '이천시', '안성시', '김포시', '화성시', '광주시',
      '양주시', '포천시', '여주시', '연천군', '가평군',
      '양평군'
    ],
    '강원특별자치도': [
      '춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시',
      '홍천군', '횡성군', '영월군', '평창군', '정선군', '철원군', '화천군',
      '양구군', '인제군', '고성군', '양양군'
    ],
    '충청북도': [
      '청주시', '충주시', '제천시', '보은군', '옥천군', '영동군', '진천군',
      '괴산군', '음성군', '단양군', '증평군'
    ],
    '충청남도': [
      '천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시',
      '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군', '태안군'
    ],
    '전북특별자치도': [
      '전주시', '군산시', '익산시', '정읍시', '남원시', '김제시', '완주군',
      '진안군', '무주군', '장수군', '임실군', '순창군', '고창군', '부안군'
    ],
    '전라남도': [
      '목포시', '여수시', '순천시', '나주시', '광양시', '담양군', '곡성군',
      '구례군', '고흥군', '보성군', '화순군', '장흥군', '강진군', '해남군',
      '영암군', '무안군', '함평군', '영광군', '장성군', '완도군', '진도군', '신안군'
    ],
    '경상북도': [
      '포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시',
      '상주시', '문경시', '경산시', '군위군', '의성군', '청송군', '영양군',
      '영덕군', '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군', '울진군', '울릉군'
    ],
    '경상남도': [
      '창원시', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시',
      '양산시', '의령군', '함안군', '창녕군', '고성군', '남해군', '하동군',
      '산청군', '함양군', '거창군', '합천군'
    ],
    '제주특별자치도': [
      '제주시', '서귀포시'
    ]
  };
  
  if (selectedSido == null) {
    return [];
  }
  
  return sigunguMap[selectedSido] ?? [];
});

/// 검색 초기화
final resetSearchProvider = Provider((ref) {
  return () {
    ref.read(selectedSidoProvider.notifier).state = null;
    ref.read(selectedSigunguProvider.notifier).state = null;
    ref.read(searchQueryProvider.notifier).state = '';
  };
}); 