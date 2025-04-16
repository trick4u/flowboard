import 'package:dio/dio.dart';

class ApiService {
  static final _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5001/api'));

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }
}
