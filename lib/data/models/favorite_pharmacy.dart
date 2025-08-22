import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_pharmacy.freezed.dart';
part 'favorite_pharmacy.g.dart';

@freezed
class FavoritePharmacy with _$FavoritePharmacy {
  const factory FavoritePharmacy({
    required String id,
    required String favoriteId,
    required String userId,
    required String pharmacyId,
    required String name,
    required String address,
    String? phone,
    required double latitude,
    required double longitude,
    Map<String, dynamic>? operatingHours,
    bool? isNightPharmacy,
    bool? isHolidayOpen,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    required DateTime favoritedAt,
  }) = _FavoritePharmacy;

  factory FavoritePharmacy.fromJson(Map<String, dynamic> json) =>
      _$FavoritePharmacyFromJson(json);

  factory FavoritePharmacy.fromSupabase(Map<String, dynamic> json) {
    return FavoritePharmacy(
      id: json['id'] as String,
      favoriteId: json['favorite_id'] as String,
      userId: json['user_id'] as String,
      pharmacyId: json['pharmacy_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      operatingHours: json['operating_hours'] as Map<String, dynamic>?,
      isNightPharmacy: json['is_night_pharmacy'] as bool?,
      isHolidayOpen: json['is_holiday_open'] as bool?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      imageUrl: json['image_url'] as String?,
      favoritedAt: DateTime.parse(json['favorited_at'] as String),
    );
  }
}