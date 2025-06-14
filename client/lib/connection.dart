import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_provider.dart';

class Connection {
  //static String serverAddr = "http://192.168.90.78:5000"; //hotspot
  //static String serverAddr = "http://192.168.178.32:5000"; //wi-fi casa
  static String serverAddr = "https://bbruno.pythonanywhere.com";

  static Future<bool> login(String email, String password, AppProvider appProvider) async {
    final url = Uri.parse(serverAddr + '/login');
    try {
      print('sto eseguendo il login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('ecco la risposta');
      print(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        appProvider.setName(data['name']);
        appProvider.setSurname(data['surname']);
        appProvider.setEmail(data['email']);
        appProvider.setRoles(data["roles"]);
        appProvider.loadPreferences();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Errore: $e');
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> reload(AppProvider appProvider) async {
    final url = Uri.parse(serverAddr + '/reload');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);
      appProvider.setName(data['name']);
      appProvider.setSurname(data['surname']);
      appProvider.setEmail(data['email']);
      appProvider.setRoles(data["roles"]);
      appProvider.loadPreferences();
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateOwnUser(AppProvider appProvider, {
    required String new_name,
    required String new_surname,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-own-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'new_name': new_name,
          'new_surname': new_surname,
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
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> changePassword(AppProvider appProvider, {required String current_password, required String new_password}) async {
    try {
      final url = Uri.parse(serverAddr + '/change-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'password': current_password,
          'new_password': new_password,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getRoleList(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-role-list');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List users = data['roles'];
        print(users);
        return users;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<List> getRoles(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-roles');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List roles = data['roles'];
        print("roles");
        print(roles);
        return roles;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> addRole({
    required String email,
    required String token,
    required String name,
    required bool view_users,
    required bool edit_users,
    required bool create_users,
    required bool delete_users,
    required bool view_own_user,
    required bool edit_own_user,
    required bool create_own_user,
    required bool delete_own_user,
    required bool view_roles,
    required bool edit_roles,
    required bool create_roles,
    required bool delete_roles,
    required bool view_availability,
    required bool edit_availability,
    required bool create_availability,
    required bool delete_availability,
    required bool view_resources,
    required bool edit_resources,
    required bool create_resources,
    required bool delete_resources,
    required bool view_booking,
    required bool edit_booking,
    required bool create_booking,
    required bool delete_booking,
    required bool view_own_booking,
    required bool edit_own_booking,
    required bool create_own_booking,
    required bool delete_own_booking,
    required String description,
    required AppProvider appProvider
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-role');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'name': name,
          'view_users': view_users,
          'edit_users': edit_users,
          'create_users': create_users,
          'delete_users': delete_users,
          'view_own_user': view_own_user,
          'edit_own_user': edit_own_user,
          'create_own_user': create_own_user,
          'delete_own_user': delete_own_user,
          'view_roles': view_roles,
          'edit_roles': edit_roles,
          'create_roles': create_roles,
          'delete_roles': delete_roles,
          'view_availability': view_availability,
          'edit_availability': edit_availability,
          'create_availability': create_availability,
          'delete_availability': delete_availability,
          'view_resources': view_resources,
          'edit_resources': edit_resources,
          'create_resources': create_resources,
          'delete_resources': delete_resources,
          'view_booking': view_booking,
          'edit_booking': edit_booking,
          'create_booking': create_booking,
          'delete_booking': delete_booking,
          'view_own_booking': view_own_booking,
          'edit_own_booking': edit_own_booking,
          'create_own_booking': create_own_booking,
          'delete_own_booking': delete_own_booking,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getRole(var role_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-role');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'role_id': role_id
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        List role = data['role'];
        print(role);
        return role;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> updateRole(AppProvider appProvider, {
    required int role_id,
    required String name,
    required String description,
    required bool view_users,
    required bool edit_users,
    required bool create_users,
    required bool delete_users,
    required bool view_own_user,
    required bool edit_own_user,
    required bool create_own_user,
    required bool delete_own_user,
    required bool view_roles,
    required bool edit_roles,
    required bool create_roles,
    required bool delete_roles,
    required bool view_availability,
    required bool edit_availability,
    required bool create_availability,
    required bool delete_availability,
    required bool view_resources,
    required bool edit_resources,
    required bool create_resources,
    required bool delete_resources,
    required bool view_booking,
    required bool edit_booking,
    required bool create_booking,
    required bool delete_booking,
    required bool view_own_booking,
    required bool edit_own_booking,
    required bool create_own_booking,
    required bool delete_own_booking,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-role');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'role_id': role_id,
          'name': name,
          'description': description,
          'view_users': view_users,
          'edit_users': edit_users,
          'create_users': create_users,
          'delete_users': delete_users,
          'view_own_user': view_own_user,
          'edit_own_user': edit_own_user,
          'create_own_user': create_own_user,
          'delete_own_user': delete_own_user,
          'view_roles': view_roles,
          'edit_roles': edit_roles,
          'create_roles': create_roles,
          'delete_roles': delete_roles,
          'view_availability': view_availability,
          'edit_availability': edit_availability,
          'create_availability': create_availability,
          'delete_availability': delete_availability,
          'view_resources': view_resources,
          'edit_resources': edit_resources,
          'create_resources': create_resources,
          'delete_resources': delete_resources,
          'view_booking': view_booking,
          'edit_booking': edit_booking,
          'create_booking': create_booking,
          'delete_booking': delete_booking,
          'view_own_booking': view_own_booking,
          'edit_own_booking': edit_own_booking,
          'create_own_booking': create_own_booking,
          'delete_own_booking': delete_own_booking,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> deleteRole(int role_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-role');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'role_id': role_id
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }


  // - - -   USERS - - -

  static Future<List> getUsers(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-users');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List users = data['users'];
        print(users);
        return users;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> addUser({
    required String new_email,
    required String new_name,
    required String new_surname,
    required List<String> new_roles,
    required AppProvider appProvider,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'new_name': new_name,
          'new_surname': new_surname,
          'new_email': new_email,
          'new_roles': new_roles,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<int> addUsers({
    required List users,
    required AppProvider appProvider,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-users');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'users': users,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200 ? data['fail_count'] : -1;
    } catch (e) {
      appProvider.setNoConnection(true);
      return -1;
    }
  }

  static Future<List> getUser(int user_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'user_id': user_id,
        }),
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
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> updateUser(AppProvider appProvider, {
    required int user_id,
    required String new_name,
    required String new_surname,
    required List<String> roles,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'user_id': user_id,
          'new_name': new_name,
          'new_surname': new_surname,
          'new_roles': roles,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> resetPassword(int user_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/reset-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'user_id': user_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> disconnectUsers(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/disconnect-users');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> deleteUser(int user_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'user_id': user_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  // - - -   TYPES - - -

  static Future<List> getTypes(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-types');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List types = data['types'];
        print(types);
        return types;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> addType({
    required String name,
    required String description,
    required AppProvider appProvider,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-type');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'name': name,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> updateType(AppProvider appProvider, {
    required int type_id,
    required String name,
    required String description,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-type');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'type_id': type_id,
          'name': name,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getType(int type_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-type');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'type_id': type_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        List type = data['type'];
        print(type);
        return type;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> deleteType(int type_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-type');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'type_id': type_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getTypeList(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-type-list');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List types = data['types'];
        print(types);
        return types;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  // - - -   PLACES - - -

  static Future<List> getPlaces(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-places');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List places = data['places'];
        print(places);
        return places;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> addPlace({
    required String name,
    required String description,
    required AppProvider appProvider,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-place');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'name': name,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> updatePlace(AppProvider appProvider, {
    required int place_id,
    required String name,
    required String description,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-place');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'place_id': place_id,
          'name': name,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getPlace(int place_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-place');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'place_id': place_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        List place = data['place'];
        print(place);
        return place;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> deletePlace(int place_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-place');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'place_id': place_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getPlaceList(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-place-list');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List places = data['places'];
        print(places);
        return places;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  // - - -   ACTIVITIES - - -

  static Future<List> getActivities(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-activities');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List activities = data['activities'];
        print(activities);
        return activities;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> addActivity({
    required String name,
    required String description,
    required AppProvider appProvider,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-activity');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'name': name,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> updateActivity(AppProvider appProvider, {
    required int activity_id,
    required String name,
    required String description,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-activity');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'activity_id': activity_id,
          'name': name,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getActivity(int activity_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-activity');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'activity_id': activity_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        List activity = data['activity'];
        print(activity);
        return activity;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> deleteActivity(int activity_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-activity');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'activity_id': activity_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getActivityList(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-activity-list');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List activities = data['activities'];
        print(activities);
        return activities;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  // - - -   RESOURCES   - - -

  static Future<List> getResources(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-resources');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List resources = data['resources'];
        print(resources);
        return resources;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> addResource({
    required String name,
    required String description,
    required int quantity,
    required bool auto_accept,
    required bool over_booking,
    required String type,
    required String place,
    required String activity,
    required int slot,
    required Map referents,
    required AppProvider appProvider,
    required Map resource_permissions,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-resource');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'name': name,
          'description': description,
          'quantity': quantity,
          'auto_accept': auto_accept,
          'over_booking': over_booking,
          'type': type,
          'place': place,
          'activity': activity,
          'slot': slot,
          'referents': referents,
          'resource_permissions': resource_permissions,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getResource(int resource_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-resource');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'resource_id': resource_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        List resource = data['resource'];
        print(resource);
        return resource;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<int> updateResource(AppProvider appProvider, {
    required int resource_id,
    required String name,
    required String description,
    required int quantity,
    required bool auto_accept,
    required bool over_booking,
    required String type,
    required String place,
    required String activity,
    required int slot,
    required Map referents,
    required Map resource_permissions,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-resource');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'resource_id': resource_id,
          'name': name,
          'description': description,
          'quantity': quantity,
          'auto_accept': auto_accept,
          'over_booking': over_booking,
          'type': type,
          'place': place,
          'activity': activity,
          'slot': slot,
          'referents': referents,
          'resource_permissions': resource_permissions,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) return 0;
      if (response.statusCode == 502) return 1;
      if (response.statusCode == 503) return 2;
      return 3;
    } catch (e) {
      appProvider.setNoConnection(true);
      return 3;
    }
  }

  static Future<bool> deleteResource(int resource_type, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-resource');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'resource_id': resource_type,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<Map> getResourcePermission(AppProvider appProvider, {
    required List<String> roles,
    int resource_id = -1,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/get-resource-permission');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'roles': roles,
          'resource_id': resource_id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        Map roles_permission = data['roles_permission'];
        print(roles_permission);
        return roles_permission;
      } else {
        return {};
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return {};
    }
  }

  // - - -   AVAILABILITY   - - -

  static Future<List> getAvailabilities(AppProvider appProvider, {required int resource_id}) async {
    try {
      final url = Uri.parse(serverAddr + '/get-availabilities');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'resource_id': resource_id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List availabilities = data['availabilities'];
        print(availabilities);
        return availabilities;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<int> checkAvailabilityQuantity(AppProvider appProvider, {
    required int resource_id,
    required DateTime start,
    required DateTime end,
    int remove_availability_id = -1,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/check-availabilities-quantity');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'resource_id': resource_id,
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'remove_availability_id': remove_availability_id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        int quantity = data['quantity'];
        print(quantity);
        return quantity;
      } else {
        return 0;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return 0;
    }
  }

  static Future<bool> addAvailability({
    required DateTime start,
    required DateTime end,
    required int quantity,
    required int resource_id,
    required AppProvider appProvider,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/add-availability');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'quantity': quantity,
          'resource_id': resource_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getAvailability(int availability_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-availability');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'availability_id': availability_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        List availability = data['availability'];
        print(availability);
        return availability;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<int> updateAvailability(AppProvider appProvider, {
    required int availability_id,
    required DateTime start,
    required DateTime end,
    required int quantity,
  }) async {
    try {
      final url = Uri.parse(serverAddr + '/update-availability');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'availability_id': availability_id,
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'quantity': quantity,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        return 0;
      } else if (response.statusCode == 502) {
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return 2;
    }
  }

  static Future<int> deleteAvailability(int availability_id, AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/delete-availability');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'availability_id': availability_id,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      if (response.statusCode == 200) {
        return 0;
      } else if (response.statusCode == 502) {
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return 2;
    }
  }

  // - - -   BOOKINGS   - - -

  static Future<List> getResourcesFeed(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-resources-feed');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List resources = data['resources'];
        print(resources);
        return resources;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<Map> getResourceForBooking(AppProvider appProvider, {required int resource_id, required DateTime start, required DateTime end}) async {
    try {
      final url = Uri.parse(serverAddr + '/get-resource-for-booking');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'resource_id': resource_id,
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        Map content = data['content'];
        print(content);
        return content;
      } else {
        return {};
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return {};
    }
  }

  static Future<int> checkBookingQuantity(AppProvider appProvider, {required int resource_id, required DateTime start, required DateTime end, int remove_booking_id = -1}) async {
    try {
      final url = Uri.parse(serverAddr + '/check-bookings-quantity');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'resource_id': resource_id,
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'remove_booking_id': remove_booking_id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        int quantity = data['quantity'];
        print(quantity);
        return quantity;
      } else {
        return 0;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return 0;
    }
  }

  static Future<bool> addBooking({required DateTime start, required DateTime end, required int quantity, required int resource_id, required String place, required String activity, required AppProvider appProvider}) async {
    try {
      final url = Uri.parse(serverAddr + '/add-booking');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': appProvider.email,
          'token': appProvider.token,
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'quantity': quantity,
          'resource_id': resource_id,
          'place': place,
          'activity': activity,
        }),
      );

      final data = jsonDecode(response.body);
      appProvider.setLogged(true);
      appProvider.setToken(data['token']);

      return response.statusCode == 200;
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getPendingBookings(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-pending-bookings');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List bookings = data['bookings'];
        for (var booking in bookings) {
          print(booking);
        }
        print(bookings);
        return bookings;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> acceptPendingBookings(AppProvider appProvider, {required int request_id}) async {
    try {
      final url = Uri.parse(serverAddr + '/accept-pending-bookings');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'request_id': request_id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<bool> refusePendingBookings(AppProvider appProvider, {required int request_id}) async {
    try {
      final url = Uri.parse(serverAddr + '/refuse-pending-bookings');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'request_id': request_id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

  static Future<List> getBookings(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-bookings');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List bookings = data['bookings'];
        print(bookings);
        return bookings;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<List> getUserBookings(AppProvider appProvider) async {
    try {
      final url = Uri.parse(serverAddr + '/get-user-bookings');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        List bookings = data['bookings'];
        print(bookings);
        return bookings;
      } else {
        return [];
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return [];
    }
  }

  static Future<bool> cancelBooking(AppProvider appProvider, {required int booking_id}) async {
    try {
      final url = Uri.parse(serverAddr + '/cancel-booking');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': appProvider.email, 'token': appProvider.token, 'booking_id': booking_id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appProvider.setLogged(true);
        appProvider.setToken(data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      appProvider.setNoConnection(true);
      return false;
    }
  }

}