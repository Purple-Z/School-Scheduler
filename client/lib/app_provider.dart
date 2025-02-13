import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'style/themes.dart';
import 'dart:convert';
import 'dart:io';

class AppProvider extends ChangeNotifier {
  bool logged = false;
  String token = "";
  String name =  "";
  String surname =  "";
  String email =  "";
  bool student = false;
  bool professor = false;
  bool leader = false;
  bool admin = false;
  late SharedPreferences prefs;

  AppProvider() {
    _setupLater();
  }

  _setupLater () async {
    prefs = await SharedPreferences.getInstance();

    await loadPreferences();

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
  Future<bool> getStudent () async {
    student = (await prefs.getBool("student")) ?? false;
    return student;
  }
  Future<bool> getProfessor () async {
    professor = (await prefs.getBool("professor")) ?? false;
    return professor;
  }
  Future<bool> getLeader () async {
    leader = (await prefs.getBool("leader")) ?? false;
    return leader;
  }
  Future<bool> getAdmin () async {
    admin = (await prefs.getBool("admin")) ?? false;
    return admin;
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
  setStudent (bool curr_student) {
    prefs.setBool("student", curr_student);
    student = curr_student;
    notifyListeners();
  }
  setProfessor (bool curr_professor) {
    prefs.setBool("professor", curr_professor);
    professor = curr_professor;
    notifyListeners();
  }
  setLeader (bool curr_leader) {
    prefs.setBool("leader", curr_leader);
    leader = curr_leader;
    notifyListeners();
  }
  setAdmin (bool curr_admin) {
    prefs.setBool("admin", curr_admin);
    admin = curr_admin;
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
    student = await getStudent();
    professor = await getProfessor();
    leader = await getLeader();
    admin = await getAdmin();
  }

  notify () {
    notifyListeners();
  }
}