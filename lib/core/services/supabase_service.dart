import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseClient get client => _client;

  Future<void> initialize() async {
    // Debug: Print all loaded environment variables
    print('Loaded env variables: ${dotenv.env.keys.toList()}');
    
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    
    print('SUPABASE_URL: $supabaseUrl');
    print('SUPABASE_ANON_KEY length: ${supabaseAnonKey.length}');

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Supabase credentials not found in .env file. URL: $supabaseUrl, Key empty: ${supabaseAnonKey.isEmpty}');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(
        retryAttempts: 3,
      ),
    );

    _client = Supabase.instance.client;
  }

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    print('[SupabaseService] signIn 호출: $email');
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('[SupabaseService] signIn 응답 - User ID: ${response.user?.id}');
      print('[SupabaseService] signIn 응답 - Session: ${response.session != null}');
      return response;
    } catch (e) {
      print('[SupabaseService] signIn 오류: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Database methods
  SupabaseQueryBuilder from(String table) => _client.from(table);

  // Storage methods
  SupabaseStorageClient get storage => _client.storage;

  // Realtime methods
  RealtimeChannel channel(String name) => _client.channel(name);
}