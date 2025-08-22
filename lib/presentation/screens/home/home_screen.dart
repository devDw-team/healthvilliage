import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/hospital_marker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/recent_favorites_provider.dart';
import '../../providers/favorite_hospitals_provider.dart';
import '../../providers/favorite_pharmacies_provider.dart';
import '../../providers/favorite_medicines_provider.dart';
import '../mypage/mypage_screen.dart';
import '../medicine/medicine_screen.dart';
import '../search/search_screen.dart';

/// 홈 화면 - 메인 네비게이션과 주요 기능들
class HomeScreen extends ConsumerStatefulWidget {
  final int initialTab;
  
  const HomeScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const SearchTabScreen(),
    const MedicineScreen(showBackButton: false),  // 탭에서는 뒤로 가기 버튼 숨김
    const MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: AppStrings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: AppStrings.medicine,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.myPage,
          ),
        ],
      ),
    );
  }
}

/// 홈 탭 화면
class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends ConsumerState<HomeTabScreen> {
  @override
  void initState() {
    super.initState();
    // 홈 화면 로딩 시 즐겨찾기 데이터 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  void _loadFavorites() {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      // 병원 즐겨찾기 로드
      ref.read(favoriteHospitalsProvider.notifier).loadFavorites(user.id);
      // 약국 즐겨찾기 로드
      ref.read(favoritePharmaciesProvider.notifier).loadFavorites(user.id);
      // 의약품 즐겨찾기 로드
      ref.read(favoriteMedicinesProvider.notifier).loadFavorites(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 알림 화면으로 이동
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('로그아웃'),
                          ),
                        ],
                      );
                    },
                  );
                  
                  if (shouldLogout == true) {
                    try {
                      await ref.read(authStateProvider.notifier).signOut();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그아웃 실패: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 환영 메시지
            WelcomeSection(),
            SizedBox(height: 24),
            
            // 빠른 액세스 버튼들
            QuickAccessSection(),
            SizedBox(height: 24),
            
            // 즐겨찾기 섹션
            FavoritesSection(),
            SizedBox(height: 24),
            
            // 내 주변 병원/약국
            NearbyFacilitiesSection(),
          ],
        ),
      ),
    );
  }
}

/// 환영 메시지 섹션
class WelcomeSection extends ConsumerWidget {
  const WelcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userName = currentUser?.name ?? '사용자';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$userName님 안녕하세요! 👋',
                      style: AppTextStyles.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '오늘도 건강한 하루 보내세요',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final userAsync = ref.watch(authStateProvider);
                  final profileImageUrl = userAsync.whenOrNull(
                    data: (user) => user?.profileImageUrl,
                  );
                  
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: profileImageUrl != null
                          ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 32,
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
          // 포인트 및 레벨 표시 - Phase 2에서 구현 예정
          // if (currentUser != null) ...[
          //   const SizedBox(height: 16),
          //   Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           Icons.stars,
          //           color: Colors.white,
          //           size: 16,
          //         ),
          //         const SizedBox(width: 4),
          //         Text(
          //           '포인트: ${currentUser.points ?? 0}P',
          //           style: AppTextStyles.caption.copyWith(
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         const SizedBox(width: 12),
          //         Icon(
          //           Icons.trending_up,
          //           color: Colors.white,
          //           size: 16,
          //         ),
          //         const SizedBox(width: 4),
          //         Text(
          //           'Lv.${currentUser.level ?? 1}',
          //           style: AppTextStyles.caption.copyWith(
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}

/// 빠른 액세스 섹션
class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 메뉴',
          style: AppTextStyles.headline6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickAccessButton(
                icon: Icons.local_hospital,
                label: AppStrings.hospital,
                color: AppColors.hospital,
                onTap: () {
                  context.push('/search?tab=0');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAccessButton(
                icon: Icons.local_pharmacy,
                label: AppStrings.pharmacy,
                color: AppColors.pharmacy,
                onTap: () {
                  context.push('/search?tab=1');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAccessButton(
                icon: Icons.emergency,
                label: AppStrings.emergencyRoom,
                color: AppColors.emergency,
                onTap: () {
                  context.push('/search?tab=2');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 빠른 액세스 버튼
class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 내 주변 병원/약국 섹션
class NearbyFacilitiesSection extends ConsumerWidget {
  const NearbyFacilitiesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '내 주변 의료시설',
              style: AppTextStyles.headline6,
            ),
            TextButton(
              onPressed: () {
                // 내 주변 의료시설 지도로 이동
                context.push('/map/nearby');
              },
              child: const Text(AppStrings.more),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '위치 권한을 허용하면 내 주변 병원과 약국을 볼 수 있습니다.',
          style: AppTextStyles.body2,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            // 위치 권한 요청
            final hasPermission = await LocationService.requestLocationPermission();
            if (hasPermission && context.mounted) {
              // 권한 허용 시 내 주변 의료시설 지도로 이동
              context.push('/map/nearby');
            } else if (!hasPermission && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          icon: const Icon(Icons.location_on),
          label: const Text('위치 권한 허용'),
        ),
      ],
    );
  }
}

/// 즐겨찾기 섹션
class FavoritesSection extends ConsumerWidget {
  const FavoritesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(recentFavoritesProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '즐겨찾기',
              style: AppTextStyles.headline6,
            ),
            TextButton(
              onPressed: () {
                context.push('/mypage/favorites');
              },
              child: const Text('더보기'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        favoritesAsync.when(
          data: (favorites) {
            if (favorites.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '즐겨찾기한 항목이 없습니다',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '자주 이용하는 병원, 약국, 의약품을 즐겨찾기해보세요',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: favorites.map((item) => _buildFavoriteItem(context, ref, item)).toList(),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '즐겨찾기를 불러올 수 없습니다',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteItem(BuildContext context, WidgetRef ref, FavoriteItem item) {
    Color typeColor;
    IconData typeIcon;
    
    switch (item.type) {
      case FavoriteType.hospital:
        typeColor = AppColors.hospital;
        typeIcon = Icons.local_hospital;
        break;
      case FavoriteType.pharmacy:
        typeColor = AppColors.pharmacy;
        typeIcon = Icons.local_pharmacy;
        break;
      case FavoriteType.emergency:
        typeColor = AppColors.emergency;
        typeIcon = Icons.emergency;
        break;
      case FavoriteType.medicine:
        typeColor = AppColors.accent;
        typeIcon = Icons.medication;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // 타입에 따라 다른 페이지로 이동
          switch (item.type) {
            case FavoriteType.hospital:
            case FavoriteType.emergency:
              final hospital = item.data;
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
              break;
            case FavoriteType.pharmacy:
              final pharmacy = item.data;
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
              break;
            case FavoriteType.medicine:
              context.push('/medicine/detail', extra: item.data);
              break;
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 타입 아이콘
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type.label,
                            style: AppTextStyles.caption.copyWith(
                              color: typeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTextStyles.subtitle2.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // 화살표
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 검색 탭 화면
class SearchTabScreen extends StatelessWidget {
  const SearchTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchScreen();
  }
}

 