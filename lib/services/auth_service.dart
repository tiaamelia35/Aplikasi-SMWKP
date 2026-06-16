import 'package:shared_preferences/shared_preferences.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/models/user_model.dart';
import 'package:smwkp_culinary_tourism/services/api_client.dart';

class AuthService {
  // Login with hardcoded local credentials for demo mode.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail == 'admin@smwkp.com' && password == 'admin') {
      return UserModel(
        id: 'admin1',
        email: normalizedEmail,
        name: 'Admin SMWKP',
        userType: UserType.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    if (normalizedEmail == 'owner@smwkp.com' && password == 'owner') {
      return UserModel(
        id: 'owner1',
        email: normalizedEmail,
        name: 'Pemilik Usaha',
        userType: UserType.businessOwner,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    if (normalizedEmail == 'user@smwkp.com' && password == 'user') {
      return UserModel(
        id: 'user1',
        email: normalizedEmail,
        name: 'Pengunjung',
        userType: UserType.tourist,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    throw Exception('Email atau password salah. Gunakan admin@smwkp.com / admin, owner@smwkp.com / owner, atau user@smwkp.com / user.');
  }

  // Register a new user
  Future<UserModel> register({
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
    required UserType userType,
  }) async {
    try {
      if (password != confirmPassword) {
        throw Exception('Password does not match');
      }

      final response = await apiClient.post<Map<String, dynamic>>(
        AppAPI.registerEndpoint,
        data: {
          'email': email,
          'name': name,
          'password': password,
          'userType': userType.name,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );

      final token = response['accessToken'] ?? response['token'];
      final userJson = response['user'] ?? response['data'];

      if (token != null) {
        await apiClient.setToken(token as String);
      }

      return UserModel.fromJson(Map<String, dynamic>.from(userJson as Map));
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Logout and clear token
  Future<void> logout() async {
    try {
      await apiClient.post<Map<String, dynamic>>(
        AppAPI.logoutEndpoint,
        data: {},
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (_) {
      // ignore backend failure and clear local session anyway
    }

    await apiClient.clearToken();
  }

  // Update profile
  Future<UserModel> updateProfile({
    required UserModel user,
    required String name,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    try {
      final response = await apiClient.put<Map<String, dynamic>>(
        AppAPI.userProfileEndpoint,
        data: {
          'name': name,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );

      return UserModel.fromJson(Map<String, dynamic>.from(response['user'] ?? response['data'] as Map<String, dynamic>));
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount({required String userId}) async {
    try {
      await apiClient.delete<Map<String, dynamic>>(
        AppAPI.userProfileEndpoint,
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Delete account failed: $e');
    }
  }

  // Check if user is authenticated by token
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get current user from backend
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        AppAPI.userProfileEndpoint,
        fromJson: (data) => Map<String, dynamic>.from(data),
      );

      return UserModel.fromJson(Map<String, dynamic>.from(response['user'] ?? response['data'] as Map<String, dynamic>));
    } catch (e) {
      return null;
    }
  }
}
