import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/pharmacy_model.dart';
import '../../../data/models/hospital_marker.dart';
import '../../providers/pharmacy_provider.dart';
import '../../widgets/common/custom_text_field.dart';

class PharmacySearchScreen extends ConsumerStatefulWidget {
  const PharmacySearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PharmacySearchScreen> createState() => _PharmacySearchScreenState();
}

class _PharmacySearchScreenState extends ConsumerState<PharmacySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterExpanded = true; // 필터 섹션 확장 상태

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 검색 정보 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllFilters();
      // 초기 진입 시 자동 검색하지 않음 (빈 검색 파라미터로 인한 오류 방지)
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    // 페이지 나갈 때는 Provider 상태를 변경하지 않음 (Widget lifecycle 오류 방지)
    super.dispose();
  }

  void _searchPharmacies() {
    ref.read(currentPageProvider.notifier).state = 1;
    ref.read(pharmacySearchTextProvider.notifier).state = _searchController.text;
    // 검색 후 필터 섹션 접기
    setState(() {
      _isFilterExpanded = false;
    });
  }

  void _clearAllFilters() {
    // 모든 검색 필터 초기화
    ref.read(selectedSidoProvider.notifier).state = null;
    ref.read(selectedSgguProvider.notifier).state = null;
    ref.read(pharmacySearchTextProvider.notifier).state = '';
    ref.read(currentPageProvider.notifier).state = 1;
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSido = ref.watch(selectedSidoProvider);
    final selectedSggu = ref.watch(selectedSgguProvider);
    final pharmacySearchText = ref.watch(pharmacySearchTextProvider);
    final currentPage = ref.watch(currentPageProvider);

    // 검색 파라미터 설정 - 최소한 하나의 검색 조건이 있을 때만 검색
    final hasSearchCondition = selectedSido != null || pharmacySearchText.isNotEmpty;
    
    final searchParams = PharmacySearchParams(
      pageNo: currentPage,
      numOfRows: 50,  // 20개에서 50개로 증가
      sidoCd: selectedSido,
      sgguCd: selectedSggu,
      yadmNm: pharmacySearchText.isNotEmpty ? pharmacySearchText : null,
    );

    final pharmaciesAsync = hasSearchCondition 
        ? ref.watch(pharmacyListProvider(searchParams))
        : const AsyncValue<List<PharmacyModel>>.data([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('약국 검색'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // 검색 필터 섹션 - 접을 수 있는 형태로 변경
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
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
            child: Column(
              children: [
                // 헤더 부분 - 항상 표시
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFilterExpanded = !_isFilterExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '검색 필터',
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!_isFilterExpanded && (selectedSido != null || pharmacySearchText.isNotEmpty)) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (selectedSido != null)
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final sidoList = ref.watch(sidoListProvider);
                                        final sidoName = sidoList.firstWhere(
                                          (item) => item.code == selectedSido,
                                          orElse: () => SidoItem(code: '', name: ''),
                                        ).name;
                                        return Chip(
                                          label: Text(sidoName),
                                          deleteIcon: const Icon(Icons.close, size: 16),
                                          onDeleted: () {
                                            ref.read(selectedSidoProvider.notifier).state = null;
                                            ref.read(selectedSgguProvider.notifier).state = null;
                                          },
                                          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                                          labelStyle: AppTextStyles.caption,
                                        );
                                      },
                                    ),
                                  if (selectedSggu != null)
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final sgguList = ref.watch(sgguListProvider);
                                        final sgguName = sgguList.firstWhere(
                                          (item) => item.code == selectedSggu,
                                          orElse: () => SgguItem(code: '', name: ''),
                                        ).name;
                                        return Chip(
                                          label: Text(sgguName),
                                          deleteIcon: const Icon(Icons.close, size: 16),
                                          onDeleted: () {
                                            ref.read(selectedSgguProvider.notifier).state = null;
                                          },
                                          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                                          labelStyle: AppTextStyles.caption,
                                        );
                                      },
                                    ),
                                  if (pharmacySearchText.isNotEmpty)
                                    Chip(
                                      label: Text(pharmacySearchText),
                                      deleteIcon: const Icon(Icons.close, size: 16),
                                      onDeleted: () {
                                        _searchController.clear();
                                        ref.read(pharmacySearchTextProvider.notifier).state = '';
                                      },
                                      backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                                      labelStyle: AppTextStyles.caption,
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        Icon(
                          _isFilterExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                      ],
                    ),
                  ),
                ),
                // 필터 내용 - 확장 시에만 표시
                if (_isFilterExpanded) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 시도 선택
                        Consumer(
                          builder: (context, ref, child) {
                            final sidoList = ref.watch(sidoListProvider);
                            return DropdownButtonFormField<String>(
                              value: selectedSido,
                              decoration: InputDecoration(
                                labelText: '시/도 선택',
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: AppColors.background,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              hint: const Text('시/도를 선택하세요'),
                              isExpanded: true,
                              items: sidoList.map((sido) {
                                return DropdownMenuItem(
                                  value: sido.code,
                                  child: Text(sido.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                ref.read(selectedSidoProvider.notifier).state = value;
                                ref.read(selectedSgguProvider.notifier).state = null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // 시군구 선택
                        Consumer(
                          builder: (context, ref, child) {
                            final sgguList = ref.watch(sgguListProvider);
                            return DropdownButtonFormField<String>(
                              value: selectedSggu,
                              decoration: InputDecoration(
                                labelText: '시/군/구 선택',
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: selectedSido != null 
                                      ? AppColors.primary 
                                      : AppColors.textTertiary,
                                  size: 24,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: AppColors.background,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              hint: const Text('시/군/구를 선택하세요'),
                              isExpanded: true,
                              items: sgguList.map((sggu) {
                                return DropdownMenuItem(
                                  value: sggu.code,
                                  child: Text(sggu.name),
                                );
                              }).toList(),
                              onChanged: selectedSido != null
                                  ? (value) {
                                      ref.read(selectedSgguProvider.notifier).state = value;
                                    }
                                  : null,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // 약국명 검색
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: '약국명 검색',
                            hintText: '약국명을 입력하세요',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      ref.read(pharmacySearchTextProvider.notifier).state = '';
                                    },
                                  )
                                : null,
                          ),
                          onSubmitted: (_) => _searchPharmacies(),
                          onChanged: (value) {
                            setState(() {}); // suffixIcon 업데이트를 위해
                          },
                        ),
                        const SizedBox(height: 16),
                        // 버튼들
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _clearAllFilters,
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 20,
                                ),
                                label: const Text(
                                  '초기화',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textSecondary,
                                  side: BorderSide(
                                    color: AppColors.border,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _searchPharmacies,
                                icon: const Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                label: const Text(
                                  '검색',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shadowColor: AppColors.primary.withOpacity(0.3),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 검색 결과
          Expanded(
            child: !hasSearchCondition
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '검색 조건을 선택해주세요',
                          style: AppTextStyles.body1,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '시/도를 선택하거나 약국명을 입력하세요',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  )
                : pharmaciesAsync.when(
                    data: (pharmacies) {
                      if (pharmacies.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.textTertiary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                '검색 결과가 없습니다',
                                style: AppTextStyles.body1,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '다른 검색 조건으로 시도해보세요',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: pharmacies.length + 1, // 페이지네이션 버튼을 위해 +1
                        itemBuilder: (context, index) {
                          // 마지막 아이템은 페이지네이션 버튼
                          if (index == pharmacies.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 이전 페이지 버튼
                                  IconButton(
                                    onPressed: currentPage > 1
                                        ? () {
                                            ref.read(currentPageProvider.notifier).state = currentPage - 1;
                                          }
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  const SizedBox(width: 16),
                                  // 페이지 정보
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '페이지 $currentPage',
                                      style: AppTextStyles.body2,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // 다음 페이지 버튼
                                  IconButton(
                                    onPressed: pharmacies.length == 50 // 50개가 모두 조회된 경우에만 다음 페이지 활성화
                                        ? () {
                                            ref.read(currentPageProvider.notifier).state = currentPage + 1;
                                          }
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          final pharmacy = pharmacies[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                pharmacy.name,
                                style: AppTextStyles.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          pharmacy.address,
                                          style: AppTextStyles.caption,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // 디버깅용: 시군구 정보 표시
                                  if (pharmacy.sgguCd != null || pharmacy.sgguCdNm != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${pharmacy.sgguCdNm ?? ''} (코드: ${pharmacy.sgguCd ?? ''})',
                                          style: AppTextStyles.caption.copyWith(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (pharmacy.phone != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
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
                                  if (pharmacy.distance != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.straighten,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${pharmacy.distance!.toStringAsFixed(0)}m',
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (pharmacy.phone != null)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.phone,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () async {
                                        final tel = 'tel:${pharmacy.phone}';
                                        if (await canLaunchUrl(Uri.parse(tel))) {
                                          await launchUrl(Uri.parse(tel));
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.directions,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      // 약국 정보를 HospitalMarker로 변환
                                      final marker = HospitalMarker(
                                        id: pharmacy.id,
                                        name: pharmacy.name,
                                        latitude: pharmacy.latitude,
                                        longitude: pharmacy.longitude,
                                        address: pharmacy.address,
                                        phoneNumber: pharmacy.phone ?? '',
                                        type: 'pharmacy',
                                      );
                                      
                                                                             // 맵 화면으로 이동 (extra로 마커 정보 전달)
                                      context.push('/map', extra: {
                                        'initialMarker': marker,
                                        'markerType': 'pharmacy',
                                      });
                                    },
                                  ),
                                ],
                              ),
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
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '데이터를 불러오는 중 오류가 발생했습니다',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(pharmacyListProvider(searchParams));
                            },
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
} 