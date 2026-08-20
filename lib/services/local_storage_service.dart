import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static const _storage = FlutterSecureStorage();

  // In-memory cache
  static String? _sessionToken;
  static String? _sessionRole;
  static int? _sessionUserId;

  // Storage keys
  static const _tokenKey = 'jwt_token';
  static const _roleKey = 'user_role';
  static const _userIdKey = 'user_id';

  // Session save (token + role + userId together)
  static Future<void> saveSession({
    required String token,
    required String role,
    required int userId,
    bool rememberMe = true,
  }) async {
    _sessionToken = token;
    _sessionRole = role;
    _sessionUserId = userId;
    if (rememberMe) {
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _roleKey, value: role);
      await _storage.write(key: _userIdKey, value: userId.toString());
    }
  }

  // Getters
  static Future<String?> getToken() async {
    _sessionToken ??= await _storage.read(key: _tokenKey);
    return _sessionToken;
  }

  static Future<String?> getRole() async {
    _sessionRole ??= await _storage.read(key: _roleKey);
    return _sessionRole;
  }

  static Future<int?> getUserId() async {
    if (_sessionUserId != null) return _sessionUserId;
    final raw = await _storage.read(key: _userIdKey);
    _sessionUserId = raw != null ? int.tryParse(raw) : null;
    return _sessionUserId;
  }

  // Logout
  static Future<void> clearSession() async {
    _sessionToken = null;
    _sessionRole = null;
    _sessionUserId = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _userIdKey);
  }

  static Future<void> deleteToken() => clearSession();
}
