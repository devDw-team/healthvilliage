import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/medicine.dart';
import '../../../data/models/hospital_marker.dart';
import '../../providers/favorite_medicines_provider.dart';
import '../../providers/favorite_hospitals_provider.dart';
import '../../providers/favorite_pharmacies_provider.dart';
import '../../providers/auth_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadFavorites() {
    final userAsync = ref.read(authStateProvider);
    userAsync.whenData((user) {
      if (user != null) {
        ref.read(favoriteMedicinesProvider.notifier).loadFavorites(user.id);
        ref.read(favoriteHospitalsProvider.notifier).loadFavorites(user.id);
        ref.read(favoritePharmaciesProvider.notifier).loadFavorites(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '의약품'),
            Tab(text: '병원'),
            Tab(text: '약국'),
            Tab(text: '응급실'),
          ],
        ),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('로그인이 필요합니다.'),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // 의약품 탭
              _buildMedicineTab(),
              // 병원 탭
              _buildHospitalTab(),
              // 약국 탭
              _buildPharmacyTab(),
              // 응급실 탭
              _buildEmergencyTab(),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Text('오류: $error'),
        ),
      ),
    );
  }

  // 의약품 탭
  Widget _buildMedicineTab() {
    final favoritesAsync = ref.watch(favoriteMedicinesProvider);
    
    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState('즐겨찾기한 의약품이 없습니다', Icons.medication);
        }
        return _buildMedicinesList(favorites);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  // 병원 탭
  Widget _buildHospitalTab() {
    final favoritesAsync = ref.watch(favoriteHospitalsProvider);
    
    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState('즐겨찾기한 병원이 없습니다', Icons.local_hospital);
        }
        return _buildHospitalsList(favorites);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  // 약국 탭
  Widget _buildPharmacyTab() {
    final favoritesAsync = ref.watch(favoritePharmaciesProvider);
    
    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState('즐겨찾기한 약국이 없습니다', Icons.local_pharmacy);
        }
        return _buildPharmaciesList(favorites);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  // 응급실 탭
  Widget _buildEmergencyTab() {
    final favoritesAsync = ref.watch(favoriteHospitalsProvider);
    
    return favoritesAsync.when(
      data: (favorites) {
        // 응급실 가능한 병원만 필터링
        final emergencyHospitals = favorites.where((h) => h.isEmergencyAvailable == true).toList();
        if (emergencyHospitals.isEmpty) {
          return _buildEmptyState('즐겨찾기한 응급실이 없습니다', Icons.emergency);
        }
        return _buildHospitalsList(emergencyHospitals, isEmergency: true);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  // 빈 상태
  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // 에러 상태
  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            '오류가 발생했습니다',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadFavorites,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  // 의약품 목록
  Widget _buildMedicinesList(List<Medicine> medicines) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              medicine.name,
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  '제조사: ${medicine.manufacturer}',
                  style: AppTextStyles.caption,
                ),
                if (medicine.efficacy != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    medicine.efficacy!,
                    style: AppTextStyles.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () async {
                // 삭제 확인 다이얼로그
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('즐겨찾기 삭제'),
                      content: Text('${medicine.name}을(를) 즐겨찾기에서 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                          child: const Text('삭제'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldDelete == true) {
                  final user = ref.read(currentUserProvider);
                  if (user != null) {
                    await ref.read(favoriteMedicinesProvider.notifier)
                        .removeFavorite(user.id, medicine.id);
                    
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('즐겨찾기에서 제거되었습니다'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),
            onTap: () {
              // 의약품 상세 페이지로 이동
              context.push('/medicine/detail', extra: medicine);
            },
          ),
        );
      },
    );
  }

  // 병원 목록
  Widget _buildHospitalsList(List<dynamic> hospitals, {bool isEmergency = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hospitals.length,
      itemBuilder: (context, index) {
        final hospital = hospitals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    hospital.name,
                    style: AppTextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isEmergency)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emergency.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '응급실',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.emergency,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
                if (hospital.phone != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        hospital.phone!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // 액션 버튼들
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // 지도 보기
                          context.push('/map', extra: {
                            'initialMarker': HospitalMarker(
                              id: hospital.hospitalId,
                              name: hospital.name,
                              address: hospital.address,
                              phoneNumber: hospital.phone ?? '',
                              latitude: hospital.latitude,
                              longitude: hospital.longitude,
                              type: 'hospital',
                            ),
                            'markerType': 'hospital',
                          });
                        },
                        icon: const Icon(Icons.map, size: 16),
                        label: const Text('지도'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToFacility(hospital),
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('길찾기'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callFacility(hospital.phone),
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('전화'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () async {
                        // 삭제 확인 다이얼로그
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('즐겨찾기 삭제'),
                              content: Text('${hospital.name}을(를) 즐겨찾기에서 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                  ),
                                  child: const Text('삭제'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true) {
                          await ref.read(favoriteHospitalsProvider.notifier)
                              .removeFavorite(hospital.hospitalId);
                          
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('즐겨찾기에서 제거되었습니다'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 약국 목록
  Widget _buildPharmaciesList(List<dynamic> pharmacies) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pharmacies.length,
      itemBuilder: (context, index) {
        final pharmacy = pharmacies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    pharmacy.name,
                    style: AppTextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (pharmacy.isNightPharmacy == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.pharmacy.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '야간약국',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.pharmacy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pharmacy.address,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
                if (pharmacy.phone != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        pharmacy.phone!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // 액션 버튼들
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // 지도 보기
                          context.push('/map', extra: {
                            'initialMarker': HospitalMarker(
                              id: pharmacy.pharmacyId,
                              name: pharmacy.name,
                              address: pharmacy.address,
                              phoneNumber: pharmacy.phone ?? '',
                              latitude: pharmacy.latitude,
                              longitude: pharmacy.longitude,
                              type: 'pharmacy',
                            ),
                            'markerType': 'pharmacy',
                          });
                        },
                        icon: const Icon(Icons.map, size: 16),
                        label: const Text('지도'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToPharmacy(pharmacy),
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('길찾기'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callFacility(pharmacy.phone),
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('전화'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () async {
                        // 삭제 확인 다이얼로그
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('즐겨찾기 삭제'),
                              content: Text('${pharmacy.name}을(를) 즐겨찾기에서 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                  ),
                                  child: const Text('삭제'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true) {
                          await ref.read(favoritePharmaciesProvider.notifier)
                              .removeFavorite(pharmacy.pharmacyId);
                          
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('즐겨찾기에서 제거되었습니다'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 전화 걸기
  void _callFacility(String? phoneNumber) async {
    if (phoneNumber == null) return;
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // 병원으로 길찾기
  void _navigateToFacility(dynamic facility) async {
    final webUrl = 'https://map.kakao.com/link/to/${facility.name},${facility.latitude},${facility.longitude}';
    
    try {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('길찾기를 실행할 수 없습니다.')),
      );
    }
  }

  // 약국으로 길찾기
  void _navigateToPharmacy(dynamic pharmacy) async {
    final webUrl = 'https://map.kakao.com/link/to/${pharmacy.name},${pharmacy.latitude},${pharmacy.longitude}';
    
    try {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('길찾기를 실행할 수 없습니다.')),
      );
    }
  }
}