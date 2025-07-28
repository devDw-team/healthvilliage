import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// 최근 검색어 섹션 위젯
class RecentSearchSection extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTap;
  final VoidCallback? onClearAll;
  final bool isDarkMode;

  const RecentSearchSection({
    Key? key,
    required this.recentSearches,
    required this.onSearchTap,
    this.onClearAll,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 검색어',
              style: AppTextStyles.headline6.copyWith(
                color: isDarkMode
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: onClearAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '전체 삭제',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: recentSearches.map((search) {
            return _buildRecentSearchChip(search);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentSearchChip(String search) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSearchTap(search),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.surfaceDark
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.borderDark.withOpacity(0.3)
                  : AppColors.border.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                search,
                style: AppTextStyles.caption.copyWith(
                  color: isDarkMode
                      ? AppColors.textOnPrimary.withOpacity(0.7)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}