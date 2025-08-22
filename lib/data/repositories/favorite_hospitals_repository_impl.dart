import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/favorite_hospitals_repository.dart';
import '../models/favorite_hospital.dart';

class FavoriteHospitalsRepositoryImpl implements FavoriteHospitalsRepository {
  final SupabaseClient _supabase;

  FavoriteHospitalsRepositoryImpl(this._supabase);

  @override
  Future<List<FavoriteHospital>> getFavoriteHospitals(String userId) async {
    try {
      final response = await _supabase
          .from('user_favorite_hospitals')
          .select('''
            id,
            user_id,
            hospital_id,
            created_at,
            hospitals!inner(
              id,
              name,
              address,
              phone,
              latitude,
              longitude,
              category,
              operating_hours,
              departments,
              rating,
              review_count,
              is_emergency_available,
              is_parking_available,
              image_url
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((item) {
        final hospital = item['hospitals'] as Map<String, dynamic>;
        return FavoriteHospital(
          id: hospital['id'] as String,
          favoriteId: item['id'] as String,
          userId: item['user_id'] as String,
          hospitalId: item['hospital_id'] as String,
          name: hospital['name'] as String,
          address: hospital['address'] as String,
          phone: hospital['phone'] as String?,
          latitude: (hospital['latitude'] as num).toDouble(),
          longitude: (hospital['longitude'] as num).toDouble(),
          category: hospital['category'] as String?,
          operatingHours: hospital['operating_hours'] as Map<String, dynamic>?,
          departments: (hospital['departments'] as List<dynamic>?)?.cast<String>(),
          rating: (hospital['rating'] as num?)?.toDouble(),
          reviewCount: hospital['review_count'] as int?,
          isEmergencyAvailable: hospital['is_emergency_available'] as bool?,
          isParkingAvailable: hospital['is_parking_available'] as bool?,
          imageUrl: hospital['image_url'] as String?,
          favoritedAt: DateTime.parse(item['created_at'] as String),
        );
      }).toList();
    } catch (e) {
      throw Exception('즐겨찾기 병원 목록을 가져오는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> addFavoriteHospital(String userId, String hospitalId) async {
    try {
      await _supabase.from('user_favorite_hospitals').insert({
        'user_id': userId,
        'hospital_id': hospitalId,
      });
    } catch (e) {
      throw Exception('병원을 즐겨찾기에 추가하는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> removeFavoriteHospital(String userId, String hospitalId) async {
    try {
      await _supabase
          .from('user_favorite_hospitals')
          .delete()
          .eq('user_id', userId)
          .eq('hospital_id', hospitalId);
    } catch (e) {
      throw Exception('병원을 즐겨찾기에서 제거하는데 실패했습니다: $e');
    }
  }

  @override
  Future<bool> isFavoriteHospital(String userId, String hospitalId) async {
    try {
      final response = await _supabase
          .from('user_favorite_hospitals')
          .select('id')
          .eq('user_id', userId)
          .eq('hospital_id', hospitalId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }
}