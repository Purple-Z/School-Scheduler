import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';
import '../../manage/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ResourceProvider extends ChangeNotifier {
  List resource = [];
  List<AvailabilitySlot> shifts = [];
  int slot = 0;
  bool slot_logic = false;
  List places = [];
  var place;
  bool can_edit_place = true;
  List activities = [];
  var activity;
  bool can_edit_activity = true;

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  DateTime start_booking = DateTime.now();
  DateTime end_booking = DateTime.now();

  int resource_Id = -1;

  loadResourcePage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    Map content = await Connection.getResourceForBooking(appProvider, resource_id: resource_Id, start: start, end: end);

    setResource(content['resource'], context);
    setStart(DateTime.tryParse(content['start']) ?? DateTime.now());
    setEnd(DateTime.tryParse(content['end']) ?? DateTime.now());
    setShifts(content['shifts']);
  }

  notify(){
    notifyListeners();
  }

  setResource(List c_resource, BuildContext context) {
    resource = c_resource;


    if (resource[5] != ''){
      place = resource[5];
      can_edit_place = false;
    } else {
      can_edit_place = true;
    }


    if (resource[6] != ''){
      activity = resource[6];
      can_edit_activity = false;
    } else {
      can_edit_activity = true;
    }

    if (resource[7] != null){
      slot = resource[7];
      slot_logic = true;
    } else {
      slot_logic = false;
    }

    notifyListeners();
  }

  setResourceId(int id) {
    resource_Id = id;
    notifyListeners();
  }

  changePlaceValue(var value){
    place = value;
    notifyListeners();
  }

  setPlaces (List c_places, BuildContext context) {
    //c_places.insert(0, [AppLocalizations.of(context)!.resource_not_specified, '']);
    places = c_places;
    place = c_places.first[0];
    notifyListeners();
  }

  changeActivityValue(var value){
    activity = value;
    notifyListeners();
  }

  setActivities (List c_activities, BuildContext context) {
    //c_activities.insert(0, [AppLocalizations.of(context)!.resource_not_specified, '']);
    activities = c_activities;
    activity = c_activities.first[0];
    notifyListeners();
  }


  setShifts(List c_shifts) {
    List<AvailabilitySlot> s = [];

    for (List shift in c_shifts){
      s.add(AvailabilitySlot(
          startTime: DateTime.tryParse(shift[0]) ?? DateTime.now(),
          endTime: DateTime.tryParse(shift[1]) ?? DateTime.now(),
          availability: shift[2]
      ));
    }

    shifts = s;
    notifyListeners();
  }

  setStart(DateTime c_start) {
    start = c_start;
    notifyListeners();
  }

  setEnd(DateTime c_end) {
    end = c_end;
    notifyListeners();
  }

  setStartBooking(DateTime c_start) {
    start_booking = c_start;
    notifyListeners();
  }

  setEndBooking(DateTime c_end) {
    end_booking = c_end;
    notifyListeners();
  }
}