import '../../data/models/medicine.dart';
import '../repositories/medicine_repository.dart';

class ManageFavoriteMedicinesUseCase {
  final MedicineRepository _repository;

  ManageFavoriteMedicinesUseCase(this._repository);

  /// 즐겨찾기 추가
  Future<void> addToFavorites(String userId, String medicineId) async {
    if (userId.isEmpty || medicineId.isEmpty) {
      throw ArgumentError('userId and medicineId cannot be empty');
    }

    try {
      await _repository.addToFavorites(userId, medicineId);
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  /// 즐겨찾기 제거
  Future<void> removeFromFavorites(String userId, String medicineId) async {
    if (userId.isEmpty || medicineId.isEmpty) {
      throw ArgumentError('userId and medicineId cannot be empty');
    }

    try {
      await _repository.removeFromFavorites(userId, medicineId);
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  /// 즐겨찾기 목록 조회
  Future<List<Medicine>> getFavoriteMedicines(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('userId cannot be empty');
    }

    try {
      return await _repository.getFavoriteMedicines(userId);
    } catch (e) {
      print('Error getting favorite medicines: $e');
      rethrow;
    }
  }
}