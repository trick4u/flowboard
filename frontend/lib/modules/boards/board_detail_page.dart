import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../tasks/task_modal.dart';
import 'board_detail_controller.dart';

class BoardDetailPage extends StatelessWidget {
  final controller = Get.put(BoardDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7), // Trello background
      appBar: AppBar(
        title: const Text('Board'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.lists.isEmpty) {
          return Center(
            child: Text(
              'This board has no lists yet.\nClick the green + button to add one!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.lists.length,
          itemBuilder: (context, index) {
            var list = controller.lists[index];
            var title = list['title'];
            var listId = list['_id'];

            return Card(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => TaskModal(
                              task: list, // ✅ Proper Map passed
                              listId: listId,
                                boardId: controller.boardId ?? '',
                            ),
                      );
                    },
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddListSheet(context),
        label: const Text('Add List'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xff5aac44),
      ),
    );
  }

  void _showAddListSheet(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a new list',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'List title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    await controller.createList(_controller.text.trim());
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Add List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5aac44), // Trello green
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddCardBottomSheet(BuildContext context, String listId) {
    final TextEditingController _controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a new card',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Card title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    await controller.createTask(
                      _controller.text.trim(),
                      listId,
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Add Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5aac44), // Trello green
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
