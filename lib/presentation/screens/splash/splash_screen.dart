import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

/// 앱 시작 시 보여지는 스플래시 화면
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  /// 애니메이션 초기화
  void _initializeAnimations() {
    // 페이드 애니메이션
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // 스케일 애니메이션
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  /// 스플래시 시퀀스 시작
  void _startSplashSequence() async {
    // mounted 체크를 추가하여 dispose 된 후 애니메이션 실행 방지
    if (!mounted) return;
    
    // 애니메이션 시작
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    _scaleController.forward();

    // 초기화 작업 수행
    await _performInitialization();

    // Auth 상태에 따라 적절한 화면으로 이동
    if (mounted) {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      if (isAuthenticated) {
        context.go('/');
      } else {
        context.go('/login');
      }
    }
  }

  /// 앱 초기화 작업
  Future<void> _performInitialization() async {
    // 최소 스플래시 표시 시간 확보
    await Future.delayed(const Duration(seconds: 2));

    // Auth 상태가 로드될 때까지 대기
    if (mounted) {
      // Auth 상태 초기화가 완료될 때까지 잠시 대기
      int retries = 0;
      while (retries < 10 && mounted) {
        final authState = ref.read(authStateProvider);
        if (!authState.isLoading) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
        retries++;
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 영역
              AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.health_and_safety,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // 앱 이름
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  AppStrings.appName,
                  style: AppTextStyles.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 앱 서브타이틀
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  AppStrings.appSubtitle,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // 로딩 인디케이터
              FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 