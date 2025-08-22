import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/kakao_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/hospital_marker.dart';
import '../../../core/services/location_service.dart';
import '../../widgets/kakao_map_widget.dart';
import '../../providers/favorite_hospitals_provider.dart';
import '../../providers/favorite_pharmacies_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nearby_facilities_provider.dart';
import '../../../core/services/hospital_api_service.dart';
import '../../../core/services/pharmacy_api_service.dart';

/// 지도 화면
class MapScreen extends StatefulWidget {
  final HospitalMarker? initialMarker;
  final String? markerType; // 'hospital' or 'pharmacy'
  final bool isNearbyMode; // 내 주변 모드

  const MapScreen({
    super.key,
    this.initialMarker,
    this.markerType,
    this.isNearbyMode = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 상태 변수들
  double latitude = KakaoConfig.defaultLatitude;
  double longitude = KakaoConfig.defaultLongitude;
  bool isLoading = true;
  List<HospitalMarker> hospitals = [];
  SearchRadius currentRadius = SearchRadius.km1;  // 기본값 1km
  Set<FacilityType> enabledTypes = {
    FacilityType.pharmacy,  // 약국만 기본 활성화
  };
  
  // 위젯 키 (맵 컨트롤용)
  final GlobalKey<KakaoMapWidgetState> mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  /// 지도 초기화
  Future<void> _initializeMap() async {
    // 초기 마커가 있으면 해당 위치로 설정
    if (widget.initialMarker != null) {
      if (mounted) {
        setState(() {
          latitude = widget.initialMarker!.latitude;
          longitude = widget.initialMarker!.longitude;
          hospitals = [widget.initialMarker!];
          isLoading = false;
        });
      }
    } else {
      // 현재 위치 가져오기
      Position? position = await LocationService.getCurrentPosition();
      
      if (position != null && mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }
      
      // 주변 병원/약국 데이터 로드
      if (widget.isNearbyMode) {
        // 내 주변 모드일 때는 실제 API 호출
        await _loadNearbyFacilities();
      } else {
        // 일반 모드일 때는 더미 데이터 사용하고 로딩 종료
        _loadNearbyFacilities();
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  /// 주변 병원/약국 데이터 로드
  Future<void> _loadNearbyFacilities() async {
    if (!widget.isNearbyMode) {
      // 기존 더미 데이터 사용
      hospitals = [
        HospitalMarker(
          id: 'hospital_1',
          name: '서울대학교병원',
          latitude: latitude + 0.002,
          longitude: longitude + 0.002,
          address: '서울특별시 종로구 대학로 101',
          phoneNumber: '02-2072-2114',
          type: 'hospital',
        ),
        HospitalMarker(
          id: 'pharmacy_1',
          name: '종로약국',
          latitude: latitude - 0.003,
          longitude: longitude + 0.001,
          address: '서울특별시 종로구 종로 123',
          phoneNumber: '02-1234-5678',
          type: 'pharmacy',
        ),
      ];

      // 마커 타입에 따라 필터링
      if (widget.markerType != null) {
        hospitals = hospitals.where((h) => h.type == widget.markerType).toList();
      }
      return;
    }

    // 내 주변 모드일 때 실제 API 호출
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('위치 정보를 가져올 수 없습니다.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }

      // 시설 검색
      final facilities = <HospitalMarker>[];
      
      // 병원 검색
      if (enabledTypes.contains(FacilityType.hospital)) {
        final hospitalApi = HospitalApiService();
        try {
          final hospitalList = await hospitalApi.getHospitalList(
            xPos: position.longitude,
            yPos: position.latitude,
            radius: currentRadius.meters,
            numOfRows: 20,
          );
          for (final hospital in hospitalList) {
            facilities.add(HospitalMarker(
              id: hospital.id ?? hospital.ykiho ?? '',
              name: hospital.name ?? '병원',
              address: hospital.address ?? '',
              phoneNumber: hospital.phone ?? '',
              latitude: hospital.latitude ?? position.latitude,
              longitude: hospital.longitude ?? position.longitude,
              type: 'hospital',
            ));
          }
        } catch (e) {
          print('병원 검색 오류: $e');
        }
      }

      // 약국 검색
      if (enabledTypes.contains(FacilityType.pharmacy)) {
        final pharmacyApi = PharmacyApiService();
        try {
          final pharmacyList = await pharmacyApi.getPharmacyList(
            xPos: position.longitude,
            yPos: position.latitude,
            radius: currentRadius.meters,
            numOfRows: 20,
          );
          for (final pharmacy in pharmacyList) {
            facilities.add(HospitalMarker(
              id: pharmacy.id ?? pharmacy.ykiho ?? '',
              name: pharmacy.name ?? '약국',
              address: pharmacy.address ?? '',
              phoneNumber: pharmacy.phone ?? '',
              latitude: pharmacy.latitude ?? position.latitude,
              longitude: pharmacy.longitude ?? position.longitude,
              type: 'pharmacy',
            ));
          }
        } catch (e) {
          print('약국 검색 오류: $e');
        }
      }

      // 응급실 검색은 필요시 추가

      if (mounted) {
        setState(() {
          hospitals = facilities;
          isLoading = false;
        });
      }

      if (facilities.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currentRadius.label} 내에 의료시설이 없습니다.'),
          ),
        );
      }
    } catch (e) {
      print('시설 검색 오류: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('시설 검색 중 오류가 발생했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialMarker != null 
            ? widget.initialMarker!.name 
            : widget.isNearbyMode
              ? '내 주변 의료시설'
              : '주변 ${widget.markerType == 'hospital' ? '병원' : widget.markerType == 'pharmacy' ? '약국' : '의료시설'} 찾기'
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (widget.isNearbyMode) ...[
            // 반경 선택 버튼
            PopupMenuButton<SearchRadius>(
              icon: const Icon(Icons.radar),
              onSelected: (SearchRadius radius) {
                setState(() {
                  currentRadius = radius;
                });
                _loadNearbyFacilities();
              },
              itemBuilder: (BuildContext context) => SearchRadius.values
                  .map((radius) => PopupMenuItem<SearchRadius>(
                        value: radius,
                        child: Text(radius.label),
                      ))
                  .toList(),
            ),
            // 필터 버튼
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
          ],
          // 지도 타입 변경 버튼
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showMapTypeDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 카카오맵
                KakaoMapWidget(
                  key: mapKey,
                  latitude: latitude,
                  longitude: longitude,
                  hospitals: hospitals,
                  onMarkerTap: _showFacilityInfo,
                ),
                
                // 상단 정보 표시
                if (widget.isNearbyMode)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${currentRadius.label} 반경 내 ${_getEnabledTypesString()} 표시 중',
                              style: AppTextStyles.body2,
                            ),
                          ),
                          if (hospitals.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${hospitals.length}개',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                
                // 현재 위치 버튼
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    onPressed: _moveToCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
    );
  }

  /// 병원/약국 정보 표시
  void _showFacilityInfo(HospitalMarker facility) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핸들 바
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // 시설 이름
            Text(
              facility.name,
              style: AppTextStyles.headline5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // 주소
            Row(
              children: [
                Icon(Icons.location_on, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    facility.address,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // 전화번호
            Row(
              children: [
                Icon(Icons.phone, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  facility.phoneNumber,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 액션 버튼들
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () => _callFacility(facility.phoneNumber),
                    icon: const Icon(Icons.phone, size: 20),
                    label: const Text('전화하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToFacility(facility),
                    icon: const Icon(Icons.directions, size: 20),
                    label: const Text('길찾기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 즐겨찾기 버튼
                Consumer(
                  builder: (context, ref, _) {
                    final user = ref.watch(currentUserProvider);
                    if (user == null) return const SizedBox.shrink();
                    
                    final facilityId = facility.id;
                    final isHospital = widget.markerType == 'hospital' || facility.type == 'hospital';
                    
                    final isFavoriteAsync = isHospital
                        ? ref.watch(isHospitalFavoriteProvider(facilityId))
                        : ref.watch(isPharmacyFavoriteProvider(facilityId));
                    
                    return isFavoriteAsync.when(
                      data: (isFavorite) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isFavorite ? Colors.red : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : AppColors.textSecondary,
                            size: 24,
                          ),
                          onPressed: () async {
                            if (isHospital) {
                              await ref.read(favoriteHospitalsProvider.notifier).toggleFavorite(facilityId);
                            } else {
                              await ref.read(favoritePharmaciesProvider.notifier).toggleFavorite(facilityId);
                            }
                            
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite 
                                    ? '즐겨찾기에서 제거되었습니다'
                                    : '즐겨찾기에 추가되었습니다',
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: isFavorite ? AppColors.textSecondary : AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ),
                      loading: () => Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(12),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const IconButton(
                          icon: Icon(Icons.favorite_border, size: 24),
                          onPressed: null,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 현재 위치로 이동
  void _moveToCurrentLocation() async {
    Position? position = await LocationService.getCurrentPosition();
    if (position != null && mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      mapKey.currentState?.moveToCurrentLocation();
      
      // 내 주변 모드일 때는 위치 이동 시 재검색
      if (widget.isNearbyMode) {
        _loadNearbyFacilities();
      }
    }
  }

  /// 지도 타입 선택 다이얼로그
  void _showMapTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지도 타입 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('일반 지도'),
              onTap: () {
                mapKey.currentState?.changeMapType(MapType.normal);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('위성 지도'),
              onTap: () {
                mapKey.currentState?.changeMapType(MapType.satellite);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 병원/약국에 전화 걸기
  void _callFacility(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  /// 병원/약국으로 길찾기
  void _navigateToFacility(HospitalMarker facility) async {
    // 카카오맵 앱으로 길찾기
    final kakaoMapUrl = 'kakaomap://route'
        '?sp=$latitude,$longitude'
        '&ep=${facility.latitude},${facility.longitude}'
        '&by=CAR';
    
    // 카카오맵 웹으로 길찾기 (앱이 없는 경우)
    final webUrl = 'https://map.kakao.com/link/to/${facility.name},${facility.latitude},${facility.longitude}';
    
    try {
      if (await canLaunchUrl(Uri.parse(kakaoMapUrl))) {
        await launchUrl(Uri.parse(kakaoMapUrl));
      } else {
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('길찾기를 실행할 수 없습니다.')),
      );
    }
  }

  /// 활성화된 시설 종류 문자열 반환
  String _getEnabledTypesString() {
    if (enabledTypes.isEmpty) return '시설 없음';
    
    final types = enabledTypes.map((type) => type.label).toList();
    return types.join(', ');
  }

  /// 필터 다이얼로그 표시
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('시설 종류 선택'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '지도에 표시할 의료시설을 선택하세요',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...FacilityType.values.map((type) {
                    return CheckboxListTile(
                      title: Text(type.label),
                      subtitle: Text(
                        type == FacilityType.pharmacy 
                          ? '약국 정보를 표시합니다'
                          : type == FacilityType.hospital
                            ? '병원 정보를 표시합니다'
                            : '응급실 정보를 표시합니다',
                        style: AppTextStyles.caption,
                      ),
                      value: enabledTypes.contains(type),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            enabledTypes.add(type);
                          } else {
                            enabledTypes.remove(type);
                          }
                        });
                      },
                      secondary: Icon(
                        type == FacilityType.hospital
                            ? Icons.local_hospital
                            : type == FacilityType.pharmacy
                                ? Icons.local_pharmacy
                                : Icons.emergency,
                        color: type == FacilityType.hospital
                            ? AppColors.hospital
                            : type == FacilityType.pharmacy
                                ? AppColors.pharmacy
                                : AppColors.emergency,
                      ),
                    );
                  }).toList(),
                  if (enabledTypes.isEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            size: 20,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '최소 하나의 시설을 선택해주세요',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: enabledTypes.isNotEmpty
                      ? () {
                          Navigator.pop(context);
                          setState(() {});
                          _loadNearbyFacilities();
                        }
                      : null,
                  child: const Text('적용'),
                ),
              ],
            );
          },
        );
      },
    );
  }
} 