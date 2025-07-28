import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/medicine_entity.dart';
import '../../providers/medicine_provider.dart';
import 'widgets/medicine_search_bar.dart';
import 'widgets/medicine_filter_chips.dart';
import 'widgets/recent_search_section.dart';
import 'widgets/medicine_card.dart';

/// 의약품 검색 화면
class MedicineScreen extends ConsumerStatefulWidget {
  final bool showBackButton;
  
  const MedicineScreen({
    Key? key,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  ConsumerState<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends ConsumerState<MedicineScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  String _selectedFilter = 'all'; // all, name, manufacturer
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    // 검색 결과 초기화
    ref.read(medicineSearchProvider.notifier).clearSearch();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      // 텍스트 변경 시에는 검색 상태만 업데이트, 실제 검색은 하지 않음
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Add to recent searches
    ref.read(recentSearchesProvider.notifier).addSearch(query);

    // Perform search based on filter
    switch (_selectedFilter) {
      case 'name':
        ref.read(medicineSearchProvider.notifier).searchMedicines(
              itemName: query,
              page: 1,
            );
        break;
      case 'manufacturer':
        ref.read(medicineSearchProvider.notifier).searchMedicines(
              entpName: query,
              page: 1,
            );
        break;
      default:
        ref.read(medicineSearchProvider.notifier).searchMedicines(
              itemName: query,
              page: 1,
            );
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onRecentSearchTap(String searchTerm) {
    _searchController.text = searchTerm;
    _searchFocusNode.unfocus();
    _performSearch();
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _isSearching = false;
    });
    // 검색 결과 초기화
    ref.read(medicineSearchProvider.notifier).searchMedicines(
      itemName: '',
      page: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: const Text('의약품 정보 검색'),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: widget.showBackButton,
        leading: widget.showBackButton 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            )
          : null,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Bar
                    MedicineSearchBar(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onClear: _clearSearch,
                      onSearch: _performSearch,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 12),
                    // Filter Chips
                    MedicineFilterChips(
                      selectedFilter: _selectedFilter,
                      onFilterChanged: _onFilterChanged,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
            // Content Area
            Expanded(
              child: _isSearching
                  ? _buildSearchResults(isDarkMode)
                  : _buildInitialContent(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialContent(bool isDarkMode) {
    final recentSearches = ref.watch(recentSearchesProvider);
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (recentSearches.isNotEmpty) ...[
            RecentSearchSection(
              recentSearches: recentSearches,
              onSearchTap: _onRecentSearchTap,
              onClearAll: () {
                ref.read(recentSearchesProvider.notifier).clearSearches();
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 32),
          ],
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.medication_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '의약품 검색 안내',
                            style: AppTextStyles.headline6.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '의약품명 또는 제조사명으로 검색하세요',
                            style: AppTextStyles.body2.copyWith(
                              color: isDarkMode
                                  ? AppColors.textOnPrimary.withOpacity(0.7)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...[
                  '정확한 의약품명으로 검색하면 더 정확한 결과를 얻을 수 있습니다',
                  '복용 전 반드시 의사나 약사와 상담하세요',
                  '부작용이 발생하면 즉시 복용을 중단하고 전문가와 상담하세요',
                ].map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 16,
                          color: AppColors.primary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tip,
                            style: AppTextStyles.caption.copyWith(
                              color: isDarkMode
                                  ? AppColors.textOnPrimary.withOpacity(0.7)
                                  : AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDarkMode) {
    final searchState = ref.watch(medicineSearchProvider);

    return searchState.when(
      data: (results) {
        print('=== MedicineScreen build search results ===');
        print('Results count: ${results.length}');
        if (results.isNotEmpty) {
          print('First result:');
          print('  - itemName: ${results.first.itemName}');
          print('  - entpName: ${results.first.entpName}');
        }
        
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  '검색 결과가 없습니다',
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '다른 검색어로 시도해보세요',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: results.length + 1,
          itemBuilder: (context, index) {
            if (index == results.length) {
              // Load more button
              final notifier = ref.read(medicineSearchProvider.notifier);
              if (notifier.hasMore) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(medicineSearchProvider.notifier).loadMore();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('더보기'),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            final medicine = results[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MedicineCard(
                medicine: medicine,
                isDarkMode: isDarkMode,
                onTap: () {
                  // Navigate to detail screen
                  context.push(
                    '/medicine/detail',
                    extra: medicine,
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              '오류가 발생했습니다',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.error,
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
} 