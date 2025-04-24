import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'admin_dashboard.dart';
import 'organizer_dashboard.dart';
import 'user_dashboard.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId") ?? 0;
    final firstName = prefs.getString("firstName") ?? "";
    final lastName = prefs.getString("lastName") ?? "";
    final email = prefs.getString("email") ?? "";
    final userType = prefs.getString("user_type") ?? "";
    final token = prefs.getString("token") ?? "";

    if (userId != 0 && token.isNotEmpty) {
      setState(() {
        _user = User(
          id: userId,
          firstName: firstName,
          middleName: '',
          lastName: lastName,
          email: email,
          password: '',
          phoneNumber: '',
          userType: userType,
          token: token,
        );
      });
    }

    // Stop loading after checking
    setState(() => _isLoading = false);
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Management System"),
        actions: [
          if (_user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
        ],
      ),
      body: Center(
        child: _user == null
            ? _buildWelcomeScreen(context)
            : _navigateToDashboard(_user!),
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Welcome to EMS!", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text("Login"),
        ),
      ],
    );
  }

  Widget _navigateToDashboard(User user) {
    switch (user.userType) {
      case "admin":
        return AdminDashboard(user: user);
      case "organizer":
        return OrganizerDashboard(user: user);
      default:
        return UserDashboard(user: user);
    }
  }
}
