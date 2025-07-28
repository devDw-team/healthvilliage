import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/services/medicine_api_service.dart';
import '../../core/services/supabase_service.dart';
import '../../data/models/medicine.dart';
import '../../data/repositories/medicine_repository_impl.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../../domain/usecases/search_medicines_use_case.dart';
import '../../domain/usecases/get_medicine_details_use_case.dart';
import '../../domain/usecases/manage_favorite_medicines_use_case.dart';
import '../../domain/usecases/manage_recent_searches_use_case.dart';
import '../../domain/entities/medicine_entity.dart';
import 'supabase_providers.dart';
import 'user_provider.dart';

/// Medicine API Service Provider
final medicineApiServiceProvider = Provider<MedicineApiService>((ref) {
  return MedicineApiService();
});

/// Medicine Repository Provider
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  final apiService = ref.watch(medicineApiServiceProvider);
  final supabaseService = ref.watch(supabaseServiceProvider);
  
  // Hive boxes for caching (optional)
  Box? cacheBox;
  Box? recentSearchBox;
  
  try {
    cacheBox = Hive.box('medicine_cache');
  } catch (e) {
    print('Medicine cache box not available: $e');
  }
  
  try {
    recentSearchBox = Hive.box('recent_searches');
  } catch (e) {
    print('Recent searches box not available: $e');
  }
  
  return MedicineRepositoryImpl(
    apiService,
    supabaseService,
    cacheBox: cacheBox,
    recentSearchBox: recentSearchBox,
  );
});

/// Search Medicines Use Case Provider
final searchMedicinesUseCaseProvider = Provider<SearchMedicinesUseCase>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return SearchMedicinesUseCase(repository);
});

/// Get Medicine Details Use Case Provider
final getMedicineDetailsUseCaseProvider = Provider<GetMedicineDetailsUseCase>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return GetMedicineDetailsUseCase(repository);
});

/// Manage Favorite Medicines Use Case Provider
final manageFavoriteMedicinesUseCaseProvider = Provider<ManageFavoriteMedicinesUseCase>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return ManageFavoriteMedicinesUseCase(repository);
});

/// Manage Recent Searches Use Case Provider
final manageRecentSearchesUseCaseProvider = Provider<ManageRecentSearchesUseCase>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return ManageRecentSearchesUseCase(repository);
});

/// 최근 검색어 관리 프로바이더
final recentMedicineSearchProvider = StateNotifierProvider<RecentSearchNotifier, AsyncValue<List<String>>>((ref) {
  final useCase = ref.watch(manageRecentSearchesUseCaseProvider);
  return RecentSearchNotifier(useCase);
});

/// 최근 검색어 StateNotifier
class RecentSearchNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final ManageRecentSearchesUseCase _useCase;
  
  RecentSearchNotifier(this._useCase) : super(const AsyncValue.loading()) {
    loadRecentSearches();
  }

  Future<void> loadRecentSearches() async {
    try {
      state = const AsyncValue.loading();
      final searches = await _useCase.getRecentSearches();
      state = AsyncValue.data(searches);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeSearch(String searchTerm) async {
    try {
      await _useCase.deleteRecentSearch(searchTerm);
      await loadRecentSearches();
    } catch (e) {
      print('Error removing search: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await _useCase.clearAllRecentSearches();
      state = const AsyncValue.data([]);
    } catch (e) {
      print('Error clearing searches: $e');
    }
  }
}

/// 즐겨찾기 의약품 관리 프로바이더
final favoriteMedicinesProvider = StateNotifierProvider<FavoriteMedicinesNotifier, AsyncValue<List<Medicine>>>((ref) {
  final useCase = ref.watch(manageFavoriteMedicinesUseCaseProvider);
  final user = ref.watch(currentUserProvider).value;
  return FavoriteMedicinesNotifier(useCase, user?.id);
});

/// 즐겨찾기 의약품 StateNotifier
class FavoriteMedicinesNotifier extends StateNotifier<AsyncValue<List<Medicine>>> {
  final ManageFavoriteMedicinesUseCase _useCase;
  final String? _userId;
  
  FavoriteMedicinesNotifier(this._useCase, this._userId) : super(const AsyncValue.loading()) {
    if (_userId != null) {
      loadFavorites();
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> loadFavorites() async {
    if (_userId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    
    try {
      state = const AsyncValue.loading();
      final medicines = await _useCase.getFavoriteMedicines(_userId!);
      state = AsyncValue.data(medicines);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(Medicine medicine) async {
    if (_userId == null) return;
    
    try {
      final currentFavorites = state.value ?? [];
      final exists = currentFavorites.any((m) => m.id == medicine.id);
      
      if (exists) {
        await _useCase.removeFromFavorites(_userId!, medicine.id);
        state = AsyncValue.data(
          currentFavorites.where((m) => m.id != medicine.id).toList()
        );
      } else {
        await _useCase.addToFavorites(_userId!, medicine.id);
        state = AsyncValue.data(
          [...currentFavorites, medicine.copyWith(isFavorite: true)]
        );
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      // Reload favorites on error
      await loadFavorites();
    }
  }

  bool isFavorite(String medicineId) {
    return state.value?.any((m) => m.id == medicineId) ?? false;
  }
  
  Future<void> addFavorite(MedicineEntity medicine) async {
    if (_userId == null) return;
    
    try {
      final currentFavorites = state.value ?? [];
      
      // Convert MedicineEntity to Medicine
      final medicineModel = Medicine.fromEntity(medicine);
      
      await _useCase.addToFavorites(_userId!, medicine.itemSeq);
      state = AsyncValue.data([...currentFavorites, medicineModel]);
    } catch (e) {
      print('Error adding favorite: $e');
      await loadFavorites();
    }
  }
  
  Future<void> removeFavorite(String itemSeq) async {
    if (_userId == null) return;
    
    try {
      final currentFavorites = state.value ?? [];
      
      await _useCase.removeFromFavorites(_userId!, itemSeq);
      state = AsyncValue.data(
        currentFavorites.where((m) => m.itemSeq != itemSeq).toList()
      );
    } catch (e) {
      print('Error removing favorite: $e');
      await loadFavorites();
    }
  }
}

/// 의약품 검색 결과 관리 프로바이더
final medicineSearchProvider = StateNotifierProvider<MedicineSearchNotifier, AsyncValue<List<MedicineEntity>>>((ref) {
  final useCase = ref.watch(searchMedicinesUseCaseProvider);
  return MedicineSearchNotifier(useCase);
});

/// 최근 검색어 프로바이더
final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  final useCase = ref.watch(manageRecentSearchesUseCaseProvider);
  return RecentSearchesNotifier(useCase);
});

/// 의약품 상세 정보 프로바이더
final medicineDetailProvider = FutureProvider.family<Medicine?, String>((ref, itemSeq) async {
  final useCase = ref.watch(getMedicineDetailsUseCaseProvider);
  return await useCase.execute(itemSeq);
});

// Extension removed - use maybeWhen pattern instead for AsyncValue

/// 의약품 검색 StateNotifier
class MedicineSearchNotifier extends StateNotifier<AsyncValue<List<MedicineEntity>>> {
  final SearchMedicinesUseCase _useCase;
  String _currentQuery = '';
  int _currentPage = 1;
  final int _pageSize = 20;
  int _totalCount = 0;
  bool hasMore = false;

  MedicineSearchNotifier(this._useCase) : super(const AsyncValue.data([]));

  Future<void> searchMedicines({
    String? itemName,
    String? entpName,
    int page = 1,
  }) async {
    try {
      _currentQuery = itemName ?? entpName ?? '';
      _currentPage = page;
      
      print('=== MedicineSearchNotifier searchMedicines ===');
      print('Query: $_currentQuery');
      print('Page: $_currentPage');
      print('Search Type: ${itemName != null ? 'name' : 'manufacturer'}');
      
      if (_currentQuery.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }
      
      state = const AsyncValue.loading();
      
      final result = await _useCase.execute(
        query: _currentQuery,
        pageNo: _currentPage,
        numOfRows: _pageSize,
        searchType: itemName != null ? 'itemName' : 'entpName',
      );
      
      print('Search Result: ${result.medicines.length} medicines found');
      print('Total Count: ${result.totalCount}');
      print('Has More: ${result.hasMore}');
      
      _totalCount = result.totalCount;
      hasMore = result.hasMore;
      
      final entities = result.medicines.map((m) => m.toEntity()).toList();
      print('Converted to ${entities.length} entities');
      
      // 첫 번째 엔티티의 데이터 확인
      if (entities.isNotEmpty) {
        final firstEntity = entities.first;
        print('First entity data:');
        print('  - itemName: ${firstEntity.itemName}');
        print('  - entpName: ${firstEntity.entpName}');
        print('  - efcyQesitm: ${firstEntity.efcyQesitm}');
      }
      
      state = AsyncValue.data(entities);
    } catch (e, stack) {
      print('Error in searchMedicines: $e');
      state = AsyncValue.error(e, stack);
    }
  }
  
  void clearSearch() {
    _currentQuery = '';
    _currentPage = 1;
    _totalCount = 0;
    hasMore = false;
    state = const AsyncValue.data([]);
  }
  
  Future<void> loadMore() async {
    if (!hasMore) return;
    
    final currentState = state.value;
    if (currentState == null) return;
    
    try {
      _currentPage++;
      
      final result = await _useCase.execute(
        query: _currentQuery,
        pageNo: _currentPage,
        numOfRows: _pageSize,
      );
      
      _totalCount = result.totalCount;
      hasMore = result.hasMore;
      
      state = AsyncValue.data([...currentState, ...result.medicines.map((m) => m.toEntity())]);
    } catch (e, stack) {
      // Revert page number on error
      _currentPage--;
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 최근 검색어 StateNotifier
class RecentSearchesNotifier extends StateNotifier<List<String>> {
  final ManageRecentSearchesUseCase _useCase;
  
  RecentSearchesNotifier(this._useCase) : super([]) {
    loadRecentSearches();
  }
  
  Future<void> loadRecentSearches() async {
    final searches = await _useCase.getRecentSearches();
    state = searches;
  }
  
  Future<void> addSearch(String query) async {
    await _useCase.addRecentSearch(query);
    await loadRecentSearches();
  }
  
  Future<void> removeSearch(String query) async {
    await _useCase.deleteRecentSearch(query);
    await loadRecentSearches();
  }
  
  Future<void> clearSearches() async {
    await _useCase.clearAllRecentSearches();
    state = [];
  }
}