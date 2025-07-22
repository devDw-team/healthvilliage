import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';

/// 룰렛 화면 (추후 구현)
class RouletteScreen extends ConsumerWidget {
  const RouletteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.roulette),
      ),
      body: const Center(
        child: Text('룰렛 화면\n(추후 구현)'),
      ),
    );
  }
} 