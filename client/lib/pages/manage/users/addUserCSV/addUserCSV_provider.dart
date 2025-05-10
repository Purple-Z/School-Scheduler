import 'package:flutter/material.dart';


class AddUsersCSVProvider extends ChangeNotifier {
  List users = [];
  bool canLoad = false;

  loadAddUsersCSVPage() async {
    notifyListeners();
  }

  setUsers (List c_users) {
    users = c_users;
    notifyListeners();
  }

  setCanLoad(c_canLoad) {
    canLoad = c_canLoad;
    notifyListeners();
  }
}