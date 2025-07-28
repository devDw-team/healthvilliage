import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/medicine_entity.dart';
import '../../providers/medicine_provider.dart';

/// 의약품 상세 정보 화면
class MedicineDetailScreen extends ConsumerStatefulWidget {
  final MedicineEntity medicine;

  const MedicineDetailScreen({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  ConsumerState<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // 탭 정보
  final List<Map<String, dynamic>> _tabs = [
    {'title': '효능', 'icon': Icons.healing_rounded},
    {'title': '사용법', 'icon': Icons.medication_liquid_rounded},
    {'title': '주의사항', 'icon': Icons.warning_amber_rounded},
    {'title': '상호작용', 'icon': Icons.sync_alt_rounded},
    {'title': '부작용', 'icon': Icons.error_outline_rounded},
    {'title': '보관법', 'icon': Icons.inventory_2_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    try {
      final favoritesAsync = ref.read(favoriteMedicinesProvider);
      final isFavorite = favoritesAsync.maybeWhen(
        data: (favorites) => favorites.any((m) => m.itemSeq == widget.medicine.itemSeq),
        orElse: () => false,
      );
      
      if (isFavorite) {
        await ref.read(favoriteMedicinesProvider.notifier).removeFavorite(widget.medicine.itemSeq);
      } else {
        await ref.read(favoriteMedicinesProvider.notifier).addFavorite(widget.medicine);
      }
      
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(!isFavorite ? '즐겨찾기에 추가되었습니다' : '즐겨찾기에서 제거되었습니다'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('즐겨찾기 처리 중 오류가 발생했습니다'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _shareMedicine() {
    final text = '${widget.medicine.itemName}\n'
        '제조사: ${widget.medicine.entpName}\n'
        '${widget.medicine.efcyQesitm != null ? '효능: ${_stripHtml(widget.medicine.efcyQesitm!)}' : ''}';
    Share.share(text);
  }
  
  String _stripHtml(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final favoritesAsync = ref.watch(favoriteMedicinesProvider);
    final isFavorite = favoritesAsync.maybeWhen(
      data: (favorites) => favorites.any((m) => m.itemSeq == widget.medicine.itemSeq),
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.surfaceDark : AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: isDarkMode
                            ? AppColors.textOnPrimary
                            : AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: Text(
                        widget.medicine.itemName,
                        style: AppTextStyles.headline5.copyWith(
                          color: isDarkMode
                              ? AppColors.textOnPrimary
                              : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _toggleFavorite,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(isFavorite),
                              color: isFavorite
                                  ? AppColors.error
                                  : isDarkMode
                                      ? AppColors.textOnPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: _shareMedicine,
                          icon: Icon(
                            Icons.share_rounded,
                            color: isDarkMode
                                ? AppColors.textOnPrimary
                                : AppColors.textPrimary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Medicine Header
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
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
                  ),
                  child: Column(
                    children: [
                      // Medicine Image
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: widget.medicine.itemImage != null && widget.medicine.itemImage!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  widget.medicine.itemImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildImagePlaceholder();
                                  },
                                ),
                              )
                            : _buildImagePlaceholder(),
                      ),
                      const SizedBox(height: 16),
                      // Manufacturer
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.business_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.medicine.entpName,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.surfaceDark : AppColors.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode
                          ? AppColors.borderDark.withOpacity(0.3)
                          : AppColors.border.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textTertiary,
                  labelStyle: AppTextStyles.tabLabel,
                  tabs: _tabs.map((tab) {
                    return Tab(
                      child: Row(
                        children: [
                          Icon(tab['icon'], size: 18),
                          const SizedBox(width: 6),
                          Text(tab['title']),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildEfficacyTab(isDarkMode),
                    _buildUsageTab(isDarkMode),
                    _buildPrecautionsTab(isDarkMode),
                    _buildInteractionsTab(isDarkMode),
                    _buildSideEffectsTab(isDarkMode),
                    _buildStorageTab(isDarkMode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.medication_rounded,
        size: 48,
        color: AppColors.primary.withOpacity(0.5),
      ),
    );
  }

  Widget _buildEfficacyTab(bool isDarkMode) {
    return _buildTabContent(
      isDarkMode: isDarkMode,
      content: [
        if (widget.medicine.efcyQesitm != null && widget.medicine.efcyQesitm!.isNotEmpty)
          _buildContentSection(
            title: '효능·효과',
            content: _stripHtml(widget.medicine.efcyQesitm!),
            icon: Icons.healing_rounded,
            isDarkMode: isDarkMode,
          )
        else
          _buildContentSection(
            title: '효능·효과',
            content: '정보가 없습니다.',
            icon: Icons.healing_rounded,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }

  Widget _buildUsageTab(bool isDarkMode) {
    return _buildTabContent(
      isDarkMode: isDarkMode,
      content: [
        if (widget.medicine.useMethodQesitm != null && widget.medicine.useMethodQesitm!.isNotEmpty)
          _buildContentSection(
            title: '용법·용량',
            content: _stripHtml(widget.medicine.useMethodQesitm!),
            icon: Icons.medication_liquid_rounded,
            isDarkMode: isDarkMode,
          )
        else
          _buildContentSection(
            title: '용법·용량',
            content: '정보가 없습니다.',
            icon: Icons.medication_liquid_rounded,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }

  Widget _buildPrecautionsTab(bool isDarkMode) {
    return _buildTabContent(
      isDarkMode: isDarkMode,
      content: [
        if (widget.medicine.atpnWarnQesitm != null && widget.medicine.atpnWarnQesitm!.isNotEmpty)
          _buildContentSection(
            title: '사용 전 반드시 알아야 할 내용',
            content: _stripHtml(widget.medicine.atpnWarnQesitm!),
            icon: Icons.warning_amber_rounded,
            isDarkMode: isDarkMode,
            isWarning: true,
          ),
        if (widget.medicine.atpnQesitm != null && widget.medicine.atpnQesitm!.isNotEmpty)
          _buildContentSection(
            title: '사용상의 주의사항',
            content: _stripHtml(widget.medicine.atpnQesitm!),
            icon: Icons.info_outline_rounded,
            isDarkMode: isDarkMode,
          ),
        if ((widget.medicine.atpnWarnQesitm == null || widget.medicine.atpnWarnQesitm!.isEmpty) &&
            (widget.medicine.atpnQesitm == null || widget.medicine.atpnQesitm!.isEmpty))
          _buildContentSection(
            title: '주의사항',
            content: '정보가 없습니다.',
            icon: Icons.warning_amber_rounded,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }

  Widget _buildInteractionsTab(bool isDarkMode) {
    return _buildTabContent(
      isDarkMode: isDarkMode,
      content: [
        if (widget.medicine.intrcQesitm != null && widget.medicine.intrcQesitm!.isNotEmpty)
          _buildContentSection(
            title: '약물 상호작용',
            content: _stripHtml(widget.medicine.intrcQesitm!),
            icon: Icons.sync_alt_rounded,
            isDarkMode: isDarkMode,
          )
        else
          _buildContentSection(
            title: '약물 상호작용',
            content: '정보가 없습니다.',
            icon: Icons.sync_alt_rounded,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }

  Widget _buildSideEffectsTab(bool isDarkMode) {
    return _buildTabContent(
      isDarkMode: isDarkMode,
      content: [
        if (widget.medicine.seQesitm != null && widget.medicine.seQesitm!.isNotEmpty)
          _buildContentSection(
            title: '이상반응',
            content: _stripHtml(widget.medicine.seQesitm!),
            icon: Icons.error_outline_rounded,
            isDarkMode: isDarkMode,
            isWarning: true,
          )
        else
          _buildContentSection(
            title: '이상반응',
            content: '정보가 없습니다.',
            icon: Icons.error_outline_rounded,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }

  Widget _buildStorageTab(bool isDarkMode) {
    return _buildTabContent(
      isDarkMode: isDarkMode,
      content: [
        if (widget.medicine.depositMethodQesitm != null && widget.medicine.depositMethodQesitm!.isNotEmpty)
          _buildContentSection(
            title: '보관 방법',
            content: _stripHtml(widget.medicine.depositMethodQesitm!),
            icon: Icons.inventory_2_rounded,
            isDarkMode: isDarkMode,
          )
        else
          _buildContentSection(
            title: '보관 방법',
            content: '정보가 없습니다.',
            icon: Icons.inventory_2_rounded,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }

  Widget _buildTabContent({
    required bool isDarkMode,
    required List<Widget> content,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: content,
      ),
    );
  }

  Widget _buildContentSection({
    required String title,
    required String content,
    required IconData icon,
    required bool isDarkMode,
    bool isWarning = false,
    bool isError = false,
  }) {
    Color iconColor = AppColors.primary;
    Color bgColor = AppColors.primary.withOpacity(0.1);
    
    if (isWarning) {
      iconColor = AppColors.warning;
      bgColor = AppColors.warning.withOpacity(0.1);
    } else if (isError) {
      iconColor = AppColors.error;
      bgColor = AppColors.error.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.surfaceDark
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppColors.borderDark.withOpacity(0.3)
              : AppColors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.headline6.copyWith(
                    color: isDarkMode
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.body2.copyWith(
              color: isDarkMode
                  ? AppColors.textOnPrimary.withOpacity(0.8)
                  : AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}