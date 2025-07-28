import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/medicine.dart';
import '../../domain/usecases/manage_favorite_medicines_use_case.dart';
import 'medicine_provider.dart';

// Favorite Medicines State Provider
final favoriteMedicinesProvider = StateNotifierProvider<FavoriteMedicinesNotifier, AsyncValue<List<Medicine>>>((ref) {
  final useCase = ref.watch(manageFavoriteMedicinesUseCaseProvider);
  return FavoriteMedicinesNotifier(useCase);
});

class FavoriteMedicinesNotifier extends StateNotifier<AsyncValue<List<Medicine>>> {
  final ManageFavoriteMedicinesUseCase _useCase;

  FavoriteMedicinesNotifier(this._useCase) : super(const AsyncValue.data([]));

  Future<void> loadFavorites(String userId) async {
    state = const AsyncValue.loading();
    try {
      final favorites = await _useCase.getFavoriteMedicines(userId);
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addFavorite(String userId, String medicineId) async {
    try {
      await _useCase.addToFavorites(userId, medicineId);
      // 즐겨찾기 목록 다시 로드
      await loadFavorites(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeFavorite(String userId, String medicineId) async {
    try {
      await _useCase.removeFromFavorites(userId, medicineId);
      // 즐겨찾기 목록 다시 로드
      await loadFavorites(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool isFavorite(String medicineId) {
    return state.whenOrNull(
      data: (favorites) => favorites.any((medicine) => medicine.id == medicineId),
    ) ?? false;
  }
}