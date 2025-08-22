import '../../data/models/favorite_pharmacy.dart';

abstract class FavoritePharmaciesRepository {
  Future<List<FavoritePharmacy>> getFavoritePharmacies(String userId);
  Future<void> addFavoritePharmacy(String userId, String pharmacyId);
  Future<void> removeFavoritePharmacy(String userId, String pharmacyId);
  Future<bool> isFavoritePharmacy(String userId, String pharmacyId);
}