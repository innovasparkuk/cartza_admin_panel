import 'package:flutter/material.dart';
// import 'forgetpassword.dart';
// import 'signup.dart';
// import 'userdashboard.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  final String adminEmail = "admin@gmail.com";
  final String adminPassword = "admin123";

  final String userEmail = "user@gmail.com";
  final String userPassword = "user123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 350,
          width: 500,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _inputField(
                controller: email,
                hint: "Email",
                icon: Icons.email_outlined,
              ),
              _inputField(
                controller: password,
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const SignupPage(),
                      //   ),
                      // );
                    },
                    child: const Text("Sign up"),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const ForgotPasswordPage(),
                      //   ),
                      // );
                    },
                    child: const Text("Forgot password"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _login() {
    final e = email.text.trim();
    final p = password.text.trim();

    if (e == adminEmail && p == adminPassword) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const MyHomePage()),
      // );
    } else if (e == userEmail && p == userPassword) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const UserDashboard()),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials")),
      );
    }
  }
}
