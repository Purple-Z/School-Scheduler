import 'package:flutter/material.dart';


class UserDetailsProvider extends ChangeNotifier {
  List user = [];
  List roles = [];
  List<bool> rolesValues = [];


  loadUserDetailsPage() async {
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
      String curr_role = roles[i][0];

      if (roleInUser(curr_role)){
        rolesValues.add(true);
      } else {
        rolesValues.add(false);
      }

    }
    notifyListeners();
  }

  bool roleInUser(String role){
    for (String user_role in user[user.length-1]){
      if (role == user_role){
        return true;
      }
    }

    return false;
  }

  setUser (List c_user) {
    user = c_user;
    notifyListeners();
  }
}