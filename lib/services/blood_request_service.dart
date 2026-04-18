import 'package:dio/dio.dart';
import 'auth_service.dart';
import 'api_exceptions.dart';

class BloodRequestService {
  static const String _baseUrl =
      'https://seviour-server.vercel.app/api/v1/blood-requests';
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> listRequests({
    String? searchTerm,
    int? page,
    int? limit,
    String? patientBloodGroup,
    String? status,
    bool? isEmergency,
    String? requestToDonorId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (searchTerm != null && searchTerm.isNotEmpty)
        queryParams['searchTerm'] = searchTerm;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (patientBloodGroup != null && patientBloodGroup.isNotEmpty)
        queryParams['patientBloodGroup'] = patientBloodGroup;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (isEmergency != null) queryParams['isEmergency'] = isEmergency;
      if (requestToDonorId != null && requestToDonorId.isNotEmpty)
        queryParams['requestToDonorId'] = requestToDonorId;
      final response = await _dio.get(_baseUrl, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e), code: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> createRequest(Map<String, dynamic> data) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null)
        throw ApiException('You must be logged in to make a request.');
      final response = await _dio.post(
        _baseUrl,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
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
