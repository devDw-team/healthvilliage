import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/medicine.dart';
import '../../providers/favorite_medicines_provider.dart';
import '../../providers/auth_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  void _loadFavorites() {
    final userAsync = ref.read(authStateProvider);
    userAsync.whenData((user) {
      if (user != null) {
        ref.read(favoriteMedicinesProvider.notifier).loadFavorites(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoriteMedicinesProvider);
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('로그인이 필요합니다.'),
            );
          }

          return favoritesAsync.when(
            data: (favorites) {
              if (favorites.isEmpty) {
                return _buildEmptyState();
              }
              return _buildFavoritesList(favorites);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
            error: (error, stack) => Center(
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
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Text('사용자 정보를 불러올 수 없습니다: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '즐겨찾기한 의약품이 없습니다',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '의약품 검색에서 즐겨찾기를 추가해보세요',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.push('/medicine');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('의약품 검색하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Medicine> favorites) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadFavorites();
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final medicine = favorites[index];
          return _buildMedicineCard(medicine);
        },
      ),
    );
  }

  Widget _buildMedicineCard(Medicine medicine) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // 의약품 상세 페이지로 이동
          context.push('/medicine/detail', extra: medicine.toEntity());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 의약품 이미지
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: medicine.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              medicine.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.medication,
                                  size: 40,
                                  color: AppColors.textTertiary,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.medication,
                            size: 40,
                            color: AppColors.textTertiary,
                          ),
                  ),
                  const SizedBox(width: 12),
                  // 의약품 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medicine.manufacturer,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (medicine.efficacy != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            medicine.efficacy!,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 즐겨찾기 해제 버튼
                  IconButton(
                    onPressed: () => _removeFavorite(medicine),
                    icon: const Icon(
                      Icons.favorite,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeFavorite(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '즐겨찾기 해제',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '${medicine.name}을(를) 즐겨찾기에서 제거하시겠습니까?',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final userAsync = ref.read(authStateProvider);
              userAsync.whenData((user) async {
                if (user != null) {
                  try {
                    await ref.read(favoriteMedicinesProvider.notifier)
                        .removeFavorite(user.id, medicine.id);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('즐겨찾기에서 제거되었습니다.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('오류가 발생했습니다: $e'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                }
              });
            },
            child: Text(
              '제거',
              style: AppTextStyles.button.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}