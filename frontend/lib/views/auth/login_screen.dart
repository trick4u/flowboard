import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/auth_controller.dart';
import '../../widgets/custom_textfield.dart';


class LoginScreen extends StatelessWidget {
  final AuthController auth = Get.put(AuthController());
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("FlowBoard", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 32),
                CustomTextField(hintText: 'Email', controller: email),
                SizedBox(height: 16),
                CustomTextField(hintText: 'Password', controller: password, obscureText: true),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => auth.login(email.text, password.text),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.toNamed('/register'),
                  child: Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
