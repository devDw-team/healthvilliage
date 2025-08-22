import '../repositories/favorite_hospitals_repository.dart';
import '../../data/models/favorite_hospital.dart';

class ManageFavoriteHospitalsUseCase {
  final FavoriteHospitalsRepository repository;

  ManageFavoriteHospitalsUseCase(this.repository);

  Future<List<FavoriteHospital>> getFavoriteHospitals(String userId) {
    return repository.getFavoriteHospitals(userId);
  }

  Future<void> addToFavorites(String userId, String hospitalId) {
    return repository.addFavoriteHospital(userId, hospitalId);
  }

  Future<void> removeFromFavorites(String userId, String hospitalId) {
    return repository.removeFavoriteHospital(userId, hospitalId);
  }

  Future<bool> isFavorite(String userId, String hospitalId) {
    return repository.isFavoriteHospital(userId, hospitalId);
  }

  Future<void> toggleFavorite(String userId, String hospitalId) async {
    final isFav = await isFavorite(userId, hospitalId);
    if (isFav) {
      await removeFromFavorites(userId, hospitalId);
    } else {
      await addToFavorites(userId, hospitalId);
    }
  }
}