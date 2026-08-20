import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';

class ApiService {
  // You shall change pc IP depening on yours for the connection
  static const bool _physicalDevice = true;
  static const String _pcLanIp = '';

  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      const host = _physicalDevice ? _pcLanIp : '10.0.2.2'; // return to emulator
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
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
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
        body: jsonEncode({
          'Username': email,
          'Password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await LocalStorageService.saveToken(data['token'],
            rememberMe: rememberMe);

        return {'success': true, 'message': 'Login successful'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Invalid email or password'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred. Please try again.'
      };
    }
  }

  // Users
  static Future<Map<String, String>> _authHeaders() async {
    final token = await LocalStorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

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

  // GET /api/Users/search?name=query
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
      // 404 means no users matched — treat as empty, not an error.
      if (response.statusCode == 404) {
        return {'success': true, 'data': <dynamic>[]};
      }
      return {'success': false, 'message': 'Search failed.'};
    } catch (_) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Image path for avatar
  static String buildImageUrl(String? profileImagePath) {
    if (profileImagePath == null || profileImagePath.isEmpty) return '';
    final base = (!kIsWeb && Platform.isAndroid)
        ? 'http://10.0.2.2:5099'
        : 'http://localhost:5099';
    return '$base/images/users/$profileImagePath';
  }
}
