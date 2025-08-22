// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteHospitalImpl _$$FavoriteHospitalImplFromJson(
        Map<String, dynamic> json) =>
    _$FavoriteHospitalImpl(
      id: json['id'] as String,
      favoriteId: json['favoriteId'] as String,
      userId: json['userId'] as String,
      hospitalId: json['hospitalId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String?,
      operatingHours: json['operatingHours'] as Map<String, dynamic>?,
      departments: (json['departments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      isEmergencyAvailable: json['isEmergencyAvailable'] as bool?,
      isParkingAvailable: json['isParkingAvailable'] as bool?,
      imageUrl: json['imageUrl'] as String?,
      favoritedAt: DateTime.parse(json['favoritedAt'] as String),
    );

Map<String, dynamic> _$$FavoriteHospitalImplToJson(
        _$FavoriteHospitalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favoriteId': instance.favoriteId,
      'userId': instance.userId,
      'hospitalId': instance.hospitalId,
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
      'favoritedAt': instance.favoritedAt.toIso8601String(),
    };
