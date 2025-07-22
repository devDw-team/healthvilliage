import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart' as xml;

part 'hospital_model.g.dart';

@JsonSerializable()
class HospitalModel {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double latitude;
  final double longitude;
  final String? category;
  final String? operatingHours;
  final List<String>? departments;
  final double? rating;
  final int? reviewCount;
  final bool isEmergencyAvailable;
  final bool isParkingAvailable;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // HIRA API 전용 필드
  final String? ykiho; // 암호화된 요양기호
  final String? clCd; // 종별코드
  final String? clCdNm; // 종별코드명
  final String? sidoCd; // 시도코드
  final String? sidoCdNm; // 시도명
  final String? sgguCd; // 시군구코드
  final String? sgguCdNm; // 시군구명
  final String? emdongNm; // 읍면동명
  final String? postNo; // 우편번호
  final String? estbDd; // 개설일자
  final double? distance; // 거리(미터)
  final String? drTotCnt; // 의사총수
  final String? gdrCnt; // 일반의 수
  final String? intnCnt; // 인턴 수
  final String? resdntCnt; // 레지던트 수
  final String? sdrCnt; // 전문의 수

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.latitude,
    required this.longitude,
    this.category,
    this.operatingHours,
    this.departments,
    this.rating,
    this.reviewCount,
    this.isEmergencyAvailable = false,
    this.isParkingAvailable = false,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.ykiho,
    this.clCd,
    this.clCdNm,
    this.sidoCd,
    this.sidoCdNm,
    this.sgguCd,
    this.sgguCdNm,
    this.emdongNm,
    this.postNo,
    this.estbDd,
    this.distance,
    this.drTotCnt,
    this.gdrCnt,
    this.intnCnt,
    this.resdntCnt,
    this.sdrCnt,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalModelFromJson(json);

  Map<String, dynamic> toJson() => _$HospitalModelToJson(this);

  // HIRA API XML 파싱용 factory
  factory HospitalModel.fromXml(xml.XmlElement element) {
    String getElementText(String name) {
      try {
        return element.findElements(name).first.text;
      } catch (e) {
        return '';
      }
    }

    double? getElementDouble(String name) {
      try {
        final text = element.findElements(name).first.text;
        return double.parse(text);
      } catch (e) {
        return null;
      }
    }

    final ykiho = getElementText('ykiho');
    final name = getElementText('yadmNm');
    final address = getElementText('addr');
    final phone = getElementText('telno');
    final xPos = getElementDouble('XPos') ?? 0.0;
    final yPos = getElementDouble('YPos') ?? 0.0;
    final clCd = getElementText('clCd');
    final clCdNm = getElementText('clCdNm');

    return HospitalModel(
      id: ykiho.isNotEmpty ? ykiho : DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: address,
      phone: phone.isNotEmpty ? phone : null,
      latitude: yPos,
      longitude: xPos,
      category: clCdNm,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isEmergencyAvailable: clCd == '11' || clCd == '21' || clCd == '31', // 종합병원, 병원, 의원 중 응급실 운영
      // HIRA API 전용 필드
      ykiho: ykiho,
      clCd: clCd,
      clCdNm: clCdNm,
      sidoCd: getElementText('sidoCd'),
      sidoCdNm: getElementText('sidoCdNm'),
      sgguCd: getElementText('sgguCd'),
      sgguCdNm: getElementText('sgguCdNm'),
      emdongNm: getElementText('emdongNm'),
      postNo: getElementText('postNo'),
      estbDd: getElementText('estbDd'),
      distance: getElementDouble('distance'),
      drTotCnt: getElementText('drTotCnt'),
      gdrCnt: getElementText('gdrCnt'),
      intnCnt: getElementText('intnCnt'),
      resdntCnt: getElementText('resdntCnt'),
      sdrCnt: getElementText('sdrCnt'),
    );
  }

  HospitalModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? category,
    String? operatingHours,
    List<String>? departments,
    double? rating,
    int? reviewCount,
    bool? isEmergencyAvailable,
    bool? isParkingAvailable,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ykiho,
    String? clCd,
    String? clCdNm,
    String? sidoCd,
    String? sidoCdNm,
    String? sgguCd,
    String? sgguCdNm,
    String? emdongNm,
    String? postNo,
    String? estbDd,
    double? distance,
    String? drTotCnt,
    String? gdrCnt,
    String? intnCnt,
    String? resdntCnt,
    String? sdrCnt,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      operatingHours: operatingHours ?? this.operatingHours,
      departments: departments ?? this.departments,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isEmergencyAvailable: isEmergencyAvailable ?? this.isEmergencyAvailable,
      isParkingAvailable: isParkingAvailable ?? this.isParkingAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ykiho: ykiho ?? this.ykiho,
      clCd: clCd ?? this.clCd,
      clCdNm: clCdNm ?? this.clCdNm,
      sidoCd: sidoCd ?? this.sidoCd,
      sidoCdNm: sidoCdNm ?? this.sidoCdNm,
      sgguCd: sgguCd ?? this.sgguCd,
      sgguCdNm: sgguCdNm ?? this.sgguCdNm,
      emdongNm: emdongNm ?? this.emdongNm,
      postNo: postNo ?? this.postNo,
      estbDd: estbDd ?? this.estbDd,
      distance: distance ?? this.distance,
      drTotCnt: drTotCnt ?? this.drTotCnt,
      gdrCnt: gdrCnt ?? this.gdrCnt,
      intnCnt: intnCnt ?? this.intnCnt,
      resdntCnt: resdntCnt ?? this.resdntCnt,
      sdrCnt: sdrCnt ?? this.sdrCnt,
    );
  }
}