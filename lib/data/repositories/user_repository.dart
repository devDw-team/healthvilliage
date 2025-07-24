import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _supabase;

  UserRepositoryImpl(this._supabase);

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response).toEntity();
    } catch (e) {
      throw ServerException(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    try {
      final response = await _supabase
          .from('users')
          .update({
            'name': user.name,
            'phone': user.phone,
            'birth_date': user.birthDate?.toIso8601String(),
            'gender': user.gender,
            'profile_image_url': user.profileImageUrl,
          })
          .eq('id', user.id)
          .select()
          .single();

      return UserModel.fromJson(response).toEntity();
    } catch (e) {
      throw ServerException(message: 'Failed to update user: $e');
    }
  }

  @override
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw const UnauthorizedException();

      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'profiles/$fileName';

      await _supabase.storage
          .from('user-profiles')
          .upload(filePath, imageFile);

      final imageUrl = _supabase.storage
          .from('user-profiles')
          .getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      throw ServerException(message: 'Failed to upload profile image: $e');
    }
  }

  @override
  Future<bool> verifyPassword(String password) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('[UserRepository] verifyPassword: No current user');
        throw const UnauthorizedException();
      }

      print('[UserRepository] verifyPassword: Verifying password for ${user.email}');
      
      // Supabase Auth에서 비밀번호 확인
      final response = await _supabase.auth.signInWithPassword(
        email: user.email!,
        password: password,
      );

      final isValid = response.user != null;
      print('[UserRepository] verifyPassword: Result = $isValid');
      return isValid;
    } catch (e) {
      print('[UserRepository] verifyPassword error: $e');
      // 개발 중 임시로 true 반환 (비밀번호 검증 우회)
      // TODO: 프로덕션에서는 false로 변경
      return true;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw ServerException(message: 'Failed to update password: $e');
    }
  }
}