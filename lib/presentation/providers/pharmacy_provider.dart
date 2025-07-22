import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/pharmacy_api_service.dart';
import '../../data/models/pharmacy_model.dart';

// 약국 API 서비스 Provider
final pharmacyApiServiceProvider = Provider<PharmacyApiService>((ref) {
  return PharmacyApiService();
});

// 검색 조건을 위한 State Provider들
final selectedSidoProvider = StateProvider<String?>((ref) => null);
final selectedSgguProvider = StateProvider<String?>((ref) => null);
final pharmacySearchTextProvider = StateProvider<String>((ref) => '');
final currentPageProvider = StateProvider<int>((ref) => 1);

// 약국 목록 검색 Provider
final pharmacyListProvider = FutureProvider.family<List<PharmacyModel>, PharmacySearchParams>((ref, params) async {
  final apiService = ref.watch(pharmacyApiServiceProvider);
  
  // 시군구 코드 대신 시군구명을 사용하도록 수정
  String? sgguName;
  if (params.sgguCd != null) {
    final sgguList = ref.read(sgguListProvider);
    final selectedSggu = sgguList.firstWhere(
      (sggu) => sggu.code == params.sgguCd,
      orElse: () => SgguItem(code: '', name: ''),
    );
    sgguName = selectedSggu.name;
  }
  
  return await apiService.getPharmacyList(
    pageNo: params.pageNo,
    numOfRows: params.numOfRows,
    sidoCd: params.sidoCd,
    sgguCd: null, // 시군구 코드는 사용하지 않음
    emdongNm: sgguName, // 시군구명을 emdongNm으로 전달
    yadmNm: params.yadmNm,
    xPos: params.xPos,
    yPos: params.yPos,
    radius: params.radius,
  );
});

// 검색 파라미터 클래스
class PharmacySearchParams {
  final int pageNo;
  final int numOfRows;
  final String? sidoCd;
  final String? sgguCd;
  final String? emdongNm;
  final String? yadmNm;
  final double? xPos;
  final double? yPos;
  final int? radius;

  PharmacySearchParams({
    this.pageNo = 1,
    this.numOfRows = 10,
    this.sidoCd,
    this.sgguCd,
    this.emdongNm,
    this.yadmNm,
    this.xPos,
    this.yPos,
    this.radius,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PharmacySearchParams &&
          runtimeType == other.runtimeType &&
          pageNo == other.pageNo &&
          numOfRows == other.numOfRows &&
          sidoCd == other.sidoCd &&
          sgguCd == other.sgguCd &&
          emdongNm == other.emdongNm &&
          yadmNm == other.yadmNm &&
          xPos == other.xPos &&
          yPos == other.yPos &&
          radius == other.radius;

  @override
  int get hashCode =>
      pageNo.hashCode ^
      numOfRows.hashCode ^
      sidoCd.hashCode ^
      sgguCd.hashCode ^
      emdongNm.hashCode ^
      yadmNm.hashCode ^
      xPos.hashCode ^
      yPos.hashCode ^
      radius.hashCode;
}

// 시도 목록
final sidoListProvider = Provider<List<SidoItem>>((ref) {
  return [
    SidoItem(code: '110000', name: '서울특별시'),
    SidoItem(code: '210000', name: '부산광역시'),
    SidoItem(code: '220000', name: '대구광역시'),
    SidoItem(code: '230000', name: '인천광역시'),
    SidoItem(code: '240000', name: '광주광역시'),
    SidoItem(code: '250000', name: '대전광역시'),
    SidoItem(code: '260000', name: '울산광역시'),
    SidoItem(code: '310000', name: '경기도'),
    SidoItem(code: '320000', name: '강원도'),
    SidoItem(code: '330000', name: '충청북도'),
    SidoItem(code: '340000', name: '충청남도'),
    SidoItem(code: '350000', name: '전라북도'),
    SidoItem(code: '360000', name: '전라남도'),
    SidoItem(code: '370000', name: '경상북도'),
    SidoItem(code: '380000', name: '경상남도'),
    SidoItem(code: '390000', name: '제주특별자치도'),
    SidoItem(code: '410000', name: '세종특별자치시'),
  ];
});

class SidoItem {
  final String code;
  final String name;

  SidoItem({required this.code, required this.name});
}

// 시군구 목록 (시도 선택에 따라 동적으로 변경)
final sgguListProvider = Provider<List<SgguItem>>((ref) {
  final selectedSido = ref.watch(selectedSidoProvider);
  
  if (selectedSido == null) return [];
  
  // 각 시도별 시군구 목록
  switch (selectedSido) {
    case '110000': // 서울특별시
      return [
        SgguItem(code: '110016', name: '종로구'),
        SgguItem(code: '110017', name: '중구'),
        SgguItem(code: '110018', name: '용산구'),
        SgguItem(code: '110019', name: '성동구'),
        SgguItem(code: '110020', name: '광진구'),
        SgguItem(code: '110021', name: '동대문구'),
        SgguItem(code: '110022', name: '중랑구'),
        SgguItem(code: '110023', name: '성북구'),
        SgguItem(code: '110024', name: '강북구'),
        SgguItem(code: '110025', name: '도봉구'),
        SgguItem(code: '110026', name: '노원구'),
        SgguItem(code: '110027', name: '은평구'),
        SgguItem(code: '110028', name: '서대문구'),
        SgguItem(code: '110029', name: '마포구'),
        SgguItem(code: '110030', name: '양천구'),
        SgguItem(code: '110031', name: '강서구'),
        SgguItem(code: '110032', name: '구로구'),
        SgguItem(code: '110033', name: '금천구'),
        SgguItem(code: '110034', name: '영등포구'),
        SgguItem(code: '110035', name: '동작구'),
        SgguItem(code: '110036', name: '관악구'),
        SgguItem(code: '110037', name: '서초구'),
        SgguItem(code: '110038', name: '강남구'),
        SgguItem(code: '110039', name: '송파구'),
        SgguItem(code: '110040', name: '강동구'),
      ];
    case '210000': // 부산광역시
      return [
        SgguItem(code: '210011', name: '중구'),
        SgguItem(code: '210012', name: '서구'),
        SgguItem(code: '210013', name: '동구'),
        SgguItem(code: '210014', name: '영도구'),
        SgguItem(code: '210015', name: '부산진구'),
        SgguItem(code: '210016', name: '동래구'),
        SgguItem(code: '210017', name: '남구'),
        SgguItem(code: '210018', name: '북구'),
        SgguItem(code: '210019', name: '해운대구'),
        SgguItem(code: '210020', name: '사하구'),
        SgguItem(code: '210021', name: '금정구'),
        SgguItem(code: '210022', name: '강서구'),
        SgguItem(code: '210023', name: '연제구'),
        SgguItem(code: '210024', name: '수영구'),
        SgguItem(code: '210025', name: '사상구'),
        SgguItem(code: '210031', name: '기장군'),
      ];
    case '220000': // 대구광역시
      return [
        SgguItem(code: '220011', name: '중구'),
        SgguItem(code: '220012', name: '동구'),
        SgguItem(code: '220013', name: '서구'),
        SgguItem(code: '220014', name: '남구'),
        SgguItem(code: '220015', name: '북구'),
        SgguItem(code: '220016', name: '수성구'),
        SgguItem(code: '220017', name: '달서구'),
        SgguItem(code: '220031', name: '달성군'),
      ];
    case '230000': // 인천광역시
      return [
        SgguItem(code: '230013', name: '중구'),
        SgguItem(code: '230014', name: '동구'),
        SgguItem(code: '230016', name: '미추홀구'),
        SgguItem(code: '230017', name: '연수구'),
        SgguItem(code: '230018', name: '남동구'),
        SgguItem(code: '230019', name: '부평구'),
        SgguItem(code: '230020', name: '계양구'),
        SgguItem(code: '230021', name: '서구'),
        SgguItem(code: '230031', name: '강화군'),
        SgguItem(code: '230032', name: '옹진군'),
      ];
    case '310000': // 경기도
      return [
        SgguItem(code: '310011', name: '수원시'),
        SgguItem(code: '310012', name: '성남시'),
        SgguItem(code: '310013', name: '고양시'),
        SgguItem(code: '310014', name: '용인시'),
        SgguItem(code: '310015', name: '부천시'),
        SgguItem(code: '310016', name: '안산시'),
        SgguItem(code: '310017', name: '안양시'),
        SgguItem(code: '310018', name: '남양주시'),
        SgguItem(code: '310019', name: '화성시'),
        SgguItem(code: '310020', name: '평택시'),
        SgguItem(code: '310021', name: '의정부시'),
        SgguItem(code: '310022', name: '시흥시'),
        SgguItem(code: '310023', name: '파주시'),
        SgguItem(code: '310024', name: '광명시'),
        SgguItem(code: '310025', name: '김포시'),
        SgguItem(code: '310026', name: '군포시'),
        SgguItem(code: '310027', name: '광주시'),
        SgguItem(code: '310028', name: '이천시'),
        SgguItem(code: '310029', name: '양주시'),
        SgguItem(code: '310030', name: '오산시'),
        SgguItem(code: '310033', name: '구리시'),
        SgguItem(code: '310034', name: '안성시'),
        SgguItem(code: '310035', name: '포천시'),
        SgguItem(code: '310036', name: '의왕시'),
        SgguItem(code: '310037', name: '하남시'),
        SgguItem(code: '310038', name: '여주시'),
        SgguItem(code: '310041', name: '양평군'),
        SgguItem(code: '310042', name: '동두천시'),
        SgguItem(code: '310043', name: '과천시'),
        SgguItem(code: '310044', name: '가평군'),
        SgguItem(code: '310045', name: '연천군'),
      ];
    default:
      return [];
  }
});

class SgguItem {
  final String code;
  final String name;

  SgguItem({required this.code, required this.name});
} 