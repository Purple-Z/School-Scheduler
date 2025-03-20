import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManageActivitiesProvider extends ChangeNotifier {
  List activities = [];

  loadManageActivitiesPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_activities = await Connection.getActivities(appProvider);
    activities = c_activities;
    notifyListeners();
  }

  setActivities(List c_places) {
    activities = c_places;
    notifyListeners();
  }
}