import 'package:flutter/material.dart';


class RoleDetailsProvider extends ChangeNotifier {
  List role = [];

  loadRoleDetailsPage() async {
    notifyListeners();
  }

  setRole (List c_role) {
    role = c_role;
    notifyListeners();
  }
}