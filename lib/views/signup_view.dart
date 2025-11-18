import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'UpdateDetailsScreen.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedType = 'READING_ROOM';

  Future<void> signup() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (!_formKey.currentState!.validate()) return;

    try {
      final url = Uri.parse("http://10.226.84.50:8080/user/signup");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "password": password,
          "type": selectedType
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UpdateDetailsScreen(
              phone: phone,  // pass phone number
              selectedType: selectedType,  // pass selected type
            ),
          ),
        );

      } else {
        print("❌ Signup failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) =>
                      v!.isEmpty ? "Please enter your name" : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (v) =>
                      v!.isEmpty ? "Please enter phone number" : null,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (v) =>
                      v!.isEmpty ? "Please enter password" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: "Account Type",
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "READING_ROOM", child: Text("Reading Room")),
                        DropdownMenuItem(value: "HOSTEL", child: Text("Hostel")),
                        DropdownMenuItem(value: "MESS", child: Text("Mess")),
                        DropdownMenuItem(
                            value: "LIBRARY", child: Text("Library")),
                      ],
                      onChanged: (value) {
                        setState(() => selectedType = value!);
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
