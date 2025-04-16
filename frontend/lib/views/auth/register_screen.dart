import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/auth_controller.dart';
import '../../widgets/custom_textfield.dart';


class RegisterScreen extends StatelessWidget {
  final AuthController auth = Get.put(AuthController());
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                CustomTextField(hintText: 'Full Name', controller: name),
                SizedBox(height: 16),
                CustomTextField(hintText: 'Email', controller: email),
                SizedBox(height: 16),
                CustomTextField(hintText: 'Password', controller: password, obscureText: true),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => auth.register(name.text, email.text, password.text),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Register"),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
