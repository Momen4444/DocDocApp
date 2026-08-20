import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';

class ApiService {
  // You shall change pc IP depending on yours for the connection
  static const bool _physicalDevice = true;
  static const String _pcLanIp = '';

  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      const host =
          _physicalDevice ? _pcLanIp : '10.0.2.2'; // return to emulator
      return 'http://$host:5099/api';
    }
    return 'http://localhost:5099/api';
  }

  // Auth
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse('$baseUrl/Auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Username': email,
          'Password': password,
          'Email': email,
          'MobileNumber': phone,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful'
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed'
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Network error occurred. Please try again.'
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    final url = Uri.parse('$baseUrl/Auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Username': email, 'Password': password}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        final token = data['token'] as String;

        // Decode JWT payload — read-only, no crypto. Backend validates the signature.
        final payload = _decodeJwtPayload(token);
        final role = _claim(payload, const [
              'role',
              'http://schemas.microsoft.com/ws/2008/06/identity/claims/role',
            ]) ??
            'User';
        final userIdStr = _claim(payload, const [
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata',
          'userdata',
        ]);
        final userId = int.tryParse(userIdStr ?? '') ?? 0;

        await LocalStorageService.saveSession(
          token: token,
          role: role,
          userId: userId,
          rememberMe: rememberMe,
        );
        return {'success': true, 'message': 'Login successful'};
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Invalid email or password'
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Network error occurred. Please try again.'
      };
    }
  }

  static Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      final normalized = base64Url.normalize(parts[1]);
      return jsonDecode(utf8.decode(base64Url.decode(normalized)))
          as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static String? _claim(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final v = payload[key];
      if (v != null) return v.toString();
    }
    return null;
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await LocalStorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static String _message(String body, String fallback) {
    try {
      final d = jsonDecode(body);
      return (d is Map && d['message'] != null)
          ? d['message'].toString()
          : fallback;
    } catch (_) {
      return fallback;
    }
  }

  // ── Users ─────────────────────────────────────────────────────

  /// GET /api/Users
  static Future<Map<String, dynamic>> getUsers() async {
    final url = Uri.parse('$baseUrl/Users');
    try {
      final response = await http
          .get(url, headers: await _authHeaders())
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body) as List<dynamic>
        };
      }
      return {'success': false, 'message': 'Failed to load users.'};
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// GET /api/Users/search?name=query
  static Future<Map<String, dynamic>> searchUsers(String query) async {
    final url = Uri.parse('$baseUrl/Users/search')
        .replace(queryParameters: {'name': query, 'pageSize': '50'});
    try {
      final response = await http
          .get(url, headers: await _authHeaders())
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body) as List<dynamic>
        };
      }
      if (response.statusCode == 404) {
        return {'success': true, 'data': <dynamic>[]};
      }
      return {'success': false, 'message': 'Search failed.'};
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// GET /api/Users/search?id={id} — single user by profile ID.
  static Future<Map<String, dynamic>> getUserById(int id) async {
    final url = Uri.parse('$baseUrl/Users/search')
        .replace(queryParameters: {'id': '$id'});
    try {
      final response = await http
          .get(url, headers: await _authHeaders())
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        if (list.isNotEmpty) return {'success': true, 'data': list.first};
      }
      return {'success': false, 'message': 'User not found.'};
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// PUT /api/Users/{id} — admin or own profile.
  static Future<Map<String, dynamic>> updateUser(
      int id, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/Users/$id');
    try {
      final response = await http
          .put(url, headers: await _authHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      }
      return {
        'success': false,
        'message': _message(response.body, 'Failed to update.')
      };
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// DELETE /api/Users/{id} — admin only.
  static Future<Map<String, dynamic>> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/Users/$id');
    try {
      final response = await http
          .delete(url, headers: await _authHeaders())
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) return {'success': true};
      return {
        'success': false,
        'message': _message(response.body, 'Failed to delete.')
      };
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// POST /api/Users — admin only.
  static Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/Users');
    try {
      final response = await http
          .post(url, headers: await _authHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      }
      return {
        'success': false,
        'message': _message(response.body, 'Failed to create user.')
      };
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  /// Builds the full URL for a user's profile image served by ASP.NET static files.
  static String buildImageUrl(String? profileImagePath) {
    if (profileImagePath == null || profileImagePath.isEmpty) return '';
    final base = (!kIsWeb && Platform.isAndroid)
        ? 'http://10.0.2.2:5099'
        : 'http://localhost:5099';
    return '$base/images/users/$profileImagePath';
  }
}
