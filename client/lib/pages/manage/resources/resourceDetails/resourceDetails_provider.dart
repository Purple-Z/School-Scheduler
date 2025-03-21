import 'package:flutter/material.dart';


class ResourceDetailsProvider extends ChangeNotifier {
  List resource = [];
  List types = [];
  var type;
  List places = [];
  var place;
  List activities = [];
  var activity;
  List users = [];
  Map resource_permission = {};


  loadResourceDetailsPage() async {
    notifyListeners();
  }

  changeTypeValue(var value){
    type = value;
    notifyListeners();
  }

  setTypes (List c_types) {
    types = c_types;
    type = types.first[0];
    notifyListeners();
  }

  changePlaceValue(var value){
    place = value;
    notifyListeners();
  }

  setPlaces (List c_places) {
    c_places.insert(0, ['Not Specified', '']);
    places = c_places;
    place = c_places.first[0];
    notifyListeners();
  }

  changeActivityValue(var value){
    activity = value;
    notifyListeners();
  }

  setActivities (List c_activities) {
    c_activities.insert(0, ['Not Specified', '']);
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

  setResource (List c_resource) {
    resource = c_resource;
    place = resource[5] == '' ? places.first[0] : resource[5].toString();
    activity = resource[6] == '' ? places.first[0] : resource[6].toString();
    notifyListeners();
  }

  setResourcePermission (Map c_resource_permission){
    resource_permission = c_resource_permission;
    notifyListeners();
  }
}