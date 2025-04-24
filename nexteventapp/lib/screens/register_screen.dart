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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _selectedRole = 'attendee'; // Default role

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse("http://localhost:5000/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": _firstNameController.text.trim(),
          "last_name": _lastNameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "user_type": _selectedRole
        }),
      );

      print("🔹 Register Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Registration successful!")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "❌ Registration failed")),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error. Please try again.")),
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
                    child: const Center(
                      child: Text(
                        "Welcome to NextEvent!",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Create your account to get started", style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildInputField(_firstNameController, "First Name", Icons.person),
                              const SizedBox(height: 12),
                              buildInputField(_lastNameController, "Last Name", Icons.person_outline),
                              const SizedBox(height: 12),
                              buildInputField(_emailController, "Email", Icons.email),
                              const SizedBox(height: 12),
                              buildInputField(_passwordController, "Password", Icons.lock, obscureText: true),
                              const SizedBox(height: 12),
                              buildInputField(_confirmPasswordController, "Confirm Password", Icons.lock_outline, obscureText: true),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: _selectedRole,
                                onChanged: (val) => setState(() => _selectedRole = val!),
                                items: const [
                                  DropdownMenuItem(value: "attendee", child: Text("Attendee")),
                                  DropdownMenuItem(value: "organizer", child: Text("Organizer")),
                                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                                ],
                                decoration: const InputDecoration(
                                  labelText: "Role",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _registerUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("or continue with"),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialButton(FontAwesomeIcons.google, "Google", Colors.red),
                            const SizedBox(width: 16),
                            socialButton(FontAwesomeIcons.apple, "Apple", Colors.black),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              children: [
                                TextSpan(
                                  text: "Log in",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "$label is required";
        if (label == "Password" && value.length < 6) return "Password must be at least 6 characters";
        if (label == "Confirm Password" && value != _passwordController.text) return "Passwords do not match";
        return null;
      },
    );
  }

  Widget socialButton(IconData icon, String label, Color color) {
    return OutlinedButton.icon(
      onPressed: () {
        print("Sign in with $label");
      },
      icon: FaIcon(icon, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(150, 50),
      ),
    );
  }
}
