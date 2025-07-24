import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'supabase_providers.dart';

// Auth state notifier
class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    print('[AuthStateNotifier] _init 시작');
    try {
      final user = await _authRepository.getCurrentUser();
      print('[AuthStateNotifier] 초기 사용자: $user');
      state = AsyncValue.data(user);
    } catch (e, stack) {
      print('[AuthStateNotifier] 초기 사용자 조회 실패: $e');
      // If there's an error getting the current user (e.g., not authenticated),
      // set state to null instead of error
      state = const AsyncValue.data(null);
    }

    // Listen to auth state changes
    _authRepository.authStateChanges().listen((authState) async {
      print('[AuthStateNotifier] Auth 상태 변경 감지: ${authState.event}');
      print('[AuthStateNotifier] 세션 존재: ${authState.session != null}');
      
      if (authState.session != null) {
        try {
          final user = await _authRepository.getCurrentUser();
          print('[AuthStateNotifier] 사용자 프로필 조회 성공: $user');
          state = AsyncValue.data(user);
        } catch (e, stack) {
          print('[AuthStateNotifier] 사용자 프로필 조회 실패: $e');
          // If there's an error getting the user profile, set to null
          state = const AsyncValue.data(null);
        }
      } else {
        print('[AuthStateNotifier] 세션 없음, 로그아웃 상태로 설정');
        state = const AsyncValue.data(null);
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    print('[AuthStateNotifier] signIn 시작');
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      print('[AuthStateNotifier] signIn 성공, user: $user');
      state = AsyncValue.data(user);
      print('[AuthStateNotifier] state 업데이트 완료: $state');
      // 상태 업데이트가 UI에 반영될 시간을 줌
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e, stack) {
      print('[AuthStateNotifier] signIn 실패: $e');
      // 오류가 발생해도 null 상태로 설정 (로그아웃 상태)
      state = const AsyncValue.data(null);
      rethrow;
    }
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      state = AsyncValue.data(user);
      return user;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    // 기존 사용자 데이터를 유지하면서 업데이트
    try {
      final updatedUser = await _authRepository.updateProfile(
        userId: currentUser.id,
        name: name,
        phone: phone,
        birthDate: birthDate,
        gender: gender,
        profileImageUrl: profileImageUrl,
      );
      state = AsyncValue.data(updatedUser);
    } catch (e, stack) {
      // 에러 발생 시에도 기존 사용자 데이터 유지
      state = AsyncValue.data(currentUser);
      rethrow;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    final currentUser = state.value;
    if (currentUser == null) return null;

    try {
      return await _authRepository.uploadProfileImage(currentUser.id, imageFile);
    } catch (e) {
      print('[AuthStateNotifier] uploadProfileImage 오류: $e');
      return null;
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    await _authRepository.resendConfirmationEmail(email);
  }

  Future<bool> verifyPassword(String password) async {
    try {
      final currentUser = state.value;
      if (currentUser == null) return false;
      
      // 별도의 verifyPassword 메서드 사용 (세션에 영향 없음)
      return await _authRepository.verifyPassword(
        currentUser.email,
        password,
      );
    } catch (e) {
      return false;
    }
  }
}

// Auth state provider
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(authRepository);
});

// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(
    data: (user) => user,
  );
});

// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(
        data: (user) => user != null,
      ) ??
      false;
});