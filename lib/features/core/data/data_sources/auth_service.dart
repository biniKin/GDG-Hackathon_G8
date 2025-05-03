
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safe_campus/features/core/data/models/register_data.dart';
import 'package:safe_campus/features/core/data/models/user_model.dart';

class AuthService {
  //register
  Future<UserModel> register(RegisterData data) async {
    final url = 'https://safe-campus-backend.onrender.com/api/auth/register';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": data.fullname,
          "email": data.email,
          "password": data.password,
          "studentId": data.studentId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return UserModel.fromJson(json);
        } else {
          print('Failed to register: ${response.body}');
           throw Exception('Failed to register: ${response.body}');
        }
      } else {
        print('Failed to register: ${response.body}');
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      print('Register error: $e');
      throw Exception('Register error: $e');
    }
  }

  //login
  Future<UserModel> login(String email, String password) async {
    final url = 'https://safe-campus-backend.onrender.com/api/auth/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        return UserModel.fromJson(res);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}
