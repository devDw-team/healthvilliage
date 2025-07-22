// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalModel _$HospitalModelFromJson(Map<String, dynamic> json) =>
    HospitalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String?,
      operatingHours: json['operatingHours'] as String?,
      departments: (json['departments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      isEmergencyAvailable: json['isEmergencyAvailable'] as bool? ?? false,
      isParkingAvailable: json['isParkingAvailable'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ykiho: json['ykiho'] as String?,
      clCd: json['clCd'] as String?,
      clCdNm: json['clCdNm'] as String?,
      sidoCd: json['sidoCd'] as String?,
      sidoCdNm: json['sidoCdNm'] as String?,
      sgguCd: json['sgguCd'] as String?,
      sgguCdNm: json['sgguCdNm'] as String?,
      emdongNm: json['emdongNm'] as String?,
      postNo: json['postNo'] as String?,
      estbDd: json['estbDd'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      drTotCnt: json['drTotCnt'] as String?,
      gdrCnt: json['gdrCnt'] as String?,
      intnCnt: json['intnCnt'] as String?,
      resdntCnt: json['resdntCnt'] as String?,
      sdrCnt: json['sdrCnt'] as String?,
    );

Map<String, dynamic> _$HospitalModelToJson(HospitalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category': instance.category,
      'operatingHours': instance.operatingHours,
      'departments': instance.departments,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'isEmergencyAvailable': instance.isEmergencyAvailable,
      'isParkingAvailable': instance.isParkingAvailable,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ykiho': instance.ykiho,
      'clCd': instance.clCd,
      'clCdNm': instance.clCdNm,
      'sidoCd': instance.sidoCd,
      'sidoCdNm': instance.sidoCdNm,
      'sgguCd': instance.sgguCd,
      'sgguCdNm': instance.sgguCdNm,
      'emdongNm': instance.emdongNm,
      'postNo': instance.postNo,
      'estbDd': instance.estbDd,
      'distance': instance.distance,
      'drTotCnt': instance.drTotCnt,
      'gdrCnt': instance.gdrCnt,
      'intnCnt': instance.intnCnt,
      'resdntCnt': instance.resdntCnt,
      'sdrCnt': instance.sdrCnt,
    };
