import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'style/themes.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AppProvider extends ChangeNotifier {
  bool logged = false;
  String token = "";
  String name =  "";
  String surname =  "";
  String email =  "";
  bool view_user = false;
  bool edit_user = false;
  bool create_user = false;
  bool delete_user = false;
  bool view_own_user = false;
  bool edit_own_user = false;
  bool create_own_user = false;
  bool delete_own_users = false;
  bool view_roles = false;
  bool edit_roles = false;
  bool create_roles = false;
  bool delete_roles = false;
  bool view_availability = false;
  bool edit_availability = false;
  bool create_availability = false;
  bool delete_availability = false;
  bool view_resources = false;
  bool edit_resources = false;
  bool create_resources = false;
  bool delete_resources = false;
  bool view_booking = false;
  bool edit_booking = false;
  bool create_booking = false;
  bool delete_booking = false;
  bool view_own_booking = false;
  bool edit_own_booking = false;
  bool create_own_booking = false;
  bool delete_own_booking = false;
  List<dynamic> roles = [];

  bool provisoryFlag = false;

  int maxWidth = 600;

  Locale _locale = Locale('en');
  Locale get locale => _locale;

  late SharedPreferences prefs;

  AppProvider() {
    _setupLater();
  }

  _setupLater () async {
    prefs = await SharedPreferences.getInstance();

    await loadPreferences();
    await loadLocale();

    notifyListeners();
  }

  AppBar topBarContent = AppBar();

  setTopBarContent (AppBar content) {
    topBarContent = content;
    notifyListeners();
  }



  //Variables for theme
  ThemeData themeData = nigthTheme;
  IconData iconTheme = Icons.light_mode;
  bool _isDarkTheme = true;
  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    if (_isDarkTheme){
      themeData = nigthTheme;
      iconTheme = Icons.light_mode;
    } else {
      themeData = dayTheme;
      iconTheme = Icons.mode_night;
    }
    notifyListeners();
  }

  Future<void> loadLocale() async {
    String? languageCode = prefs.getString('language');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await prefs.setString('language', newLocale.languageCode);
    notifyListeners();
  }

  Future<bool> getLogged () async {
    logged = (prefs.getBool("logged")) ?? false;
    print("logged:");
    print(logged);
    return logged;
  }
  Future<String> getToken () async {
    token = (await prefs.getString("token")) ?? "";
    return token;
  }
  Future<String> getName () async {
    name = (await prefs.getString("name")) ?? "";
    return name;
  }
  Future<String> getSurname () async {
    surname = (await prefs.getString("surname")) ?? "";
    return surname;
  }
  Future<String> getEmail () async {
    email = (await prefs.getString("email")) ?? "";
    return email;
  }
  Future<List<dynamic>> getRoles () async {
    String role_string = (await prefs.getString("roles")) ?? "";
    if (role_string == null || role_string.isEmpty) {
      return [];
    }
    roles = jsonDecode(role_string);
    updateRolePermissions();
    return roles;
  }

  setLogged (bool curr_logged) {
    prefs.setBool("logged", curr_logged);
    logged = curr_logged;
    notifyListeners();
  }
  setToken (String curr_token) {
    prefs.setString("token", curr_token);
    token = curr_token;
    notifyListeners();
  }
  setName (String curr_name) {
    prefs.setString("name", curr_name);
    name = curr_name;
    notifyListeners();
  }
  setSurname (String curr_surname) {
    prefs.setString("surname", curr_surname);
    surname = curr_surname;
    notifyListeners();
  }
  setEmail (String curr_email) {
    prefs.setString("email", curr_email);
    email = curr_email;
    notifyListeners();
  }
  setRoles (List<dynamic> curr_roles) {
    prefs.setString("roles", jsonEncode(curr_roles));
    roles = curr_roles;
    updateRolePermissions();
    notifyListeners();
  }


  logout () async {
    await prefs.clear();
    await loadPreferences();
    notifyListeners();
  }

  loadPreferences () async {
    logged = await getLogged();
    token = await getToken();
    name = await getName();
    surname = await getSurname();
    email = await getEmail();
    roles = await getRoles();
  }

  setRolePermissionFalse (){
    view_user = false;
    edit_user = false;
    create_user = false;
    delete_user = false;
    view_own_user = false;
    edit_own_user = false;
    create_own_user = false;
    delete_own_users = false;
    view_roles = false;
    edit_roles = false;
    create_roles = false;
    delete_roles = false;
    view_availability = false;
    edit_availability = false;
    create_availability = false;
    delete_availability = false;
    view_resources = false;
    edit_resources = false;
    create_resources = false;
    delete_resources = false;
    view_booking = false;
    edit_booking = false;
    create_booking = false;
    delete_booking = false;
    view_own_booking = false;
    edit_own_booking = false;
    create_own_booking = false;
    delete_own_booking = false;
  }

  updateRolePermissions () {
    print("updateRolePermissions();");

    setRolePermissionFalse();

    for (Map role in roles){
      view_user = (role['view_users']==1) || view_user;
      edit_user = (role['edit_users']==1) || edit_user;
      create_user = (role['create_users']==1) || create_user;
      delete_user = (role['delete_users']==1) || delete_user;
      view_own_user = (role['view_own_user']==1) || view_own_user;
      edit_own_user = (role['edit_own_user']==1) || edit_own_user;
      create_own_user = (role['create_own_user']==1) || create_own_user;
      delete_own_users = (role['delete_own_user']==1) || delete_own_users;
      view_roles = (role['view_roles']==1) || view_roles;
      edit_roles = (role['edit_roles']==1) || edit_roles;
      create_roles = (role['create_roles']==1) || create_roles;
      delete_roles = (role['delete_roles']==1) || delete_roles;
      view_availability = (role['view_availability']==1) || view_availability;
      edit_availability = (role['edit_availability']==1) || edit_availability;
      create_availability = (role['create_availability']==1) || create_availability;
      delete_availability = (role['delete_availability']==1) || delete_availability;
      view_resources = (role['view_resources']==1) || view_resources;
      edit_resources = (role['edit_resources']==1) || edit_resources;
      create_resources = (role['create_resources']==1) || create_resources;
      delete_resources = (role['delete_resources']==1) || delete_resources;
      view_booking = (role['view_booking']==1) || view_booking;
      edit_booking = (role['edit_booking']==1) || edit_booking;
      create_booking = (role['create_booking']==1) || create_booking;
      delete_booking = (role['delete_booking']==1) || delete_booking;
      view_own_booking = (role['view_own_booking']==1) || view_own_booking;
      edit_own_booking = (role['edit_own_booking']==1) || edit_own_booking;
      create_own_booking = (role['create_own_booking']==1) || create_own_booking;
      delete_own_booking = (role['delete_own_booking']==1) || delete_own_booking;
    }
    //printPermission();
    notifyListeners();
  }

  printPermission(){
    print('view_user: ' + view_user.toString());
    print('edit_user: ' + edit_user.toString());
    print('create_user: ' + create_user.toString());
    print('delete_user: ' + delete_user.toString());
    print('view_own_user: ' + view_own_user.toString());
    print('edit_own_user: ' + edit_own_user.toString());
    print('create_own_user: ' + create_own_user.toString());
    print('delete_own_users: ' + delete_own_users.toString());
    print('view_roles: ' + view_roles.toString());
    print('edit_roles: ' + edit_roles.toString());
    print('create_roles: ' + create_roles.toString());
    print('delete_roles: ' + delete_roles.toString());
    print('view_availability: ' + view_availability.toString());
    print('edit_availability: ' + edit_availability.toString());
    print('create_availability: ' + create_availability.toString());
    print('delete_availability: ' + delete_availability.toString());
    print('view_resources: ' + view_resources.toString());
    print('edit_resources: ' + edit_resources.toString());
    print('create_resources: ' + create_resources.toString());
    print('delete_resources: ' + delete_resources.toString());
    print('view_booking: ' + view_booking.toString());
    print('edit_booking: ' + edit_booking.toString());
    print('create_booking: ' + create_booking.toString());
    print('delete_booking: ' + delete_booking.toString());
    print('view_own_booking: ' + view_own_booking.toString());
    print('edit_own_booking: ' + edit_own_booking.toString());
    print('create_own_booking: ' + create_own_booking.toString());
    print('delete_own_booking: ' + delete_own_booking.toString());
  }

  notify () {
    notifyListeners();
  }
}