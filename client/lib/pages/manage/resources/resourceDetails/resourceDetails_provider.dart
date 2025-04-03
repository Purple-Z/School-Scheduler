import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



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
  bool slot_chek = false;
  Duration slot_duration = Duration(hours: 0, minutes: 0);


  loadResourceDetailsPage() async {
    notifyListeners();
  }

  setSlotDuration(Duration d) {
    slot_duration = d;
    notifyListeners();
  }

  getSlotDuration() {
    if (slot_chek){
      return slot_duration.inMinutes;
    } else {
      return -1;
    }
  }

  getOverbooking() {
    if (resource[8]) {
      return false;
    }
    return resource[9];
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

  Map getUser (){
    Map referents = {};
    for (List user in users){
      if (user.last == true){
        referents[user[3]] = true;
      }
    }

    return referents;
  }

  setResource (List c_resource) {
    resource = c_resource.sublist(0, c_resource.length-1);
    place = resource[5] == '' ? places.first[0] : resource[5].toString();
    activity = resource[6] == '' ? places.first[0] : resource[6].toString();

    //restore slots

    if (resource[7] != null){
      slot_chek = true;
      slot_duration = Duration(minutes: resource[7]);
    } else {
      slot_chek = false;
      slot_duration = Duration();
    }

    changeTypeValue(resource[4]);

    //restore referents
    Map referents = c_resource[c_resource.length-1];

    List<String> ref_emails = [];
    for (String email in referents.keys){
      ref_emails.add(email);
    }

    changeUsersValue(ref_emails);

    notifyListeners();
  }

  setResourcePermission (Map c_resource_permission){
    resource_permission = c_resource_permission;
    notifyListeners();
  }
}