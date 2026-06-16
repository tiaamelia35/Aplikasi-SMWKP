import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';

class ApiClient {
  late Dio _dio;
  static const String _tokenKey = 'auth_token';

  ApiClient() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppAPI.baseUrl}${AppAPI.apiVersion}',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized - refresh token or logout
          if (error.response?.statusCode == 401) {
            // TODO: Implement token refresh or logout
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<T> post<T>(
    String path, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<T> put<T>(
    String path, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<T> patch<T>(
    String path, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Upload file
  Future<T> uploadFile<T>(
    String path, {
    required String filePath,
    Map<String, dynamic>? additionalData,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post(
        path,
        data: formData,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Upload multiple files
  Future<T> uploadFiles<T>(
    String path, {
    required List<String> filePaths,
    required String fileKey,
    Map<String, dynamic>? additionalData,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final files = <MultipartFile>[];
      for (final filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }

      final formData = FormData.fromMap({
        fileKey: files,
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post(
        path,
        data: formData,
      );
      return fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final errorMessage = error.response?.data['message'] ?? 'Unknown error occurred';
        return Exception(errorMessage);
      } else if (error.type == DioExceptionType.connectionTimeout) {
        return Exception('Connection timeout');
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return Exception('Receive timeout');
      }
      return Exception('Network error: ${error.message}');
    }
    return Exception('Unknown error: $error');
  }
}

// Singleton instance
final apiClient = ApiClient();
