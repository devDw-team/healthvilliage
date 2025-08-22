import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/services/location_service.dart';
import '../../core/services/hospital_api_service.dart';
import '../../core/services/pharmacy_api_service.dart';
import '../../core/services/emergency_api_service.dart';
import '../../data/models/hospital_marker.dart';

enum SearchRadius {
  km1(1000, '1km'),
  km3(3000, '3km'),
  km5(5000, '5km');

  final int meters;
  final String label;
  const SearchRadius(this.meters, this.label);
}

enum FacilityType {
  hospital('병원'),
  pharmacy('약국'),
  emergency('응급실');

  final String label;
  const FacilityType(this.label);
}

class NearbyFacilitiesState {
  final List<HospitalMarker> facilities;
  final bool isLoading;
  final String? error;
  final Position? currentPosition;
  final SearchRadius radius;
  final Set<FacilityType> enabledTypes;

  NearbyFacilitiesState({
    this.facilities = const [],
    this.isLoading = false,
    this.error,
    this.currentPosition,
    this.radius = SearchRadius.km1,  // 기본값 1km로 변경
    this.enabledTypes = const {
      FacilityType.pharmacy,  // 약국만 기본 활성화
    },
  });

  NearbyFacilitiesState copyWith({
    List<HospitalMarker>? facilities,
    bool? isLoading,
    String? error,
    Position? currentPosition,
    SearchRadius? radius,
    Set<FacilityType>? enabledTypes,
  }) {
    return NearbyFacilitiesState(
      facilities: facilities ?? this.facilities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPosition: currentPosition ?? this.currentPosition,
      radius: radius ?? this.radius,
      enabledTypes: enabledTypes ?? this.enabledTypes,
    );
  }
}

final nearbyFacilitiesProvider = StateNotifierProvider<NearbyFacilitiesNotifier, NearbyFacilitiesState>((ref) {
  return NearbyFacilitiesNotifier(ref);
});

class NearbyFacilitiesNotifier extends StateNotifier<NearbyFacilitiesState> {
  final Ref _ref;
  final HospitalApiService _hospitalApi = HospitalApiService();
  final PharmacyApiService _pharmacyApi = PharmacyApiService();

  NearbyFacilitiesNotifier(this._ref) : super(NearbyFacilitiesState());

  Future<void> searchNearbyFacilities() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 현재 위치 가져오기
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        state = state.copyWith(
          isLoading: false,
          error: '위치 정보를 가져올 수 없습니다. 위치 권한을 확인해주세요.',
        );
        return;
      }

      state = state.copyWith(currentPosition: position);

      final facilities = <HospitalMarker>[];

      // 병원 검색
      if (state.enabledTypes.contains(FacilityType.hospital)) {
        try {
          final hospitals = await _hospitalApi.getHospitalList(
            xPos: position.longitude,
            yPos: position.latitude,
            radius: state.radius.meters,
            numOfRows: 20,
          );

          for (final hospital in hospitals) {
            facilities.add(HospitalMarker(
              id: hospital.id ?? hospital.ykiho ?? '',
              name: hospital.name ?? '병원',
              address: hospital.address ?? '',
              phoneNumber: hospital.phone ?? '',
              latitude: hospital.latitude ?? position.latitude,
              longitude: hospital.longitude ?? position.longitude,
              type: 'hospital',
              distance: _calculateDistance(
                position.latitude,
                position.longitude,
                hospital.latitude ?? position.latitude,
                hospital.longitude ?? position.longitude,
              ),
            ));
          }
        } catch (e) {
          print('병원 검색 오류: $e');
        }
      }

      // 약국 검색
      if (state.enabledTypes.contains(FacilityType.pharmacy)) {
        try {
          final pharmacies = await _pharmacyApi.getPharmacyList(
            xPos: position.longitude,
            yPos: position.latitude,
            radius: state.radius.meters,
            numOfRows: 20,
          );

          for (final pharmacy in pharmacies) {
            facilities.add(HospitalMarker(
              id: pharmacy.id ?? pharmacy.ykiho ?? '',
              name: pharmacy.name ?? '약국',
              address: pharmacy.address ?? '',
              phoneNumber: pharmacy.phone ?? '',
              latitude: pharmacy.latitude ?? position.latitude,
              longitude: pharmacy.longitude ?? position.longitude,
              type: 'pharmacy',
              distance: _calculateDistance(
                position.latitude,
                position.longitude,
                pharmacy.latitude ?? position.latitude,
                pharmacy.longitude ?? position.longitude,
              ),
            ));
          }
        } catch (e) {
          print('약국 검색 오류: $e');
        }
      }

      // 응급실 검색
      if (state.enabledTypes.contains(FacilityType.emergency)) {
        try {
          final emergencyApi = EmergencyApiService();
          final emergencyRooms = await emergencyApi.getEmergencyRoomByLocation(
            latitude: position.latitude,
            longitude: position.longitude,
            numOfRows: 20,
          );
          
          for (final emergency in emergencyRooms) {
            final lat = emergency.latitude is double 
                ? emergency.latitude as double
                : double.tryParse(emergency.latitude.toString()) ?? position.latitude;
            final lng = emergency.longitude is double
                ? emergency.longitude as double  
                : double.tryParse(emergency.longitude.toString()) ?? position.longitude;
                
            facilities.add(HospitalMarker(
              id: emergency.hpid ?? '',
              name: emergency.dutyName ?? '응급실',
              address: emergency.dutyAddr ?? '',
              phoneNumber: emergency.dutyTel1 ?? '',
              latitude: lat,
              longitude: lng,
              type: 'emergency',
              distance: _calculateDistance(
                position.latitude,
                position.longitude,
                lat,
                lng,
              ),
            ));
          }
        } catch (e) {
          print('응급실 검색 오류: $e');
        }
      }

      // 거리순 정렬
      facilities.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

      state = state.copyWith(
        facilities: facilities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '주변 시설 검색 중 오류가 발생했습니다: $e',
      );
    }
  }

  void setSearchRadius(SearchRadius radius) {
    state = state.copyWith(radius: radius);
    searchNearbyFacilities();
  }

  void toggleFacilityType(FacilityType type) {
    final newTypes = Set<FacilityType>.from(state.enabledTypes);
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }
    state = state.copyWith(enabledTypes: newTypes);
    searchNearbyFacilities();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}