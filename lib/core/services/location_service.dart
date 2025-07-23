import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// 위치 서비스 관리 클래스
class LocationService {
  /// 위치 권한 확인 및 요청
  static Future<bool> requestLocationPermission() async {
    // 위치 서비스 활성화 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // 설정으로 이동
      await openAppSettings();
      return false;
    }
    
    return true;
  }

  /// 현재 위치 가져오기
  static Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('위치 가져오기 실패: $e');
      return null;
    }
  }
} 