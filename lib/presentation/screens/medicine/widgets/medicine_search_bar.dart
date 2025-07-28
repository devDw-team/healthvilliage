import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// 의약품 검색 바 위젯
class MedicineSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final VoidCallback onSearch;
  final bool isDarkMode;

  const MedicineSearchBar({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onSearch,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<MedicineSearchBar> createState() => _MedicineSearchBarState();
}

class _MedicineSearchBarState extends State<MedicineSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldCenterAlign = !widget.focusNode.hasFocus && widget.controller.text.isEmpty;
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: AppTextStyles.inputText.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: shouldCenterAlign ? TextAlign.center : TextAlign.start,
              decoration: InputDecoration(
                hintText: '의약품명 또는 제조사명 검색',
                hintStyle: AppTextStyles.inputHint.copyWith(
                  color: AppColors.textTertiary.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                widget.onSearch();
                widget.focusNode.unfocus();
              },
            ),
          ),
          if (widget.controller.text.isNotEmpty) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onClear,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
          // Search Button
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onSearch,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}