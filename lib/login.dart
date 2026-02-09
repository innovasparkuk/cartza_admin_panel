import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'signup.dart';
import 'terms.dart';
import 'userdashboard.dart';
import 'forgetpassword.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _acceptTerms = false;
  bool _showPassword = false;

  static const String LOGIN_API = 'http://localhost:3000/login';
  // Android Emulator: http://10.0.2.2:3000/login

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFFFF6F00)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
      ),
    );
  }

  Future<void> _loginRequest() async {
    final response = await http.post(
      Uri.parse(LOGIN_API),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Login failed");
    }
  }

  void _loginUser() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept Terms & Conditions"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logging in..."),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        await _loginRequest();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserDashboard()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid email or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: Colors.white,
        elevation: 1.5,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/download.png", height: 22),
              const SizedBox(width: 14),
              const Text(
                "Continue with Google",
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _facebookButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const FaIcon(FontAwesomeIcons.facebookF,
            color: Colors.white, size: 18),
        label: const Text(
          "Continue with Facebook",
          style: TextStyle(
              fontSize: 15.5,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1877F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text("Welcome Back",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text("Login to continue",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration(
                            hint: "Email Address",
                            icon: Icons.email_outlined),
                        validator: (v) =>
                        v == null || !v.contains('@')
                            ? "Invalid email"
                            : null,
                      ),
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: _inputDecoration(
                          hint: "Password",
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(
                                    () => _showPassword = !_showPassword),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor:
                            const Color(0xFFFF6F00),
                            onChanged: (v) =>
                                setState(() => _acceptTerms = v!),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                const Text("I agree to the "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TermsConditionsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                      color:
                                      Color(0xFFFF6F00),
                                      fontWeight:
                                      FontWeight.w600,
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("LOGIN",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 22),

                      _googleButton(),
                      const SizedBox(height: 14),
                      _facebookButton(),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignupPage()),
                              );
                            },
                            child: const Text(
                              "Create Account",
                              style:
                              TextStyle(color: Color(0xFF4CAF50)),
                            ),
                          ),
                          const Text(" | "),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ForgotPasswordPage()),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style:
                              TextStyle(color: Color(0xFF4CAF50)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
