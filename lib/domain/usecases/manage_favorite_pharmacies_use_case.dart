import '../repositories/favorite_pharmacies_repository.dart';
import '../../data/models/favorite_pharmacy.dart';

class ManageFavoritePharmaciesUseCase {
  final FavoritePharmaciesRepository repository;

  ManageFavoritePharmaciesUseCase(this.repository);

  Future<List<FavoritePharmacy>> getFavoritePharmacies(String userId) {
    return repository.getFavoritePharmacies(userId);
  }

  Future<void> addToFavorites(String userId, String pharmacyId) {
    return repository.addFavoritePharmacy(userId, pharmacyId);
  }

  Future<void> removeFromFavorites(String userId, String pharmacyId) {
    return repository.removeFavoritePharmacy(userId, pharmacyId);
  }

  Future<bool> isFavorite(String userId, String pharmacyId) {
    return repository.isFavoritePharmacy(userId, pharmacyId);
  }

  Future<void> toggleFavorite(String userId, String pharmacyId) async {
    final isFav = await isFavorite(userId, pharmacyId);
    if (isFav) {
      await removeFromFavorites(userId, pharmacyId);
    } else {
      await addToFavorites(userId, pharmacyId);
    }
  }
}