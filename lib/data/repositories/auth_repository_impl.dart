import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepositoryImpl(this._supabaseService);

  @override
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
        },
      );

      if (response.user != null) {
        // Wait a bit for the trigger to create the user profile
        await Future.delayed(const Duration(seconds: 2));
        
        try {
          final userProfile = await _supabaseService
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .maybeSingle();
          
          if (userProfile != null) {
            return UserModel.fromJson(userProfile);
          } else {
            // If profile doesn't exist yet, return basic model
            // The profile will be created by the trigger and fetched on next auth state change
            return UserModel(
              id: response.user!.id,
              email: email,
              name: name ?? '',
              phone: phone,
              points: 0,
              level: 1,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        } catch (e) {
          print('Error fetching user profile after signup: $e');
          // Return basic model as fallback
          return UserModel(
            id: response.user!.id,
            email: email,
            name: name ?? '',
            phone: phone,
            points: 0,
            level: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }

      return null;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('[AuthRepositoryImpl] signIn 시작: $email');
      
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      print('[AuthRepositoryImpl] Supabase 응답: ${response.user?.id}');

      if (response.user != null) {
        try {
          final userProfile = await _supabaseService
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .single();

          print('[AuthRepositoryImpl] 사용자 프로필 조회 성공: $userProfile');
          return UserModel.fromJson(userProfile);
        } catch (e) {
          print('[AuthRepositoryImpl] 사용자 프로필 조회 실패: $e');
          // 프로필이 없으면 기본 모델 반환
          return UserModel(
            id: response.user!.id,
            email: email,
            name: '',
            phone: null,
            points: 0,
            level: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }

      return null;
    } on AuthException catch (e) {
      print('[AuthRepositoryImpl] AuthException: ${e.message}');
      // Preserve the original AuthException to handle specific error codes
      rethrow;
    } catch (e) {
      print('[AuthRepositoryImpl] 일반 오류: $e');
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _supabaseService.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _supabaseService.currentUser;
    if (user != null) {
      final userProfile = await _supabaseService
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(userProfile);
    }
    return null;
  }

  @override
  Stream<AuthState> authStateChanges() {
    return _supabaseService.authStateChanges;
  }

  @override
  Future<UserModel?> updateProfile({
    required String userId,
    String? name,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
  }) async {
    try {
      final updates = {
        'name': name,
        'phone': phone,
        'birth_date': birthDate?.toIso8601String(),
        'gender': gender,
        'profile_image_url': profileImageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Remove null values
      updates.removeWhere((key, value) => value == null);

      final response = await _supabaseService
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      // RPC 함수를 사용하여 auth.users 테이블에서 이메일 확인
      final response = await _supabaseService.client.rpc(
        'check_email_exists',
        params: {'email_input': email.toLowerCase()},
      );
      
      print('[AuthRepositoryImpl] 이메일 중복 확인: $email => $response');
      
      return response as bool? ?? false;
    } catch (e) {
      print('[AuthRepositoryImpl] checkEmailExists 오류: $e');
      
      // RPC 함수가 없는 경우 users 테이블에서 확인
      try {
        final response = await _supabaseService
            .from('users')
            .select('id')
            .eq('email', email)
            .maybeSingle();
        
        return response != null;
      } catch (e2) {
        print('[AuthRepositoryImpl] users 테이블 확인 오류: $e2');
        return false;
      }
    }
  }

  @override
  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _supabaseService.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e) {
      throw Exception('Failed to resend confirmation email: $e');
    }
  }

  @override
  Future<bool> verifyPassword(String email, String password) async {
    try {
      // 임시 클라이언트로 비밀번호 확인 (현재 세션에 영향 없음)
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // 성공하면 true 반환 (세션은 유지하지 않음)
      return response.user != null;
    } catch (e) {
      print('[AuthRepositoryImpl] verifyPassword 오류: $e');
      return false;
    }
  }

  @override
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      // 파일 확장자 가져오기
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$userId/profile_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      
      // Storage bucket이 없으면 생성 (처음 한 번만)
      // Supabase 대시보드에서 'profiles' bucket을 public으로 생성해야 함
      
      // 이미지 업로드
      final uploadResponse = await _supabaseService.client.storage
          .from('profiles')
          .upload(fileName, imageFile);
      
      if (uploadResponse.isEmpty) {
        throw Exception('Failed to upload image');
      }
      
      // 업로드된 이미지의 public URL 가져오기
      final imageUrl = _supabaseService.client.storage
          .from('profiles')
          .getPublicUrl(fileName);
      
      return imageUrl;
    } catch (e) {
      print('[AuthRepositoryImpl] uploadProfileImage 오류: $e');
      return null;
    }
  }
}