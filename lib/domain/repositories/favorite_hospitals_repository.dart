import '../../data/models/favorite_hospital.dart';

abstract class FavoriteHospitalsRepository {
  Future<List<FavoriteHospital>> getFavoriteHospitals(String userId);
  Future<void> addFavoriteHospital(String userId, String hospitalId);
  Future<void> removeFavoriteHospital(String userId, String hospitalId);
  Future<bool> isFavoriteHospital(String userId, String hospitalId);
}