import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/kakao_map_widget.dart';
import '../../../data/models/hospital_marker.dart';
import '../../../routes/app_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/emergency_room_model.dart';
import '../../providers/emergency_provider.dart';

/// 응급실 검색 화면
class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    
    // 화면 진입 시 검색 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reset = ref.read(resetSearchProvider);
      reset();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('응급실 찾기'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _tabController.index == 0 
                              ? AppColors.primary.withOpacity(0.1) 
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.map_outlined,
                          size: 28,
                          color: _tabController.index == 0 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('지역으로 찾기'),
                    ],
                  ),
                ),
                Tab(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _tabController.index == 1 
                              ? AppColors.primary.withOpacity(0.1) 
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.my_location_outlined,
                          size: 28,
                          color: _tabController.index == 1 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('내 주변 응급실'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _RegionSearchTab(),
          _NearbySearchTab(),
        ],
      ),
    );
  }
}

/// 지역으로 찾기 탭
class _RegionSearchTab extends ConsumerWidget {
  const _RegionSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidoList = ref.watch(sidoListProvider);
    final selectedSido = ref.watch(selectedSidoProvider);
    final sigunguList = ref.watch(sigunguListProvider);
    final selectedSigungu = ref.watch(selectedSigunguProvider);
    final emergencyRoomList = ref.watch(emergencyRoomListProvider);

    return Column(
      children: [
        // 지역 선택 섹션
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '지역 선택',
                    style: AppTextStyles.subtitle1,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      final reset = ref.read(resetSearchProvider);
                      reset();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('초기화'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // 시도 선택
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedSido,
                      hint: const Text('시/도 선택'),
                      decoration: InputDecoration(
                        labelText: '시/도',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: sidoList.map((sido) {
                        return DropdownMenuItem(
                          value: sido,
                          child: Text(sido),
                        );
                      }).toList(),
                      onChanged: (value) {
                        ref.read(selectedSidoProvider.notifier).state = value;
                        ref.read(selectedSigunguProvider.notifier).state = null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 시군구 선택
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedSigungu,
                      hint: Text(selectedSido == null ? '시/도를 먼저 선택' : '시/군/구 선택'),
                      decoration: InputDecoration(
                        labelText: '시/군/구',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: sigunguList.isEmpty
                          ? []
                          : sigunguList.map((sigungu) {
                              return DropdownMenuItem(
                                value: sigungu,
                                child: Text(sigungu),
                              );
                            }).toList(),
                      onChanged: selectedSido == null
                          ? null
                          : (value) {
                              ref.read(selectedSigunguProvider.notifier).state = value;
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // 응급실 목록
        Expanded(
          child: emergencyRoomList.when(
            data: (rooms) {
              if (rooms.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_hospital,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        selectedSido == null || selectedSigungu == null
                            ? '지역을 선택해주세요'
                            : '해당 지역에 응급실 정보가 없습니다',
                        style: AppTextStyles.body1.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return _EmergencyRoomCard(room: rooms[index]);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    '응급실 정보를 불러올 수 없습니다',
                    style: AppTextStyles.body1.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(emergencyRoomListProvider),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 내 주변 응급실 탭
class _NearbySearchTab extends ConsumerWidget {
  const _NearbySearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = ref.watch(currentLocationProvider);
    final nearbyRooms = ref.watch(nearbyEmergencyRoomsProvider);

    return currentLocation.when(
      data: (position) {
        if (position == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  '위치 서비스가 꺼져있습니다',
                  style: AppTextStyles.headline6,
                ),
                const SizedBox(height: 8),
                const Text(
                  '내 주변 응급실을 찾으려면\n위치 권한을 허용해주세요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body2,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('위치 설정 열기'),
                ),
              ],
            ),
          );
        }

        return nearbyRooms.when(
          data: (rooms) {
            if (rooms.isEmpty) {
              return const Center(
                child: Text('주변에 응급실이 없습니다'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return _EmergencyRoomCard(
                  room: rooms[index],
                  showDistance: true,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text('주변 응급실을 불러올 수 없습니다'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(nearbyEmergencyRoomsProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(
        child: Text('위치를 가져올 수 없습니다'),
      ),
    );
  }
}

/// 응급실 카드
class _EmergencyRoomCard extends StatelessWidget {
  final EmergencyRoom room;
  final bool showDistance;

  const _EmergencyRoomCard({
    Key? key,
    required this.room,
    this.showDistance = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => _EmergencyRoomDetailSheet(room: room),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 병원명과 분류
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.dutyName,
                          style: AppTextStyles.subtitle1,
                        ),
                        if (room.dutyEmclsName != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.emergency.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              room.dutyEmclsName!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.emergency,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showDistance && room.distance != null) ...[
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        Text(
                          '${room.distance!.toStringAsFixed(1)}km',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              
              // 주소
              if (room.dutyAddr != null) ...[
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        room.dutyAddr!,
                        style: AppTextStyles.body2,
                      ),
                    ),
                  ],
                ),
              ],
              
              // 전화번호
              if (room.dutyTel3 != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      room.dutyTel3!,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              
              // 가용병상 정보
              const SizedBox(height: 12),
              _BedInfoRow(room: room),
              
              // 의료장비 가용여부
              const SizedBox(height: 8),
              _EquipmentInfoRow(room: room),
            ],
          ),
        ),
      ),
    );
  }
}

/// 병상 정보 행
class _BedInfoRow extends StatelessWidget {
  final EmergencyRoom room;

  const _BedInfoRow({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bedInfoList = [
      if (room.availableGeneralBeds != null)
        _BedInfo('일반', room.availableGeneralBeds!),
      if (room.availableGeneralICU != null)
        _BedInfo('중환자실', room.availableGeneralICU!),
      if (room.availableOperatingRooms != null)
        _BedInfo('수술실', room.availableOperatingRooms!),
      if (room.availableAdmissionRooms != null)
        _BedInfo('입원실', room.availableAdmissionRooms!),
    ];

    if (bedInfoList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: bedInfoList
          .map((info) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: info.count > 0
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: info.count > 0
                        ? Colors.green.withOpacity(0.5)
                        : Colors.red.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bed,
                      size: 14,
                      color: info.count > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${info.name} ${info.count}',
                      style: AppTextStyles.caption.copyWith(
                        color: info.count > 0 ? Colors.green[700] : Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// 의료장비 정보 행
class _EquipmentInfoRow extends StatelessWidget {
  final EmergencyRoom room;

  const _EquipmentInfoRow({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final equipmentList = [
      if (room.ctAvailable != null)
        _EquipmentInfo('CT', room.ctAvailable == 'Y'),
      if (room.mriAvailable != null)
        _EquipmentInfo('MRI', room.mriAvailable == 'Y'),
      if (room.ambulanceAvailable != null)
        _EquipmentInfo('구급차', room.ambulanceAvailable == 'Y'),
    ];

    if (equipmentList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      children: equipmentList
          .map((info) {
            return Chip(
                label: Text(
                  info.name,
                  style: AppTextStyles.caption.copyWith(
                    color: info.available 
                        ? Colors.blue[700]
                        : Colors.grey[600],
                  ),
                ),
                backgroundColor: info.available 
                    ? Colors.blue.withOpacity(0.1) 
                    : Colors.grey[200],
                avatar: Icon(
                  info.available ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: info.available 
                      ? Colors.blue
                      : Colors.grey,
                ),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
          })
          .toList(),
    );
  }
}

/// 응급실 상세 정보 시트
class _EmergencyRoomDetailSheet extends ConsumerWidget {
  final EmergencyRoom room;

  const _EmergencyRoomDetailSheet({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailProvider = ref.watch(emergencyRoomDetailProvider(room.hpid));
    
    // 디버깅: 응급실 데이터 확인
    print('[EmergencyRoomDetailSheet] room data:');
    print('  - hpid: ${room.hpid}');
    print('  - dutyName: ${room.dutyName}');
    print('  - latitude: ${room.latitude}');
    print('  - longitude: ${room.longitude}');
    print('  - dutyAddr: ${room.dutyAddr}');
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 핸들 바
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // 헤더
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 병원명
                          Text(
                            room.dutyName,
                            style: AppTextStyles.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 가용병상 정보
                          Row(
                            children: [
                              Icon(
                                Icons.bed,
                                size: 20,
                                color: (room.availableGeneralBeds ?? 0) > 0 ? AppColors.success : AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '응급실 병상: ${room.availableGeneralBeds ?? 0}개',
                                style: AppTextStyles.body2.copyWith(
                                  color: (room.availableGeneralBeds ?? 0) > 0 ? AppColors.success : AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 지도 보기 버튼 (detailProvider 로딩 상태에 상관없이 표시)
                    Consumer(
                      builder: (context, ref, child) {
                        final detailAsync = ref.watch(emergencyRoomDetailProvider(room.hpid));
                        final detailRoom = detailAsync.valueOrNull;
                        final lat = detailRoom?.latitude ?? room.latitude;
                        final lon = detailRoom?.longitude ?? room.longitude;
                        
                        return FilledButton.icon(
                          onPressed: (lat != null && lon != null) ? () {
                            // 지도 화면으로 이동
                            context.push(
                              '/map',
                              extra: {
                                'initialMarker': HospitalMarker(
                                  id: room.hpid,
                                  name: room.dutyName,
                                  latitude: double.parse(lat),
                                  longitude: double.parse(lon),
                                  address: detailRoom?.dutyAddr ?? room.dutyAddr ?? '',
                                  phoneNumber: detailRoom?.dutyTel3 ?? room.dutyTel3 ?? '',
                                  type: 'hospital',
                                ),
                                'markerType': 'hospital',
                              },
                            );
                          } : null,
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text('지도'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // 상세 정보
              Expanded(
                child: detailProvider.when(
                  data: (detail) {
                    // 상세 정보가 없으면 기본 정보 사용, 위도/경도는 상세 정보 우선
                    final roomDetail = detail ?? room;
                    final latitude = roomDetail.latitude ?? room.latitude;
                    final longitude = roomDetail.longitude ?? room.longitude;
                    
                    // 디버깅용 로그
                    print('응급실 상세 정보: ${roomDetail.dutyAddr}, ${roomDetail.dutyTel1}, ${roomDetail.dutyTel3}');
                    print('위도/경도: $latitude, $longitude (detail: ${detail?.latitude}, ${detail?.longitude})');
                    
                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        // 기본 정보
                        _DetailSection(
                          title: '기본 정보',
                          children: [
                            // 주소는 room 객체에도 있을 수 있음
                            if ((roomDetail.dutyAddr != null && roomDetail.dutyAddr!.isNotEmpty) || 
                                (room.dutyAddr != null && room.dutyAddr!.isNotEmpty))
                              _DetailItem(
                                icon: Icons.location_on,
                                label: '주소',
                                value: roomDetail.dutyAddr ?? room.dutyAddr ?? '',
                              ),
                            // 대표전화
                            if ((roomDetail.dutyTel1 != null && roomDetail.dutyTel1!.isNotEmpty) ||
                                (room.dutyTel1 != null && room.dutyTel1!.isNotEmpty))
                              InkWell(
                                onTap: () async {
                                  final phone = roomDetail.dutyTel1 ?? room.dutyTel1 ?? '';
                                  final url = Uri.parse('tel:$phone');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                                child: _DetailItem(
                                  icon: Icons.phone,
                                  label: '대표전화',
                                  value: roomDetail.dutyTel1 ?? room.dutyTel1 ?? '',
                                  valueColor: AppColors.primary,
                                ),
                              ),
                            // 응급실 전화
                            if ((roomDetail.dutyTel3 != null && roomDetail.dutyTel3!.isNotEmpty) ||
                                (room.dutyTel3 != null && room.dutyTel3!.isNotEmpty))
                              InkWell(
                                onTap: () async {
                                  final phone = roomDetail.dutyTel3 ?? room.dutyTel3 ?? '';
                                  final url = Uri.parse('tel:$phone');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                                child: _DetailItem(
                                  icon: Icons.local_hospital,
                                  label: '응급실',
                                  value: roomDetail.dutyTel3 ?? room.dutyTel3 ?? '',
                                  valueColor: AppColors.error,
                                ),
                              ),
                          ],
                        ),
                        
                        // 병상 정보
                        _DetailSection(
                          title: '병상 정보',
                          children: [
                            if (room.availableGeneralBeds != null)
                              _DetailItem(
                                icon: Icons.bed,
                                label: '응급실',
                                value: '${room.availableGeneralBeds}개',
                                valueColor: room.availableGeneralBeds! > 0 ? AppColors.success : AppColors.error,
                              ),
                            if (room.availableOperatingRooms != null)
                              _DetailItem(
                                icon: Icons.airline_seat_flat,
                                label: '수술실',
                                value: '${room.availableOperatingRooms}개',
                                valueColor: room.availableOperatingRooms! > 0 ? AppColors.success : AppColors.error,
                              ),
                            if (room.availableGeneralICU != null)
                              _DetailItem(
                                icon: Icons.medical_services,
                                label: '중환자실',
                                value: '${room.availableGeneralICU}개',
                                valueColor: room.availableGeneralICU! > 0 ? AppColors.success : AppColors.error,
                              ),
                          ],
                        ),
                        
                        // 의료장비
                        if (room.ctAvailable != null || room.mriAvailable != null || room.ambulanceAvailable != null)
                          _DetailSection(
                            title: '의료장비',
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (room.ctAvailable == 'Y')
                                    _EquipmentChip(label: 'CT', isAvailable: true),
                                  if (room.mriAvailable == 'Y')
                                    _EquipmentChip(label: 'MRI', isAvailable: true),
                                  if (room.ambulanceAvailable == 'Y')
                                    _EquipmentChip(label: '구급차', isAvailable: true),
                                ],
                              ),
                            ],
                          ),
                        
                        // 카카오맵
                        if (latitude != null && longitude != null)
                          _DetailSection(
                            title: '위치',
                            children: [
                              InkWell(
                                onTap: () {
                                  // 지도 클릭 시 전체 지도 화면으로 이동
                                  if (latitude != null && longitude != null) {
                                    context.push(
                                      '/map',
                                      extra: {
                                        'initialMarker': HospitalMarker(
                                          id: room.hpid,
                                          name: room.dutyName,
                                          latitude: double.parse(latitude),
                                          longitude: double.parse(longitude),
                                          address: roomDetail.dutyAddr ?? room.dutyAddr ?? '',
                                          phoneNumber: roomDetail.dutyTel3 ?? room.dutyTel3 ?? '',
                                          type: 'hospital',
                                        ),
                                        'markerType': 'hospital',
                                      },
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 200,
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: KakaoMapWidget(
                                            latitude: double.parse(latitude),
                                            longitude: double.parse(longitude),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 지도 위에 클릭 가능 표시
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.open_in_full,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '전체화면',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // 전체 지도 화면으로 이동
                                    if (latitude != null && longitude != null) {
                                      context.push(
                                        '/map',
                                        extra: {
                                          'initialMarker': HospitalMarker(
                                            id: room.hpid,
                                            name: room.dutyName,
                                            latitude: double.parse(latitude),
                                            longitude: double.parse(longitude),
                                            address: roomDetail.dutyAddr ?? room.dutyAddr ?? '',
                                            phoneNumber: roomDetail.dutyTel3 ?? room.dutyTel3 ?? '',
                                            type: 'hospital',
                                          ),
                                          'markerType': 'hospital',
                                        },
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.directions),
                                  label: const Text('길찾기'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        
                        const SizedBox(height: 40),
                      ],
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
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '상세 정보를 불러올 수 없습니다',
                          style: AppTextStyles.body1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '잠시 후 다시 시도해주세요',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 상세 정보 섹션
class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(height: 24),
      ],
    );
  }
}

/// 상세 정보 아이템
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon, 
            size: 20, 
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 의료장비 칩
class _EquipmentChip extends StatelessWidget {
  final String label;
  final bool isAvailable;

  const _EquipmentChip({
    Key? key,
    required this.label,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable 
            ? AppColors.success.withOpacity(0.1) 
            : AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable 
              ? AppColors.success.withOpacity(0.3) 
              : AppColors.textSecondary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isAvailable ? AppColors.success : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 병상 정보 칩
class _BedInfoChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _BedInfoChip({
    Key? key,
    required this.label,
    required this.count,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasAvailable = count > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: hasAvailable 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasAvailable 
              ? AppColors.success.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: hasAvailable ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: AppTextStyles.caption.copyWith(
              color: hasAvailable ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// 도우미 클래스들
class _BedInfo {
  final String name;
  final int count;

  _BedInfo(this.name, this.count);
}

class _EquipmentInfo {
  final String name;
  final bool available;

  _EquipmentInfo(this.name, this.available);
} 