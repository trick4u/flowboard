import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BoardController extends GetxController {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5001/api'));
  final storage = GetStorage();

  var boards = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBoards();
  }

  Future<void> fetchBoards() async {
    try {
      String token = storage.read('token');
      final res = await _dio.get('/boards', options: Options(
        headers: {'Authorization': 'Bearer $token'}
      ));
      boards.value = res.data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch boards');
    }
  }
}
