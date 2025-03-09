import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';
import '../../manage/widgets.dart';


class ResourceProvider extends ChangeNotifier {
  List resource = [];
  List<AvailabilitySlot> shifts = [];

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  DateTime start_booking = DateTime.now();
  DateTime end_booking = DateTime.now();

  int resource_Id = -1;

  loadResourcePage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    Map content = await Connection.getResourceForBooking(appProvider, resource_id: resource_Id, start: start, end: end);

    var resourceProvider = Provider.of<ResourceProvider>(context, listen: false);
    resourceProvider.setResource(content['resource']);
    resourceProvider.setStart(DateTime.tryParse(content['start']) ?? DateTime.now());
    resourceProvider.setEnd(DateTime.tryParse(content['end']) ?? DateTime.now());
    resourceProvider.setShifts(content['shifts']);
  }

  setResource(List c_resource) {
    resource = c_resource;
    notifyListeners();
  }

  setResourceId(int id) {
    resource_Id = id;
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
}