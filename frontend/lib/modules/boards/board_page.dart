import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'board_controller.dart';

class BoardPage extends GetView<BoardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Boards')),
      body: Obx(() {
        if (controller.boards.isEmpty) {
          return const Center(child: Text('No boards yet'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.boards.length,
          itemBuilder: (context, index) {
            final board = controller.boards[index];
            return ListTile(
              title: Text(board['title']),
              subtitle: Text("ID: ${board['_id']}"),
              onTap: () {
                Get.toNamed('/board/${board['_id']}');
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBoardSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Create Board'),
        backgroundColor: const Color(0xff5aac44), // Trello green
      ),
    );
  }

  void _showCreateBoardSheet(BuildContext context) {
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
                'Create New Board',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Board title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_controller.text.trim().isNotEmpty) {
                    await controller.createBoard(_controller.text.trim());
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5aac44),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
