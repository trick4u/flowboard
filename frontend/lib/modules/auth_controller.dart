import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5001/api'));
  final storage = GetStorage();

  Future<void> login(String email, String password) async {
    try {
      final res = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      storage.write('token', res.data['token']);
      Get.snackbar('Success', 'Logged in');
      // Navigate to board screen later
      Get.offAllNamed('/board');

    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      Get.snackbar('Success', 'Registered');
      Get.toNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Register failed');
    }
  }
}
