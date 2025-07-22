import '../../data/models/hospital_model.dart';

abstract class HospitalRepository {
  Future<List<HospitalModel>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  });

  Future<List<HospitalModel>> searchHospitals({
    required String query,
    String? category,
    List<String>? departments,
  });

  Future<HospitalModel?> getHospitalById(String id);

  Future<List<HospitalModel>> getEmergencyHospitals({
    required double latitude,
    required double longitude,
  });

  Future<void> addToFavorites(String userId, String hospitalId);

  Future<void> removeFromFavorites(String userId, String hospitalId);

  Future<List<HospitalModel>> getFavoriteHospitals(String userId);
}