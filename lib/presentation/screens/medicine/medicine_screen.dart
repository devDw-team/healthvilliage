import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';

/// 의약품 화면 (추후 구현)
class MedicineScreen extends ConsumerWidget {
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicine),
      ),
      body: const Center(
        child: Text('의약품 화면\n(추후 구현)'),
      ),
    );
  }
} 