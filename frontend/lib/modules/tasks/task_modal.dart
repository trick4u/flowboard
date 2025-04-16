import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../boards/board_detail_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class TaskModal extends StatefulWidget {
  final Map task;
  final String listId;
  final String boardId;

  const TaskModal({
    super.key,
    required this.task,
    required this.listId,
    required this.boardId,
  });

  @override
  State<TaskModal> createState() => _TaskModalState();
}

class _TaskModalState extends State<TaskModal> {
  final TextEditingController commentController = TextEditingController();
  final controller = Get.find<BoardDetailController>();
  final Dio dio = Dio();
  List<dynamic> members = [];
  String? selectedAssignee;

  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    fetchBoardMembers();
    selectedAssignee = widget.task['assignedTo'];
    fetchAndSetComments();
  }

  Future<void> fetchAndSetComments() async {
    final data = await controller.fetchComments(widget.task['_id']);
    setState(() {
      comments = data;
    });
  }

  Future<void> handleAddComment() async {
    if (commentController.text.trim().isEmpty) return;

    await controller.addComment(
      widget.task['_id'],
      commentController.text.trim(),
    );
    commentController.clear();
    await fetchAndSetComments(); // refresh
  }

  Future<void> fetchBoardMembers() async {
    try {
      final token = controller.storage.read('token');

      final res = await dio.get(
        'http://localhost:5001/api/boards/${widget.boardId}/members',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        members = res.data;
      });
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  Future<void> assignUser(String userId) async {
    try {
      final token = controller.storage.read('token');
      await dio.post(
        'http://localhost:5001/api/tasks/assign',
        data: {'taskId': widget.task['_id'], 'assigneeId': userId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        selectedAssignee = userId;
      });
    } catch (e) {
      print('Error assigning user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[100],
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.task['description'] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              const Divider(),

              const Text(
                'Assign to',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedAssignee,
                items:
                    members.map<DropdownMenuItem<String>>((user) {
                      return DropdownMenuItem(
                        value: user['_id'],
                        child: Text(user['name']),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) assignUser(val);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 24),
              const Text(
                'Add a comment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: handleAddComment,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5aac44),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Activity log (coming soon)',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...comments.map(
                (comment) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['user']['name'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(comment['content']),
                      const SizedBox(height: 4),
                      Text(
                        DateTime.parse(
                          comment['createdAt'],
                        ).toLocal().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
