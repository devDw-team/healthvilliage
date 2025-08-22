import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/favorite_pharmacies_repository.dart';
import '../models/favorite_pharmacy.dart';

class FavoritePharmaciesRepositoryImpl implements FavoritePharmaciesRepository {
  final SupabaseClient _supabase;

  FavoritePharmaciesRepositoryImpl(this._supabase);

  @override
  Future<List<FavoritePharmacy>> getFavoritePharmacies(String userId) async {
    try {
      final response = await _supabase
          .from('user_favorite_pharmacies')
          .select('''
            id,
            user_id,
            pharmacy_id,
            created_at,
            pharmacies!inner(
              id,
              name,
              address,
              phone,
              latitude,
              longitude,
              operating_hours,
              is_night_pharmacy,
              is_holiday_open,
              rating,
              review_count,
              image_url
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((item) {
        final pharmacy = item['pharmacies'] as Map<String, dynamic>;
        return FavoritePharmacy(
          id: pharmacy['id'] as String,
          favoriteId: item['id'] as String,
          userId: item['user_id'] as String,
          pharmacyId: item['pharmacy_id'] as String,
          name: pharmacy['name'] as String,
          address: pharmacy['address'] as String,
          phone: pharmacy['phone'] as String?,
          latitude: (pharmacy['latitude'] as num).toDouble(),
          longitude: (pharmacy['longitude'] as num).toDouble(),
          operatingHours: pharmacy['operating_hours'] as Map<String, dynamic>?,
          isNightPharmacy: pharmacy['is_night_pharmacy'] as bool?,
          isHolidayOpen: pharmacy['is_holiday_open'] as bool?,
          rating: (pharmacy['rating'] as num?)?.toDouble(),
          reviewCount: pharmacy['review_count'] as int?,
          imageUrl: pharmacy['image_url'] as String?,
          favoritedAt: DateTime.parse(item['created_at'] as String),
        );
      }).toList();
    } catch (e) {
      throw Exception('즐겨찾기 약국 목록을 가져오는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> addFavoritePharmacy(String userId, String pharmacyId) async {
    try {
      await _supabase.from('user_favorite_pharmacies').insert({
        'user_id': userId,
        'pharmacy_id': pharmacyId,
      });
    } catch (e) {
      throw Exception('약국을 즐겨찾기에 추가하는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> removeFavoritePharmacy(String userId, String pharmacyId) async {
    try {
      await _supabase
          .from('user_favorite_pharmacies')
          .delete()
          .eq('user_id', userId)
          .eq('pharmacy_id', pharmacyId);
    } catch (e) {
      throw Exception('약국을 즐겨찾기에서 제거하는데 실패했습니다: $e');
    }
  }

  @override
  Future<bool> isFavoritePharmacy(String userId, String pharmacyId) async {
    try {
      final response = await _supabase
          .from('user_favorite_pharmacies')
          .select('id')
          .eq('user_id', userId)
          .eq('pharmacy_id', pharmacyId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }
}