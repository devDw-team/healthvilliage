import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/favorite_pharmacy.dart';
import '../../data/repositories/favorite_pharmacies_repository_impl.dart';
import '../../domain/repositories/favorite_pharmacies_repository.dart';
import '../../domain/usecases/manage_favorite_pharmacies_use_case.dart';
import 'auth_provider.dart';

// Repository Provider
final favoritePharmaciesRepositoryProvider = Provider<FavoritePharmaciesRepository>((ref) {
  final supabase = Supabase.instance.client;
  return FavoritePharmaciesRepositoryImpl(supabase);
});

// Use Case Provider
final manageFavoritePharmaciesUseCaseProvider = Provider<ManageFavoritePharmaciesUseCase>((ref) {
  final repository = ref.watch(favoritePharmaciesRepositoryProvider);
  return ManageFavoritePharmaciesUseCase(repository);
});

// Favorite Pharmacies State Provider
final favoritePharmaciesProvider = StateNotifierProvider<FavoritePharmaciesNotifier, AsyncValue<List<FavoritePharmacy>>>((ref) {
  final useCase = ref.watch(manageFavoritePharmaciesUseCaseProvider);
  return FavoritePharmaciesNotifier(useCase, ref);
});

// 특정 약국이 즐겨찾기인지 확인하는 Provider
final isPharmacyFavoriteProvider = FutureProvider.family<bool, String>((ref, pharmacyId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  
  final useCase = ref.watch(manageFavoritePharmaciesUseCaseProvider);
  return await useCase.isFavorite(user.id, pharmacyId);
});

class FavoritePharmaciesNotifier extends StateNotifier<AsyncValue<List<FavoritePharmacy>>> {
  final ManageFavoritePharmaciesUseCase _useCase;
  final Ref _ref;

  FavoritePharmaciesNotifier(this._useCase, this._ref) : super(const AsyncValue.data([])) {
    _init();
  }

  void _init() {
    _ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          loadFavorites(user.id);
        } else {
          state = const AsyncValue.data([]);
        }
      });
    });
  }

  Future<void> loadFavorites(String userId) async {
    state = const AsyncValue.loading();
    try {
      final favorites = await _useCase.getFavoritePharmacies(userId);
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(String pharmacyId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }

    try {
      await _useCase.toggleFavorite(user.id, pharmacyId);
      await loadFavorites(user.id);
      
      // 개별 즐겨찾기 상태 Provider 새로고침
      _ref.invalidate(isPharmacyFavoriteProvider(pharmacyId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addFavorite(String pharmacyId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }

    try {
      await _useCase.addToFavorites(user.id, pharmacyId);
      await loadFavorites(user.id);
      _ref.invalidate(isPharmacyFavoriteProvider(pharmacyId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeFavorite(String pharmacyId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }

    try {
      await _useCase.removeFromFavorites(user.id, pharmacyId);
      await loadFavorites(user.id);
      _ref.invalidate(isPharmacyFavoriteProvider(pharmacyId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool isFavorite(String pharmacyId) {
    return state.whenOrNull(
      data: (favorites) => favorites.any((pharmacy) => pharmacy.pharmacyId == pharmacyId),
    ) ?? false;
  }
}