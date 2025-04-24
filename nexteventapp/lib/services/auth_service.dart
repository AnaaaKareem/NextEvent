import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Auth0 auth0 = Auth0('YOUR_AUTH0_DOMAIN', 'YOUR_AUTH0_CLIENT_ID');
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> login() async {
    try {
      final credentials = await auth0.webAuthentication().login();
      await storage.write(key: "access_token", value: credentials.accessToken);
      return credentials.idToken; // Return the ID Token for authentication
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await auth0.webAuthentication().logout();
    await storage.delete(key: "access_token");
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: "access_token");
  }
}
