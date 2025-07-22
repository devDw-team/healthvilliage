import 'package:flutter/material.dart';

import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/medicine/medicine_screen.dart';
import '../presentation/screens/roulette/roulette_screen.dart';
import '../presentation/screens/calendar/calendar_screen.dart';
import '../presentation/screens/mypage/mypage_screen.dart';
import '../presentation/screens/prescription/prescription_screen.dart';

/// 앱의 라우팅을 관리하는 클래스
class AppRouter {
  // 라우트 이름 상수
  static const String splash = '/';
  static const String home = '/home';
  static const String medicine = '/medicine';
  static const String roulette = '/roulette';
  static const String calendar = '/calendar';
  static const String myPage = '/mypage';
  static const String prescription = '/prescription';
  
  // 병원 관련 라우트
  static const String hospitalDetail = '/hospital/detail';
  static const String pharmacyDetail = '/pharmacy/detail';
  static const String emergencyDetail = '/emergency/detail';
  
  // 의약품 관련 라우트
  static const String medicineDetail = '/medicine/detail';
  static const String medicineSearch = '/medicine/search';
  
  // 처방전 관련 라우트
  static const String prescriptionScan = '/prescription/scan';
  static const String prescriptionDetail = '/prescription/detail';
  
  // 설정 관련 라우트
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String notifications = '/notifications';

  /// 라우트 생성 함수
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _createRoute(const SplashScreen());
        
      case home:
        return _createRoute(const HomeScreen());
        
      case medicine:
        return _createRoute(const MedicineScreen());
        
      case roulette:
        return _createRoute(const RouletteScreen());
        
      case calendar:
        return _createRoute(const CalendarScreen());
        
      case myPage:
        return _createRoute(const MyPageScreen());
        
      case prescription:
        return _createRoute(const PrescriptionScreen());
        
      // 기본 라우트 (에러 처리)
      default:
        return _createRoute(
          const NotFoundScreen(),
        );
    }
  }

  /// 페이지 전환 애니메이션이 있는 라우트 생성
  static PageRoute<T> _createRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration? transitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// 페이드 인 애니메이션으로 라우트 생성
  static PageRoute<T> _createFadeRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration? transitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// 스케일 애니메이션으로 라우트 생성
  static PageRoute<T> _createScaleRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration? transitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var scaleTween = Tween<double>(begin: 0.8, end: 1.0).chain(
          CurveTween(curve: curve),
        );
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }
}

/// 404 페이지
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('페이지를 찾을 수 없습니다'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              '요청하신 페이지를 찾을 수 없습니다',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppRouter.home);
              },
              child: const Text('홈으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
} 