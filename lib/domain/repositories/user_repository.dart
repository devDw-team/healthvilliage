import 'dart:io';

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> updateUser(UserEntity user);
  Future<String?> uploadProfileImage(File imageFile);
  Future<bool> verifyPassword(String password);
  Future<void> updatePassword(String newPassword);
}