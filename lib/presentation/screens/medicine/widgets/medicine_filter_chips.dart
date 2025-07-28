import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// 의약품 검색 필터 칩 위젯
class MedicineFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final bool isDarkMode;

  const MedicineFilterChips({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildFilterChip(
            label: '전체',
            value: 'all',
            icon: Icons.all_inclusive_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: '제품명',
            value: 'name',
            icon: Icons.medication_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: '제조사',
            value: 'manufacturer',
            icon: Icons.business_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedFilter == value;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onFilterChanged(value),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(isDarkMode ? 0.3 : 0.2)
                  : isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.5)
                    : isDarkMode
                        ? AppColors.borderDark.withOpacity(0.3)
                        : AppColors.border.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : isDarkMode
                            ? AppColors.textOnPrimary.withOpacity(0.7)
                            : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}