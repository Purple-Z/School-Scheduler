import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class AddResourceProvider extends ChangeNotifier {
  List types = [];
  var type;
  List places = [];
  var place;
  List activities = [];
  var activity;
  List users = [];
  Map resource_permission = {};
  bool auto_accept_check = false;
  bool over_bookig_check = false;
  bool slot_chek = false;

  loadAddResourcePage() async {
    notifyListeners();
  }

  changeTypeValue(var value){
    type = value;
    notifyListeners();
  }

  setTypes (List c_types) {
    types = c_types;
    type = c_types.first[0];
    notifyListeners();
  }

  changePlaceValue(var value){
    place = value;
    notifyListeners();
  }

  setPlaces (List c_places, BuildContext context) {
    c_places.insert(0, [AppLocalizations.of(context)!.resource_not_specified, '']);
    places = c_places;
    place = c_places.first[0];
    notifyListeners();
  }

  changeActivityValue(var value){
    activity = value;
    notifyListeners();
  }

  setActivities (List c_activities, BuildContext context) {
    c_activities.insert(0, [AppLocalizations.of(context)!.resource_not_specified, '']);
    activities = c_activities;
    activity = c_activities.first[0];
    notifyListeners();
  }

  changeUsersValue(List emails_selected){
    for (List user in users){
      String user_email = user[3];
      if (emails_selected.contains(user_email)){
        user[user.length-1] = true;
      } else {
        user[user.length-1] = false;
      }
    }
    notifyListeners();
  }

  setUsers (List c_users) {
    for(List user in c_users){
      user.add(false);
    }
    print(c_users);
    users = c_users;
    notifyListeners();
  }

  getUser (){
    List<String> c_user = [];
    for (List user in users){
      if (user.last == true){
        c_user.add(
          user[3]
        );
      }
    }

    return c_user;
  }

  setResourcePermission (Map c_resource_permission){
    resource_permission = c_resource_permission;
    notifyListeners();
  }
}