import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_exceptions.dart';

class AuthService {
  static const String _baseUrl = 'https://seviour-server.vercel.app/api/v1';
  // static const String _baseUrl = 'http://localhost:5000/api/v1';
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Sign Up
  Future<Map<String, dynamic>> signUp({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    // Basic validation
    if (data['name'] == null || data['name'].toString().isEmpty) {
      throw ApiException('Name is required');
    }
    if (data['email'] == null) {
      throw ApiException('Valid email is required');
    }
    if (data['password'] == null || data['password'].toString().length < 6) {
      throw ApiException('Password must be at least 6 characters');
    }
    if (data['role'] == 'DONOR') {
      final donor = data['donorProfile'] ?? {};
      if (donor['bloodGroup'] == null ||
          donor['bloodGroup'].toString().isEmpty) {
        throw ApiException('Blood group is required for donors');
      }
      if (donor['contactNumber'] == null ||
          donor['contactNumber'].toString().isEmpty) {
        throw ApiException('Contact number is required for donors');
      }
    }
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(data),
        if (imagePath != null)
          'image': await MultipartFile.fromFile(
            imagePath,
            filename: 'profile.jpg',
          ),
      });
      final response = await _dio.post(
        '$_baseUrl/auth/sign-up/email',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      await _saveTokens(response.data['data']);
      return response.data['data'];
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  // Sign In
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      throw ApiException('Valid email is required');
    }
    if (password.isEmpty || password.length < 6) {
      throw ApiException('Password must be at least 6 characters');
    }
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/sign-in/email',
        data: {'email': email, 'password': password},
      );
      await _saveTokens(response.data['data']);
      return response.data['data'];
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  // Token refresh
  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final sessionToken = await _storage.read(key: 'sessionToken');
    if (refreshToken == null || sessionToken == null) {
      throw ApiException('No refresh/session token found');
    }
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/refresh-token',
        data: {'refreshToken': refreshToken, 'sessionToken': sessionToken},
      );
      await _saveTokens(response.data['data']);
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  // Error parsing helper
  ApiException _parseDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      final msg = data['message'] ?? data['error'] ?? 'Unknown error';
      return ApiException(msg.toString(), code: e.response?.statusCode);
    }
    return ApiException(
      e.message ?? 'Network error',
      code: e.response?.statusCode,
    );
  }

  // Save tokens securely
  Future<void> _saveTokens(Map<String, dynamic> data) async {
    if (data['accessToken'] != null) {
      await _storage.write(key: 'accessToken', value: data['accessToken']);
    }
    if (data['refreshToken'] != null) {
      await _storage.write(key: 'refreshToken', value: data['refreshToken']);
    }
    if (data['sessionToken'] != null) {
      await _storage.write(key: 'sessionToken', value: data['sessionToken']);
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return _storage.read(key: 'accessToken');
  }

  // Clear tokens
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
