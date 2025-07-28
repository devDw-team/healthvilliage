import '../repositories/medicine_repository.dart';

class ManageRecentSearchesUseCase {
  final MedicineRepository _repository;

  ManageRecentSearchesUseCase(this._repository);

  /// 최근 검색어 목록 조회
  Future<List<String>> getRecentSearches() async {
    try {
      return await _repository.getRecentSearches();
    } catch (e) {
      print('Error getting recent searches: $e');
      return [];
    }
  }

  /// 최근 검색어 삭제
  Future<void> deleteRecentSearch(String query) async {
    if (query.isEmpty) return;

    try {
      await _repository.deleteRecentSearch(query);
    } catch (e) {
      print('Error deleting recent search: $e');
    }
  }

  /// 최근 검색어 추가
  Future<void> addRecentSearch(String query) async {
    if (query.isEmpty) return;
    
    try {
      await _repository.saveRecentSearch(query);
    } catch (e) {
      print('Error adding recent search: $e');
    }
  }

  /// 모든 최근 검색어 삭제
  Future<void> clearAllRecentSearches() async {
    try {
      await _repository.clearRecentSearches();
    } catch (e) {
      print('Error clearing recent searches: $e');
    }
  }
}