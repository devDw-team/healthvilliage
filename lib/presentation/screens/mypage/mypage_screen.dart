import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';

/// 마이페이지 화면 (추후 구현)
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myPage),
      ),
      body: const Center(
        child: Text('마이페이지 화면\n(추후 구현)'),
      ),
    );
  }
} 