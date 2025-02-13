import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_provider.dart';

class Connection {
  static String serverAddr = "192.168.158.78:5000";

  static Future<bool> login(String email, String password, AppProvider appProvider) async {
    final url = Uri.parse('http://' + serverAddr + '/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);
      appProvider.setName(data['name']);
      appProvider.setSurname(data['surname']);
      appProvider.setEmail(data['email']);
      appProvider.setStudent(data['student'] == 1);
      appProvider.setProfessor(data['professor'] == 1);
      appProvider.setLeader(data['leader'] == 1);
      appProvider.setAdmin(data['admin'] == 1);

      return true;
    } else {
      return false;
    }
  }

  static Future<List> getUsers(AppProvider appProvider) async {
    final url = Uri.parse('http://' + serverAddr + '/get-users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      List users = data['users'];
      appProvider.setToken(data['token']);
      print(users);
      return users;
    } else {
      return [];
    }
  }

  static Future<bool> addUser({
    required String email,
    required String token,
    required String new_email,
    required String new_name,
    required String new_surname,
    required bool new_admin,
    required bool new_leader,
    required bool new_professor,
    required bool new_student,
    required AppProvider appProvider
  }) async {
    final url = Uri.parse('http://' + serverAddr + '/add-user');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'token': token,
        'new_name': new_name,
        'new_surname': new_surname,
        'new_email': new_email,
        'new_admin': new_admin,
        'new_leader': new_leader,
        'new_professor': new_professor,
        'new_student': new_student,
      }),
    );

    final data = jsonDecode(response.body);
    appProvider.setLogged(true);
    appProvider.setToken(data['token']);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List> getUser(int user_id, AppProvider appProvider) async {
    final url = Uri.parse('http://' + serverAddr + '/get-user');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'user_id': user_id}),
    );

    final data = jsonDecode(response.body);
    appProvider.setLogged(true);
    appProvider.setToken(data['token']);

    if (response.statusCode == 200) {
      List user = data['user'];
      print(user);
      return user;
    } else {
      return [];
    }
  }

  static Future<bool> updateUser(
    AppProvider appProvider,
    {
      required int user_id,
      required String new_name,
      required String new_surname,
      required bool new_admin,
      required bool new_leader,
      required bool new_professor,
      required bool new_student,
    }
      ) async {
    final url = Uri.parse('http://' + serverAddr + '/update-user');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'email': appProvider.email,
            'token': appProvider.token,
            'user_id': user_id,
            'new_name': new_name,
            'new_surname': new_surname,
            'new_admin': new_admin,
            'new_leader': new_leader,
            'new_professor': new_professor,
            'new_student': new_student
          }
      ),
    );

    final data = jsonDecode(response.body);
    appProvider.setLogged(true);
    appProvider.setToken(data['token']);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> resetPassword(int user_id, AppProvider appProvider) async {
    final url = Uri.parse('http://' + serverAddr + '/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'user_id': user_id}),
    );

    final data = jsonDecode(response.body);
    appProvider.setLogged(true);
    appProvider.setToken(data['token']);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteUser(int user_id, AppProvider appProvider) async {
    final url = Uri.parse('http://' + serverAddr + '/delete-user');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'user_id': user_id}),
    );

    final data = jsonDecode(response.body);
    appProvider.setLogged(true);
    appProvider.setToken(data['token']);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}