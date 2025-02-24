import 'package:client/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../connection.dart';


class ManageAvailabilityProvider extends ChangeNotifier {
  List resource = [];
  List availabilities = [];


  loadManageAvailabilitiesPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    availabilities = await Connection.getAvailabilities(appProvider, resource_id: resource[0]);
    notifyListeners();
  }


  setAvailabilities (List c_availabilities) {
    availabilities = c_availabilities;
    notifyListeners();
  }

  setResource (List c_resource) {
    resource = c_resource;
    notifyListeners();
  }
}