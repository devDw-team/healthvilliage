import '../../core/services/supabase_service.dart';
import '../../domain/repositories/hospital_repository.dart';
import '../models/hospital_model.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final SupabaseService _supabaseService;

  HospitalRepositoryImpl(this._supabaseService);

  @override
  Future<List<HospitalModel>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) async {
    try {
      // Using PostGIS extension in Supabase for geospatial queries
      final response = await _supabaseService.client
          .rpc('get_nearby_hospitals', params: {
        'lat': latitude,
        'long': longitude,
        'radius_km': radiusInKm,
      });

      return (response as List)
          .map((data) => HospitalModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get nearby hospitals: $e');
    }
  }

  @override
  Future<List<HospitalModel>> searchHospitals({
    required String query,
    String? category,
    List<String>? departments,
  }) async {
    try {
      var queryBuilder = _supabaseService
          .from('hospitals')
          .select()
          .ilike('name', '%$query%');

      if (category != null) {
        queryBuilder = queryBuilder.eq('category', category);
      }

      if (departments != null && departments.isNotEmpty) {
        queryBuilder = queryBuilder.contains('departments', departments);
      }

      final response = await queryBuilder.limit(50);

      return (response as List)
          .map((data) => HospitalModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to search hospitals: $e');
    }
  }

  @override
  Future<HospitalModel?> getHospitalById(String id) async {
    try {
      final response = await _supabaseService
          .from('hospitals')
          .select()
          .eq('id', id)
          .single();

      return HospitalModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<HospitalModel>> getEmergencyHospitals({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _supabaseService.client
          .rpc('get_emergency_hospitals', params: {
        'lat': latitude,
        'long': longitude,
      });

      return (response as List)
          .map((data) => HospitalModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get emergency hospitals: $e');
    }
  }

  @override
  Future<void> addToFavorites(String userId, String hospitalId) async {
    try {
      await _supabaseService.from('user_favorite_hospitals').insert({
        'user_id': userId,
        'hospital_id': hospitalId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String userId, String hospitalId) async {
    try {
      await _supabaseService
          .from('user_favorite_hospitals')
          .delete()
          .eq('user_id', userId)
          .eq('hospital_id', hospitalId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<List<HospitalModel>> getFavoriteHospitals(String userId) async {
    try {
      final response = await _supabaseService
          .from('user_favorite_hospitals')
          .select('*, hospitals(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((data) => HospitalModel.fromJson(data['hospitals']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite hospitals: $e');
    }
  }
}