import '../../data/models/medicine.dart';
import '../repositories/medicine_repository.dart';

class SearchMedicinesUseCase {
  final MedicineRepository _repository;

  SearchMedicinesUseCase(this._repository);

  Future<SearchMedicinesResult> execute({
    required String query,
    int pageNo = 1,
    int numOfRows = 10,
    String? searchType,
  }) async {
    if (query.isEmpty) {
      return const SearchMedicinesResult(
        medicines: [],
        totalCount: 0,
        currentPage: 1,
        hasMore: false,
      );
    }

    try {
      // 최근 검색어 저장
      await _repository.saveRecentSearch(query);

      // 의약품 검색
      final medicines = await _repository.searchMedicines(
        query: query,
        pageNo: pageNo,
        numOfRows: numOfRows,
        type: searchType,
      );

      // 전체 개수 조회
      final totalCount = await _repository.getTotalCount(
        query: query,
        type: searchType,
      );

      final totalPages = (totalCount / numOfRows).ceil();
      final hasMore = pageNo < totalPages;

      return SearchMedicinesResult(
        medicines: medicines,
        totalCount: totalCount,
        currentPage: pageNo,
        hasMore: hasMore,
      );
    } catch (e) {
      print('Error in SearchMedicinesUseCase: $e');
      rethrow;
    }
  }
}

class SearchMedicinesResult {
  final List<Medicine> medicines;
  final int totalCount;
  final int currentPage;
  final bool hasMore;

  const SearchMedicinesResult({
    required this.medicines,
    required this.totalCount,
    required this.currentPage,
    required this.hasMore,
  });
}