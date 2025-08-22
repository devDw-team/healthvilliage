import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/favorite_hospital.dart';
import '../../data/models/favorite_pharmacy.dart';
import '../../data/models/medicine.dart';
import 'favorite_hospitals_provider.dart';
import 'favorite_pharmacies_provider.dart';
import 'favorite_medicines_provider.dart';

// 즐겨찾기 타입 정의
enum FavoriteType {
  hospital('병원'),
  pharmacy('약국'),
  emergency('응급실'),
  medicine('의약품');

  final String label;
  const FavoriteType(this.label);
}

// 통합 즐겨찾기 아이템
class FavoriteItem {
  final String id;
  final String name;
  final String? subtitle;  // 주소 또는 제조사
  final FavoriteType type;
  final DateTime favoritedAt;
  final dynamic data;  // 원본 데이터 (병원, 약국, 의약품 등)

  FavoriteItem({
    required this.id,
    required this.name,
    this.subtitle,
    required this.type,
    required this.favoritedAt,
    required this.data,
  });
}

// 최근 즐겨찾기 5개를 반환하는 Provider
final recentFavoritesProvider = FutureProvider<List<FavoriteItem>>((ref) async {
  // 각 즐겨찾기 프로바이더를 watch하여 자동 업데이트
  final hospitalsAsync = ref.watch(favoriteHospitalsProvider);
  final pharmaciesAsync = ref.watch(favoritePharmaciesProvider);
  final medicinesAsync = ref.watch(favoriteMedicinesProvider);

  final allFavorites = <FavoriteItem>[];

  // 병원 즐겨찾기 추가
  hospitalsAsync.whenData((hospitals) {
    for (final hospital in hospitals) {
      allFavorites.add(FavoriteItem(
        id: hospital.hospitalId,
        name: hospital.name,
        subtitle: hospital.address,
        type: hospital.isEmergencyAvailable == true 
            ? FavoriteType.emergency 
            : FavoriteType.hospital,
        favoritedAt: hospital.favoritedAt,
        data: hospital,
      ));
    }
  });

  // 약국 즐겨찾기 추가
  pharmaciesAsync.whenData((pharmacies) {
    for (final pharmacy in pharmacies) {
      allFavorites.add(FavoriteItem(
        id: pharmacy.pharmacyId,
        name: pharmacy.name,
        subtitle: pharmacy.address,
        type: FavoriteType.pharmacy,
        favoritedAt: pharmacy.favoritedAt,
        data: pharmacy,
      ));
    }
  });

  // 의약품 즐겨찾기 추가
  medicinesAsync.whenData((medicines) {
    for (final medicine in medicines) {
      allFavorites.add(FavoriteItem(
        id: medicine.id,
        name: medicine.name,
        subtitle: medicine.manufacturer,
        type: FavoriteType.medicine,
        favoritedAt: medicine.createdAt ?? DateTime.now(),
        data: medicine,
      ));
    }
  });

  // 최신순으로 정렬
  allFavorites.sort((a, b) => b.favoritedAt.compareTo(a.favoritedAt));

  // 최대 5개만 반환
  return allFavorites.take(5).toList();
});