import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class DonorService {
  static const String _baseUrl =
      'https://seviour-server.vercel.app/api/v1/donors';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> listDonors({
    String? searchTerm,
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? bloodGroup,
    int? age,
    bool? isAvailable,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (searchTerm != null && searchTerm.isNotEmpty)
        queryParams['searchTerm'] = searchTerm;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;
      if (bloodGroup != null && bloodGroup.isNotEmpty)
        queryParams['bloodGroup'] = bloodGroup;
      if (age != null) queryParams['age'] = age;
      if (isAvailable != null) queryParams['isAvailable'] = isAvailable;

      final response = await _dio.get(_baseUrl, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e), code: e.response?.statusCode);
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is Map && data['error'] != null) {
        return data['error'].toString();
      }
    }
    return e.message ?? 'Network error';
  }
}
