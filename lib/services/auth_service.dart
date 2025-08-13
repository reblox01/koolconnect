import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import './supabase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Get current user session
  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => currentSession?.user;
  bool get isLoggedIn => currentSession != null;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
      return response;
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    if (!isLoggedIn) return null;

    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();
      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  Future<UserProfile> updateUserProfile(Map<String, dynamic> updates) async {
    if (!isLoggedIn) throw Exception('User not logged in');

    try {
      final response = await _client
          .from('user_profiles')
          .update(updates)
          .eq('id', currentUser!.id)
          .select()
          .single();
      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Check if user has specific role
  Future<bool> hasRole(UserRole role) async {
    try {
      final userProfile = await getCurrentUserProfile();
      return userProfile?.role == role;
    } catch (error) {
      return false;
    }
  }

  // Check if user is manager
  Future<bool> isManager() async => await hasRole(UserRole.manager);

  // Check if user is teacher
  Future<bool> isTeacher() async => await hasRole(UserRole.teacher);

  // Check if user is parent
  Future<bool> isParent() async => await hasRole(UserRole.parent);
}
