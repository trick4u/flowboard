import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

class FlowBoardApp extends StatelessWidget {
  const FlowBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FlowBoard',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes().routes,
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
