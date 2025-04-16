import 'package:get/get.dart';

import '../modules/auth_binding.dart';
import '../modules/boards/board_binding.dart';
import '../modules/boards/board_page.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';


class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const board = '/board';

 final routes = [
  GetPage(name: '/login', page: () => LoginScreen()),
  GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: board, page: () => BoardPage(), binding: BoardBinding()),
];
}
