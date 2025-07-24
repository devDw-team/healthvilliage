import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  Future<UserModel?> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<AuthState> authStateChanges();

  Future<UserModel?> updateProfile({
    required String userId,
    String? name,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
  });

  Future<bool> checkEmailExists(String email);
  
  Future<void> resendConfirmationEmail(String email);
  
  Future<bool> verifyPassword(String email, String password);
  
  Future<String?> uploadProfileImage(String userId, File imageFile);
}