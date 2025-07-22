import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart' as xml;

part 'pharmacy_model.g.dart';

@JsonSerializable()
class PharmacyModel {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double latitude;
  final double longitude;
  final String? operatingHours;
  final bool isNightPharmacy;
  final bool isHolidayOpen;
  final double? rating;
  final int? reviewCount;
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

  PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.latitude,
    required this.longitude,
    this.operatingHours,
    this.isNightPharmacy = false,
    this.isHolidayOpen = false,
    this.rating,
    this.reviewCount,
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
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) =>
      _$PharmacyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyModelToJson(this);

  // HIRA API XML 파싱용 factory
  factory PharmacyModel.fromXml(xml.XmlElement element) {
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

    return PharmacyModel(
      id: ykiho.isNotEmpty ? ykiho : DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: address,
      phone: phone.isNotEmpty ? phone : null,
      latitude: yPos,
      longitude: xPos,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      // HIRA API 전용 필드
      ykiho: ykiho,
      clCd: getElementText('clCd'),
      clCdNm: getElementText('clCdNm'),
      sidoCd: getElementText('sidoCd'),
      sidoCdNm: getElementText('sidoCdNm'),
      sgguCd: getElementText('sgguCd'),
      sgguCdNm: getElementText('sgguCdNm'),
      emdongNm: getElementText('emdongNm'),
      postNo: getElementText('postNo'),
      estbDd: getElementText('estbDd'),
      distance: getElementDouble('distance'),
    );
  }

  PharmacyModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? operatingHours,
    bool? isNightPharmacy,
    bool? isHolidayOpen,
    double? rating,
    int? reviewCount,
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
  }) {
    return PharmacyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      operatingHours: operatingHours ?? this.operatingHours,
      isNightPharmacy: isNightPharmacy ?? this.isNightPharmacy,
      isHolidayOpen: isHolidayOpen ?? this.isHolidayOpen,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
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
    );
  }
}