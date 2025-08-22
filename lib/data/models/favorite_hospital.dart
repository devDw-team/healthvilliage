import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_hospital.freezed.dart';
part 'favorite_hospital.g.dart';

@freezed
class FavoriteHospital with _$FavoriteHospital {
  const factory FavoriteHospital({
    required String id,
    required String favoriteId,
    required String userId,
    required String hospitalId,
    required String name,
    required String address,
    String? phone,
    required double latitude,
    required double longitude,
    String? category,
    Map<String, dynamic>? operatingHours,
    List<String>? departments,
    double? rating,
    int? reviewCount,
    bool? isEmergencyAvailable,
    bool? isParkingAvailable,
    String? imageUrl,
    required DateTime favoritedAt,
  }) = _FavoriteHospital;

  factory FavoriteHospital.fromJson(Map<String, dynamic> json) =>
      _$FavoriteHospitalFromJson(json);

  factory FavoriteHospital.fromSupabase(Map<String, dynamic> json) {
    return FavoriteHospital(
      id: json['id'] as String,
      favoriteId: json['favorite_id'] as String,
      userId: json['user_id'] as String,
      hospitalId: json['hospital_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String?,
      operatingHours: json['operating_hours'] as Map<String, dynamic>?,
      departments: (json['departments'] as List<dynamic>?)?.cast<String>(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      isEmergencyAvailable: json['is_emergency_available'] as bool?,
      isParkingAvailable: json['is_parking_available'] as bool?,
      imageUrl: json['image_url'] as String?,
      favoritedAt: DateTime.parse(json['favorited_at'] as String),
    );
  }
}