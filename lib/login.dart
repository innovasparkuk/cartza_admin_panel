import 'package:flutter/material.dart';
import 'package:untitled6/forgetpassword.dart';
import 'package:untitled6/main.dart';
import 'package:untitled6/signup.dart';
import 'package:untitled6/userdashboard.dart';

class login extends StatefulWidget {
  State<login> createState() => _login();
}

class _login extends State<login> {
  var email = TextEditingController();
  var password = TextEditingController();

  // Dummy credentials
  final String adminEmail = "admin@gmail.com";
  final String adminPassword = "admin123";

  final String userEmail = "user@gmail.com";
  final String userPassword = "user123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 350,
              width: 500,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFFFF6F00),
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: email,
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontFamily: 'Roboto',
                      ),
                      cursorColor: Color(0xFF4CAF50),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFFFF6F00),
                        ),
                        hintText: "Enter your Email",
                        hintStyle: const TextStyle(
                          color: Color(0xFF212121),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6F00),
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: password,
                      obscureText: true,
                      obscuringCharacter: "*",
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontFamily: 'Roboto',
                      ),
                      cursorColor: Color(0xFF4CAF50),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFFF6F00),
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Color(0xFF212121),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6F00),
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      String enteredEmail = email.text.trim();
                      String enteredPassword = password.text.trim();

                      if (enteredEmail == adminEmail &&
                          enteredPassword == adminPassword) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()),
                        );
                      } else if (enteredEmail == userEmail &&
                          enteredPassword == userPassword) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserDashboard()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Email not registered"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: const Text(
                          "Not Registered? Sign up",
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Forget Password ?",
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
