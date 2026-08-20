import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static const _storage = FlutterSecureStorage();
  static String? _sessionToken;

  static Future<void> saveToken(String token, {bool rememberMe = true}) async {
    _sessionToken = token;
    if (rememberMe) {
      await _storage.write(key: 'jwt_token', value: token);
    }
  }

  /// Retrieves the current token. First checks the active session memory,
  /// then checks persistent storage.
  static Future<String?> getToken() async {
    if (_sessionToken != null) {
      return _sessionToken;
    }

    // Fallback to checking the hard drive if "Remember me" was used previously
    _sessionToken = await _storage.read(key: 'jwt_token');
    return _sessionToken;
  }

  /// Deletes the token from both the active session and persistent storage.
  static Future<void> deleteToken() async {
    _sessionToken = null;
    await _storage.delete(key: 'jwt_token');
  }
}
