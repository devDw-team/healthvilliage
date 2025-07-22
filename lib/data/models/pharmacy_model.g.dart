// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PharmacyModel _$PharmacyModelFromJson(Map<String, dynamic> json) =>
    PharmacyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      operatingHours: json['operatingHours'] as String?,
      isNightPharmacy: json['isNightPharmacy'] as bool? ?? false,
      isHolidayOpen: json['isHolidayOpen'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
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
    );

Map<String, dynamic> _$PharmacyModelToJson(PharmacyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'operatingHours': instance.operatingHours,
      'isNightPharmacy': instance.isNightPharmacy,
      'isHolidayOpen': instance.isHolidayOpen,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
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
    };
