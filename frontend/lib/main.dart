import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';

void main() async {
  await GetStorage.init();
  runApp(const FlowBoardApp());
}
