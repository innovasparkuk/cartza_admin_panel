import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TestApiScreen extends StatefulWidget {
  @override
  State<TestApiScreen> createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  String result = "No request yet";

  void testApi() async {
    final response = await ApiService.testConnection();

    setState(() {
      result = response.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testApi,
              child: Text("Test Backend"),
            ),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
