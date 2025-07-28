import 'package:hive_flutter/hive_flutter.dart';
import '../../core/services/medicine_api_service.dart';
import '../../core/services/supabase_service.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../models/medicine.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineApiService _apiService;
  final SupabaseService _supabaseService;
  final Box? _cacheBox;
  final Box? _recentSearchBox;
  
  static const String _medicinesCacheKey = 'medicines_cache';
  static const String _recentSearchKey = 'recent_searches';

  MedicineRepositoryImpl(
    this._apiService,
    this._supabaseService, {
    Box? cacheBox,
    Box? recentSearchBox,
  })  : _cacheBox = cacheBox,
        _recentSearchBox = recentSearchBox;

  @override
  Future<List<Medicine>> searchMedicines({
    required String query,
    int pageNo = 1,
    int numOfRows = 10,
    String? type,
  }) async {
    try {
      // API 호출
      final medicines = await _apiService.getDrugList(
        itemName: type == 'itemName' || type == null ? query : null,
        entpName: type == 'entpName' ? query : null,
        pageNo: pageNo,
        numOfRows: numOfRows,
      );

      // 캐싱
      if (_cacheBox != null) {
        for (final medicine in medicines) {
          await cacheMedicine(medicine);
        }
      }

      return medicines;
    } catch (e) {
      print('Error searching medicines: $e');
      
      // 네트워크 오류 시 캐시에서 검색
      if (_cacheBox != null) {
        final cachedData = _cacheBox!.get(_medicinesCacheKey);
        if (cachedData != null) {
          final allMedicines = (cachedData as Map).values
              .map((data) => Medicine.fromJson(data as Map<String, dynamic>))
              .toList();
          
          // 로컬 필터링
          return allMedicines.where((medicine) {
            final lowerQuery = query.toLowerCase();
            return medicine.name.toLowerCase().contains(lowerQuery) ||
                   medicine.manufacturer.toLowerCase().contains(lowerQuery);
          }).take(numOfRows).toList();
        }
      }
      
      rethrow;
    }
  }

  @override
  Future<Medicine?> getMedicineDetail(String itemSeq) async {
    try {
      // 캐시 확인
      final cached = await getCachedMedicine(itemSeq);
      if (cached != null) {
        return cached;
      }

      // API 호출
      final medicine = await _apiService.getMedicineDetail(itemSeq);
      
      // 캐싱
      if (medicine != null && _cacheBox != null) {
        await cacheMedicine(medicine);
      }

      return medicine;
    } catch (e) {
      print('Error getting medicine detail: $e');
      rethrow;
    }
  }

  @override
  Future<int> getTotalCount({
    required String query,
    String? type,
  }) async {
    try {
      return await _apiService.getTotalCount(
        itemName: type == 'itemName' || type == null ? query : null,
        entpName: type == 'entpName' ? query : null,
      );
    } catch (e) {
      print('Error getting total count: $e');
      return 0;
    }
  }

  @override
  Future<void> addToFavorites(String userId, String medicineId) async {
    try {
      await _supabaseService.from('user_favorite_medicines').insert({
        'user_id': userId,
        'medicine_id': medicineId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String userId, String medicineId) async {
    try {
      await _supabaseService
          .from('user_favorite_medicines')
          .delete()
          .eq('user_id', userId)
          .eq('medicine_id', medicineId);
    } catch (e) {
      print('Error removing from favorites: $e');
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<List<Medicine>> getFavoriteMedicines(String userId) async {
    try {
      final response = await _supabaseService
          .from('user_favorite_medicines')
          .select('medicine_id')
          .eq('user_id', userId);

      final medicineIds = (response as List)
          .map((item) => item['medicine_id'] as String)
          .toList();

      if (medicineIds.isEmpty) {
        return [];
      }

      // 즐겨찾기 의약품 정보 조회
      final medicines = <Medicine>[];
      for (final id in medicineIds) {
        final medicine = await getMedicineDetail(id);
        if (medicine != null) {
          medicines.add(medicine.copyWith(isFavorite: true));
        }
      }

      return medicines;
    } catch (e) {
      print('Error getting favorite medicines: $e');
      throw Exception('Failed to get favorite medicines: $e');
    }
  }

  @override
  Future<void> cacheMedicine(Medicine medicine) async {
    if (_cacheBox == null) return;

    try {
      final cachedData = _cacheBox!.get(_medicinesCacheKey) ?? {};
      cachedData[medicine.id] = medicine.toJson();
      await _cacheBox!.put(_medicinesCacheKey, cachedData);
    } catch (e) {
      print('Error caching medicine: $e');
    }
  }

  @override
  Future<Medicine?> getCachedMedicine(String itemSeq) async {
    if (_cacheBox == null) return null;

    try {
      final cachedData = _cacheBox!.get(_medicinesCacheKey);
      if (cachedData != null && cachedData[itemSeq] != null) {
        return Medicine.fromJson(cachedData[itemSeq] as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting cached medicine: $e');
    }
    return null;
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    if (_recentSearchBox == null || query.isEmpty) return;

    try {
      final searches = await getRecentSearches();
      
      // 중복 제거
      searches.remove(query);
      
      // 맨 앞에 추가
      searches.insert(0, query);
      
      // 최대 10개 유지
      if (searches.length > 10) {
        searches.removeRange(10, searches.length);
      }
      
      await _recentSearchBox!.put(_recentSearchKey, searches);
    } catch (e) {
      print('Error saving recent search: $e');
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    if (_recentSearchBox == null) return [];

    try {
      final searches = _recentSearchBox!.get(_recentSearchKey);
      return searches?.cast<String>() ?? [];
    } catch (e) {
      print('Error getting recent searches: $e');
      return [];
    }
  }

  @override
  Future<void> deleteRecentSearch(String query) async {
    if (_recentSearchBox == null) return;

    try {
      final searches = await getRecentSearches();
      searches.remove(query);
      await _recentSearchBox!.put(_recentSearchKey, searches);
    } catch (e) {
      print('Error deleting recent search: $e');
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    if (_recentSearchBox == null) return;

    try {
      await _recentSearchBox!.put(_recentSearchKey, <String>[]);
    } catch (e) {
      print('Error clearing recent searches: $e');
    }
  }
}