import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

// Supabase Provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.instance.client;
});

// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return UserRepositoryImpl(supabase);
});

// Current User State Provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserEntity?>>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final Ref _ref;

  CurrentUserNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      // 초기 로딩이 아닌 경우 기존 데이터 유지
      if (state.value == null) {
        state = const AsyncValue.loading();
      }
      
      final repository = _ref.read(userRepositoryProvider);
      final user = await repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUser(UserEntity user) async {
    try {
      // 기존 사용자 데이터를 유지하면서 loading 상태 표시
      final currentUser = state.value;
      if (currentUser != null) {
        state = AsyncValue.data(currentUser);
      }
      
      final repository = _ref.read(userRepositoryProvider);
      final updatedUser = await repository.updateUser(user);
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      // 에러 발생 시에도 기존 사용자 데이터 유지
      final currentUser = state.value;
      if (currentUser != null) {
        state = AsyncValue.data(currentUser);
      }
      // 에러는 별도로 throw하여 UI에서 처리
      throw e;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final repository = _ref.read(userRepositoryProvider);
      return await repository.uploadProfileImage(imageFile);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyPassword(String password) async {
    try {
      final repository = _ref.read(userRepositoryProvider);
      return await repository.verifyPassword(password);
    } catch (e) {
      return false;
    }
  }
}