import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app.dart';
import 'core/services/supabase_service.dart';


/// 앱의 진입점
void main() async {
  // Flutter 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();
  
  // 시스템 UI 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // 화면 방향을 세로 모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  try {
    // 환경 변수 로드
    await dotenv.load(fileName: ".env");
    
    // Hive 초기화
    await Hive.initFlutter();
    
    // 필요한 Hive Box들 열기
    await Future.wait([
      Hive.openBox('app_settings'),
      Hive.openBox('user_data'),
      Hive.openBox('cache_data'),
    ]);
    
    // Supabase 초기화
    await SupabaseService.instance.initialize();
    
    // WebView 플랫폼별 초기화
    if (Platform.isAndroid) {
      WebViewPlatform.instance;
    }
    
    // 카카오맵 초기화 (kakao_map_plugin은 자동으로 키를 처리함)
    
    // 앱 실행
    runApp(
      const ProviderScope(
        child: HealthVillageApp(),
      ),
    );
  } catch (e, stackTrace) {
    // 초기화 실패 시 에러 로깅
    debugPrint('App initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // 기본 에러 화면으로 앱 실행
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  '앱 초기화 중 오류가 발생했습니다',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // 앱 재시작
                    main();
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
