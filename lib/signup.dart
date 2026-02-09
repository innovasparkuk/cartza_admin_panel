import 'dart:convert';
import 'package:cartza_login/terms.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _rememberMe = false;
  bool _acceptTerms = false;

  // 🔗 Local Express API
  static const String SIGNUP_API ='http://localhost:3000/signup';
     // "http://10.0.2.2:3000/signup"; // Android Emulator
  // Use http://localhost:3000/signup for web
  // Use your PC IP for real device

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  Future<void> _signupRequest() async {
    final response = await http.post(
      Uri.parse(SIGNUP_API),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Signup failed");
    }
  }

  void _signup() async {
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
            content: Text("Creating Account..."),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        await _signupRequest();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => login()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup failed. Email may already exist."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                      const Text("Create Account",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text("Join us and start your journey",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                            hint: "Full Name",
                            icon: Icons.person_outline),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Name required" : null,
                      ),
                      const SizedBox(height: 18),

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
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_showConfirmPassword,
                        decoration: _inputDecoration(
                          hint: "Confirm Password",
                          icon: Icons.lock_reset,
                          suffix: IconButton(
                            icon: Icon(_showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() =>
                            _showConfirmPassword =
                            !_showConfirmPassword),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Remember me"),
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v!),
                        controlAffinity:
                        ListTileControlAffinity.leading,
                      ),

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
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFFF6F00),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("SIGN UP",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
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
