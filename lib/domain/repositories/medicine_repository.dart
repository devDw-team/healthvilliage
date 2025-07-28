import '../../data/models/medicine.dart';
import '../entities/medicine_entity.dart';

abstract class MedicineRepository {
  /// 의약품 검색
  Future<List<Medicine>> searchMedicines({
    required String query,
    int pageNo = 1,
    int numOfRows = 10,
    String? type, // 의약품 타입 (품목명, 업체명 등)
  });

  /// 의약품 상세 정보 조회
  Future<Medicine?> getMedicineDetail(String itemSeq);

  /// 전체 검색 결과 개수 조회
  Future<int> getTotalCount({
    required String query,
    String? type,
  });

  /// 즐겨찾기 의약품 추가
  Future<void> addToFavorites(String userId, String medicineId);

  /// 즐겨찾기 의약품 제거
  Future<void> removeFromFavorites(String userId, String medicineId);

  /// 즐겨찾기 의약품 목록 조회
  Future<List<Medicine>> getFavoriteMedicines(String userId);

  /// 의약품 정보 캐싱
  Future<void> cacheMedicine(Medicine medicine);

  /// 캐시된 의약품 정보 조회
  Future<Medicine?> getCachedMedicine(String itemSeq);

  /// 최근 검색어 저장
  Future<void> saveRecentSearch(String query);
  
  /// 최근 검색어 목록 조회
  Future<List<String>> getRecentSearches();

  /// 최근 검색어 삭제
  Future<void> deleteRecentSearch(String query);

  /// 모든 최근 검색어 삭제
  Future<void> clearRecentSearches();
}