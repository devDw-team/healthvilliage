import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/supabase_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/hospital_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/hospital_repository.dart';

// Supabase Service Provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthRepositoryImpl(supabaseService);
});

final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return HospitalRepositoryImpl(supabaseService);
});