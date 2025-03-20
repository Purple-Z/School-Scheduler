import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManagePlacesProvider extends ChangeNotifier {
  List places = [];

  loadManagePlacesPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_places = await Connection.getPlaces(appProvider);
    places = c_places;
    notifyListeners();
  }

  setPlaces(List c_places) {
    places = c_places;
    notifyListeners();
  }
}