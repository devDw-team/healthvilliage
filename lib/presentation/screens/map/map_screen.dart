import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/kakao_config.dart';
import '../../../data/models/hospital_marker.dart';
import '../../../core/services/location_service.dart';
import '../../widgets/kakao_map_widget.dart';

/// 지도 화면
class MapScreen extends StatefulWidget {
  final HospitalMarker? initialMarker;
  final String? markerType; // 'hospital' or 'pharmacy'

  const MapScreen({
    super.key,
    this.initialMarker,
    this.markerType,
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
      setState(() {
        latitude = widget.initialMarker!.latitude;
        longitude = widget.initialMarker!.longitude;
        hospitals = [widget.initialMarker!];
      });
    } else {
      // 현재 위치 가져오기
      Position? position = await LocationService.getCurrentPosition();
      
      if (position != null) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }
    }
    
    // 주변 병원/약국 데이터 로드
    if (widget.initialMarker == null) {
      _loadNearbyFacilities();
    }
    
    setState(() {
      isLoading = false;
    });
  }

  /// 주변 병원/약국 데이터 로드 (더미 데이터)
  void _loadNearbyFacilities() {
    // 실제로는 API 호출 또는 provider를 통해 데이터를 가져와야 함
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialMarker != null 
            ? widget.initialMarker!.name 
            : '주변 ${widget.markerType == 'hospital' ? '병원' : widget.markerType == 'pharmacy' ? '약국' : '의료시설'} 찾기'
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 시설 이름
            Text(
              facility.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            
            // 주소
            Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(facility.address),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // 전화번호
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Text(facility.phoneNumber),
              ],
            ),
            const SizedBox(height: 20),
            
            // 액션 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _callFacility(facility.phoneNumber),
                    icon: const Icon(Icons.phone),
                    label: const Text('전화하기'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToFacility(facility),
                    icon: const Icon(Icons.directions),
                    label: const Text('길찾기'),
                  ),
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
    if (position != null) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      mapKey.currentState?.moveToCurrentLocation();
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
} 