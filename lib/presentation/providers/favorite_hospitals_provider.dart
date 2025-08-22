import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/favorite_hospital.dart';
import '../../data/repositories/favorite_hospitals_repository_impl.dart';
import '../../domain/repositories/favorite_hospitals_repository.dart';
import '../../domain/usecases/manage_favorite_hospitals_use_case.dart';
import 'auth_provider.dart';

// Repository Provider
final favoriteHospitalsRepositoryProvider = Provider<FavoriteHospitalsRepository>((ref) {
  final supabase = Supabase.instance.client;
  return FavoriteHospitalsRepositoryImpl(supabase);
});

// Use Case Provider
final manageFavoriteHospitalsUseCaseProvider = Provider<ManageFavoriteHospitalsUseCase>((ref) {
  final repository = ref.watch(favoriteHospitalsRepositoryProvider);
  return ManageFavoriteHospitalsUseCase(repository);
});

// Favorite Hospitals State Provider
final favoriteHospitalsProvider = StateNotifierProvider<FavoriteHospitalsNotifier, AsyncValue<List<FavoriteHospital>>>((ref) {
  final useCase = ref.watch(manageFavoriteHospitalsUseCaseProvider);
  return FavoriteHospitalsNotifier(useCase, ref);
});

// 특정 병원이 즐겨찾기인지 확인하는 Provider
final isHospitalFavoriteProvider = FutureProvider.family<bool, String>((ref, hospitalId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  
  final useCase = ref.watch(manageFavoriteHospitalsUseCaseProvider);
  return await useCase.isFavorite(user.id, hospitalId);
});

class FavoriteHospitalsNotifier extends StateNotifier<AsyncValue<List<FavoriteHospital>>> {
  final ManageFavoriteHospitalsUseCase _useCase;
  final Ref _ref;

  FavoriteHospitalsNotifier(this._useCase, this._ref) : super(const AsyncValue.data([])) {
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
      final favorites = await _useCase.getFavoriteHospitals(userId);
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(String hospitalId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }

    try {
      await _useCase.toggleFavorite(user.id, hospitalId);
      await loadFavorites(user.id);
      
      // 개별 즐겨찾기 상태 Provider 새로고침
      _ref.invalidate(isHospitalFavoriteProvider(hospitalId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addFavorite(String hospitalId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }

    try {
      await _useCase.addToFavorites(user.id, hospitalId);
      await loadFavorites(user.id);
      _ref.invalidate(isHospitalFavoriteProvider(hospitalId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeFavorite(String hospitalId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }

    try {
      await _useCase.removeFromFavorites(user.id, hospitalId);
      await loadFavorites(user.id);
      _ref.invalidate(isHospitalFavoriteProvider(hospitalId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool isFavorite(String hospitalId) {
    return state.whenOrNull(
      data: (favorites) => favorites.any((hospital) => hospital.hospitalId == hospitalId),
    ) ?? false;
  }
}