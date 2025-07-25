import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/services/supabase_service.dart';
import 'supabase_providers.dart';

final passwordChangeProvider = StateNotifierProvider<PasswordChangeNotifier, PasswordChangeState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return PasswordChangeNotifier(authRepository);
});

class PasswordChangeState {
  final bool isLoading;
  final String? error;
  final bool isPasswordVerified;

  PasswordChangeState({
    this.isLoading = false,
    this.error,
    this.isPasswordVerified = false,
  });

  PasswordChangeState copyWith({
    bool? isLoading,
    String? error,
    bool? isPasswordVerified,
  }) {
    return PasswordChangeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isPasswordVerified: isPasswordVerified ?? this.isPasswordVerified,
    );
  }
}

class PasswordChangeNotifier extends StateNotifier<PasswordChangeState> {
  final AuthRepository _authRepository;

  PasswordChangeNotifier(this._authRepository) : super(PasswordChangeState());

  Future<bool> verifyCurrentPassword(String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Supabase에서는 현재 비밀번호를 직접 검증할 수 없으므로
      // 재인증을 통해 확인합니다
      final service = SupabaseService.instance;
      final user = service.client.auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('사용자 정보를 찾을 수 없습니다');
      }

      // 현재 이메일과 비밀번호로 재인증 시도
      final response = await service.client.auth.signInWithPassword(
        email: user.email!,
        password: password,
      );

      if (response.user != null) {
        state = state.copyWith(
          isLoading: false,
          isPasswordVerified: true,
        );
        return true;
      } else {
        throw Exception('비밀번호가 일치하지 않습니다');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      throw Exception('비밀번호가 일치하지 않습니다');
    }
  }

  Future<bool> changePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Supabase 비밀번호 변경
      final service = SupabaseService.instance;
      final response = await service.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        throw Exception('비밀번호 변경에 실패했습니다');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      throw Exception('비밀번호 변경에 실패했습니다: ${e.toString()}');
    }
  }

  void reset() {
    state = PasswordChangeState();
  }
}