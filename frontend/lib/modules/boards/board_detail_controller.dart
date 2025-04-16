import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BoardDetailController extends GetxController {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5001/api'));
  final storage = GetStorage();
  late Socket socket;

  var lists = [].obs;
  var tasks = {}.obs; // key = listId, value = List of tasks

  String? boardId;

  @override
  void onInit() {
    super.onInit();
    boardId = Get.parameters['id'];
    fetchLists();
  }

  void initSocket() {
  socket = IO.io('http://localhost:5001', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  socket.connect();

  socket.onConnect((_) {
    print('🔌 Socket connected!');
    socket.emit('joinBoard', {'token': storage.read('token'), 'boardId': boardId});
  });

  socket.on('taskUpdated', (data) {
    fetchLists(); // Re-fetch lists/tasks
  });
}

  Future<void> fetchLists() async {
    final token = storage.read('token');
    final res = await _dio.get('/lists/$boardId', options: Options(
      headers: {'Authorization': 'Bearer $token'}
    ));
    lists.value = res.data;

    for (var list in lists) {
      await fetchTasks(list['_id']);
    }
  }

  Future<void> fetchTasks(String listId) async {
    final token = storage.read('token');
    final res = await _dio.get('/tasks/$listId', options: Options(
      headers: {'Authorization': 'Bearer $token'}
    ));
    tasks[listId] = res.data;
    tasks.refresh();
  }

  Future<void> createTask(String title, String listId) async {
  final token = storage.read('token');
  final res = await _dio.post(
    '/tasks',
    data: {'title': title, 'list': listId},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  await fetchTasks(listId); // refresh the list
}

Future<void> createList(String title) async {
  final token = storage.read('token');
  final res = await _dio.post(
    '/lists',
    data: {'title': title, 'board': boardId},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  await fetchLists(); // refresh lists + tasks
}

Future<void> moveTask(String taskId, String newListId) async {
  final token = storage.read('token');
  await _dio.put(
    '/tasks/$taskId',
    data: {'list': newListId},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
}

Future<List<dynamic>> fetchComments(String taskId) async {
  final token = storage.read('token');
  final res = await _dio.get('/comments/$taskId', options: Options(
    headers: {'Authorization': 'Bearer $token'}
  ));
  return res.data;
}

Future<void> addComment(String taskId, String content) async {
  final token = storage.read('token');
  await _dio.post('/comments', data: {
    'task': taskId,
    'content': content
  }, options: Options(headers: {'Authorization': 'Bearer $token'}));
}


}
