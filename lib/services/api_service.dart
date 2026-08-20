import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';

class ApiService {
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:5099/api';
    }
    return 'http://localhost:5099/api';
  }

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
        await LocalStorageService.saveToken(data['token'], rememberMe: rememberMe);

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
}
