import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class DonationService {
  static const String _baseUrl = 'https://seviour-server.vercel.app/api/v1/donations';
  final Dio _dio = Dio();

  // List donations
  Future<List<dynamic>> listDonations({Map<String, dynamic>? filters}) async {
    try {
      final response = await _dio.get(_baseUrl, queryParameters: filters);
      return response.data['data'] as List<dynamic>;
    } on DioException catch (e) {
      throw ApiException(_parseDioError(e));
    }
  }

  // Get donation by id
  Future<Map<String, dynamic>> getDonation(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException(_parseDioError(e));
    }
  }

  // Create donation
  Future<Map<String, dynamic>> createDonation({
    required String donorId,
    required String bloodRequestId,
    required DateTime donationDate,
    required String status, // e.g. CONFIRMED
  }) async {
    try {
      final response = await _dio.post(_baseUrl, data: {
        'donorId': donorId,
        'bloodRequestId': bloodRequestId,
        'donationDate': donationDate.toIso8601String(),
        'status': status,
      });
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException(_parseDioError(e));
    }
  }

  // Update donation
  Future<Map<String, dynamic>> updateDonation({
    required String id,
    DateTime? donationDate,
    String? status,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (donationDate != null) data['donationDate'] = donationDate.toIso8601String();
      if (status != null) data['status'] = status;
      final response = await _dio.patch('$_baseUrl/$id', data: data);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException(_parseDioError(e));
    }
  }

  // Soft delete donation
  Future<void> deleteDonation(String id) async {
    try {
      await _dio.delete('$_baseUrl/$id');
    } on DioException catch (e) {
      throw ApiException(_parseDioError(e));
    }
  }

  String _parseDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      return data['message'] ?? data['error'] ?? 'Unknown error';
    }
    return e.message ?? 'Network error';
  }
}
