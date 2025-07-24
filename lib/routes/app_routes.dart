import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/calendar/calendar_screen.dart';
import '../presentation/screens/emergency/emergency_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/hospital/hospital_search_screen.dart';
import '../presentation/screens/medicine/medicine_search_screen.dart';
import '../presentation/screens/mypage/mypage_screen.dart';
import '../presentation/screens/pharmacy/pharmacy_search_screen.dart';
import '../presentation/screens/prescription/prescription_screen.dart';
import '../presentation/screens/profile/profile_edit_screen.dart';
import '../presentation/screens/roulette/roulette_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/map/map_screen.dart';
import '../data/models/hospital_marker.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // 초기 상태 저장
  bool isInitialized = false;
  
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _RouterNotifier(ref),
    redirect: (context, state) {
      print('[AppRouter] redirect 호출됨');
      print('[AppRouter] 현재 경로: ${state.matchedLocation}');
      
      // 초기화가 완료되고 프로필 편집 페이지인 경우 리다이렉트 하지 않음
      if (isInitialized && state.matchedLocation == '/profile/edit') {
        print('[AppRouter] 프로필 편집 페이지, 리다이렉트 스킵');
        return null;
      }
      
      // If we're on splash screen, don't redirect
      if (state.matchedLocation == '/splash') {
        return null;
      }

      final authState = ref.read(authStateProvider);
      print('[AppRouter] Auth 상태: $authState');
      
      // Auth 상태가 로딩 중이면 대기
      if (authState.isLoading) {
        print('[AppRouter] Auth 로딩 중, redirect 하지 않음');
        return null;
      }

      // Check authentication status safely
      final isAuth = authState.when(
        data: (user) => user != null,
        loading: () => false,
        error: (_, __) => false,
      );
      
      print('[AppRouter] 인증 상태: $isAuth');
      
      // 초기화 완료 표시
      if (!isInitialized && isAuth) {
        isInitialized = true;
      }
      
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // If not authenticated and not on auth route, redirect to login
      if (!isAuth && !isAuthRoute) {
        print('[AppRouter] 미인증 상태, 로그인으로 리다이렉트');
        return '/login';
      }

      // If authenticated and on auth route, redirect to home
      if (isAuth && isAuthRoute) {
        print('[AppRouter] 인증됨, 홈으로 리다이렉트');
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/hospital',
        builder: (context, state) => const HospitalSearchScreen(),
      ),
      GoRoute(
        path: '/medicine',
        builder: (context, state) => const MedicineSearchScreen(),
      ),
      GoRoute(
        path: '/pharmacy',
        builder: (context, state) => const PharmacySearchScreen(),
      ),
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyScreen(),
      ),
      GoRoute(
        path: '/roulette',
        builder: (context, state) => const RouletteScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/mypage',
        builder: (context, state) => const MyPageScreen(),
      ),
      GoRoute(
        path: '/prescription',
        builder: (context, state) => const PrescriptionScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MapScreen(
            initialMarker: extra?['initialMarker'] as HospitalMarker?,
            markerType: extra?['markerType'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
    ],
  );
});

// Router notifier for auth state changes
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen(
      authStateProvider,
      (previous, next) {
        print('[_RouterNotifier] Auth 상태 변경됨');
        print('[_RouterNotifier] 이전: $previous');
        print('[_RouterNotifier] 현재: $next');
        notifyListeners();
      },
    );
  }
}