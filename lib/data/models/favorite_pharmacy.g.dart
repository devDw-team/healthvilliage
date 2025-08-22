// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_pharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoritePharmacyImpl _$$FavoritePharmacyImplFromJson(
        Map<String, dynamic> json) =>
    _$FavoritePharmacyImpl(
      id: json['id'] as String,
      favoriteId: json['favoriteId'] as String,
      userId: json['userId'] as String,
      pharmacyId: json['pharmacyId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      operatingHours: json['operatingHours'] as Map<String, dynamic>?,
      isNightPharmacy: json['isNightPharmacy'] as bool?,
      isHolidayOpen: json['isHolidayOpen'] as bool?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      favoritedAt: DateTime.parse(json['favoritedAt'] as String),
    );

Map<String, dynamic> _$$FavoritePharmacyImplToJson(
        _$FavoritePharmacyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favoriteId': instance.favoriteId,
      'userId': instance.userId,
      'pharmacyId': instance.pharmacyId,
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
      'favoritedAt': instance.favoritedAt.toIso8601String(),
    };
