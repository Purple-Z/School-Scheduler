import 'package:flutter/material.dart';


class AddUserProvider extends ChangeNotifier {
  List roles = [];
  List<bool> rolesValues = [];

  loadAddUserPage() async {
    notifyListeners();
  }

  changeRoleValue(int index, bool value){
    rolesValues[index] = value;
    notifyListeners();
  }

  setRoles (List c_roles) {
    roles = c_roles;
    rolesValues = [];
    for (int i = 0; i < roles.length; i++){
      rolesValues.add(false);
    }
    notifyListeners();
  }
}