import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// User Registration with role included
  Future<void> _registerUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final url = Uri.parse("http://localhost:5000/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": "user" // role explicitly added here
        }),
      );

      if (response.statusCode == 201) { // use 201 according to backend
        print("User Registered: $email");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Registration failed")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 800)
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Welcome to NextEvent!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("Create your account to get started", style: TextStyle(fontSize: 16)),
                          SizedBox(height: 24),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildInputField(_nameController, "First Name", Icons.person),
                                SizedBox(height: 12),
                                buildInputField(_nameController, "Middle Name", Icons.person),
                                SizedBox(height: 12),
                                buildInputField(_nameController, "Last Name", Icons.person),
                                SizedBox(height: 12),
                                buildInputField(_emailController, "Email", Icons.email),
                                SizedBox(height: 12),
                                buildInputField(_passwordController, "Password", Icons.lock, obscureText: true),
                                SizedBox(height: 12),
                                buildInputField(_confirmPasswordController, "Confirm Password", Icons.lock, obscureText: true),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _registerUser();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text("Create Account", style: TextStyle(fontSize: 16, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("or continue with")), Expanded(child: Divider())]),
                          SizedBox(height: 16),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [socialButton(FontAwesomeIcons.google, "Google", Colors.red), SizedBox(width: 16), socialButton(FontAwesomeIcons.apple, "Apple", Colors.black)]),
                          SizedBox(height: 24),
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())),
                              child: Text.rich(
                                TextSpan(text: "Already have an account? ", children: [TextSpan(text: "Log in", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      validator: (value) {
        if (value == null || value.isEmpty) return "$label is required";
        if (label == "Password" && value.length < 6) return "Password must be at least 6 characters";
        if (label == "Confirm Password" && value != _passwordController.text) return "Passwords do not match";
        return null;
      },
    );
  }

  Widget socialButton(IconData icon, String label, Color color) => OutlinedButton.icon(onPressed: () {}, icon: FaIcon(icon, color: color), label: Text(label), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), minimumSize: Size(150, 50)));
}