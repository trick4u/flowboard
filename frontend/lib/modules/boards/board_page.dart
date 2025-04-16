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
          itemCount: controller.boards.length,
          itemBuilder: (context, index) {
            final board = controller.boards[index];
            return ListTile(
              title: Text(board['title']),
              subtitle: Text("ID: ${board['_id']}"),
              onTap: () {
                // Navigate to list/tasks view later
              },
            );
          },
        );
      }),
    );
  }
}
