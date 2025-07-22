import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/hospital_model.dart';
import '../../providers/hospital_provider.dart';
import '../../providers/pharmacy_provider.dart'; // 시도/시군구 목록 재사용

class HospitalSearchScreen extends ConsumerStatefulWidget {
  const HospitalSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HospitalSearchScreen> createState() => _HospitalSearchScreenState();
}

class _HospitalSearchScreenState extends ConsumerState<HospitalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchHospitals() {
    ref.read(hospitalCurrentPageProvider.notifier).state = 1;
    ref.read(hospitalSearchTextProvider.notifier).state = _searchController.text;
    setState(() {
      _isFilterExpanded = false;
    });
  }

  void _clearAllFilters() {
    ref.read(hospitalSelectedSidoProvider.notifier).state = null;
    ref.read(hospitalSelectedSgguProvider.notifier).state = null;
    ref.read(hospitalSelectedClCdProvider.notifier).state = null;
    ref.read(hospitalSearchTextProvider.notifier).state = '';
    ref.read(hospitalCurrentPageProvider.notifier).state = 1;
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSido = ref.watch(hospitalSelectedSidoProvider);
    final selectedSggu = ref.watch(hospitalSelectedSgguProvider);
    final selectedClCd = ref.watch(hospitalSelectedClCdProvider);
    final hospitalSearchText = ref.watch(hospitalSearchTextProvider);
    final currentPage = ref.watch(hospitalCurrentPageProvider);

    final hasSearchCondition = selectedSido != null || hospitalSearchText.isNotEmpty;
    
    final searchParams = HospitalSearchParams(
      pageNo: currentPage,
      numOfRows: 50,
      sidoCd: selectedSido,
      sgguCd: selectedSggu,
      clCd: selectedClCd,
      yadmNm: hospitalSearchText.isNotEmpty ? hospitalSearchText : null,
    );

    final hospitalsAsync = hasSearchCondition 
        ? ref.watch(hospitalListProvider(searchParams))
        : const AsyncValue<List<HospitalModel>>.data([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('병원 검색'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // 검색 필터 섹션
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
                // 헤더 부분
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
                            if (!_isFilterExpanded && (selectedSido != null || selectedClCd != null || hospitalSearchText.isNotEmpty)) ...[
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
                                            ref.read(hospitalSelectedSidoProvider.notifier).state = null;
                                            ref.read(hospitalSelectedSgguProvider.notifier).state = null;
                                          },
                                          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                                          labelStyle: AppTextStyles.caption,
                                        );
                                      },
                                    ),
                                  if (selectedSggu != null)
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final sgguList = ref.watch(hospitalSgguListProvider);
                                        final sgguName = sgguList.firstWhere(
                                          (item) => item.code == selectedSggu,
                                          orElse: () => SgguItem(code: '', name: ''),
                                        ).name;
                                        return Chip(
                                          label: Text(sgguName),
                                          deleteIcon: const Icon(Icons.close, size: 16),
                                          onDeleted: () {
                                            ref.read(hospitalSelectedSgguProvider.notifier).state = null;
                                          },
                                          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                                          labelStyle: AppTextStyles.caption,
                                        );
                                      },
                                    ),
                                  if (selectedClCd != null)
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final typeList = ref.watch(hospitalTypeListProvider);
                                        final typeName = typeList.firstWhere(
                                          (item) => item.code == selectedClCd,
                                          orElse: () => HospitalTypeItem(code: null, name: ''),
                                        ).name;
                                        return Chip(
                                          label: Text(typeName),
                                          deleteIcon: const Icon(Icons.close, size: 16),
                                          onDeleted: () {
                                            ref.read(hospitalSelectedClCdProvider.notifier).state = null;
                                          },
                                          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                                          labelStyle: AppTextStyles.caption,
                                        );
                                      },
                                    ),
                                  if (hospitalSearchText.isNotEmpty)
                                    Chip(
                                      label: Text(hospitalSearchText),
                                      deleteIcon: const Icon(Icons.close, size: 16),
                                      onDeleted: () {
                                        _searchController.clear();
                                        ref.read(hospitalSearchTextProvider.notifier).state = '';
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
                // 필터 내용
                if (_isFilterExpanded) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 병원 종별 선택
                        Consumer(
                          builder: (context, ref, child) {
                            final typeList = ref.watch(hospitalTypeListProvider);
                            return DropdownButtonFormField<String?>(
                              value: selectedClCd,
                              decoration: InputDecoration(
                                labelText: '병원 종별 선택',
                                prefixIcon: const Icon(
                                  Icons.local_hospital,
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
                              hint: const Text('병원 종별을 선택하세요'),
                              isExpanded: true,
                              items: typeList.map((type) {
                                return DropdownMenuItem(
                                  value: type.code,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                ref.read(hospitalSelectedClCdProvider.notifier).state = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
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
                                ref.read(hospitalSelectedSidoProvider.notifier).state = value;
                                ref.read(hospitalSelectedSgguProvider.notifier).state = null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // 시군구 선택
                        Consumer(
                          builder: (context, ref, child) {
                            final sgguList = ref.watch(hospitalSgguListProvider);
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
                                      ref.read(hospitalSelectedSgguProvider.notifier).state = value;
                                    }
                                  : null,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // 병원명 검색
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: '병원명 검색',
                            hintText: '병원명을 입력하세요',
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
                                      ref.read(hospitalSearchTextProvider.notifier).state = '';
                                    },
                                  )
                                : null,
                          ),
                          onSubmitted: (_) => _searchHospitals(),
                          onChanged: (value) {
                            setState(() {});
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
                                onPressed: _searchHospitals,
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
                          '시/도를 선택하거나 병원명을 입력하세요',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  )
                : hospitalsAsync.when(
                    data: (hospitals) {
                      if (hospitals.isEmpty) {
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
                        itemCount: hospitals.length + 1,
                        itemBuilder: (context, index) {
                          if (index == hospitals.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: currentPage > 1
                                        ? () {
                                            ref.read(hospitalCurrentPageProvider.notifier).state = currentPage - 1;
                                          }
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  const SizedBox(width: 16),
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
                                  IconButton(
                                    onPressed: hospitals.length == 50
                                        ? () {
                                            ref.read(hospitalCurrentPageProvider.notifier).state = currentPage + 1;
                                          }
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                            );
                          }
                          
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
                                  if (hospital.category != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        hospital.category!,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primary,
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
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
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
                                        const Icon(
                                          Icons.phone,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
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
                                  if (hospital.drTotCnt != null && hospital.drTotCnt!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '의사 ${hospital.drTotCnt}명',
                                          style: AppTextStyles.caption,
                                        ),
                                        if (hospital.sdrCnt != null && hospital.sdrCnt!.isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            '(전문의 ${hospital.sdrCnt}명)',
                                            style: AppTextStyles.caption.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                  if (hospital.distance != null) ...[
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
                                          '${hospital.distance!.toStringAsFixed(0)}m',
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
                                  if (hospital.phone != null)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.phone,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () async {
                                        final tel = 'tel:${hospital.phone}';
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
                                    onPressed: () async {
                                      final mapUrl = 'https://map.naver.com/search/${Uri.encodeComponent(hospital.address)}';
                                      if (await canLaunchUrl(Uri.parse(mapUrl))) {
                                        await launchUrl(
                                          Uri.parse(mapUrl),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
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
                              ref.invalidate(hospitalListProvider(searchParams));
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