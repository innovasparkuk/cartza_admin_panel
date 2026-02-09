import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions",style:TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF6F00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            "Terms & Conditions\n\n"
                "• This application is for authorized users only.\n"
                "• User data must not be misused.\n"
                "• Electronic services are provided as-is.\n"
                "• Unauthorized access is prohibited.\n"
                "• The company reserves the right to update terms.\n\n"
                "By using this app, you agree to comply with all terms.",
            style: const TextStyle(fontSize: 15.5),
          ),
        ),
      ),
    );
  }
}
