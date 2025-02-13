import 'package:flutter/material.dart';


class UserDetailsProvider extends ChangeNotifier {
  List user = [];

  loadUserDetailsPage() async {
    notifyListeners();
  }

  setUser (List c_user) {
    user = c_user;
    notifyListeners();
  }
}