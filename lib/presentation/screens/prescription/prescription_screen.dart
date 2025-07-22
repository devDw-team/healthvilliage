import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';

/// 처방전 화면 (추후 구현)
class PrescriptionScreen extends ConsumerWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.prescription),
      ),
      body: const Center(
        child: Text('처방전 화면\n(추후 구현)'),
      ),
    );
  }
} 