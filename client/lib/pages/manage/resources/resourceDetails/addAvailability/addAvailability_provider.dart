import 'package:flutter/material.dart';


class AddAvailabilityProvider extends ChangeNotifier {
  List resource = [];

  loadAddAvailabilityPage() async {
    notifyListeners();
  }

  setResource (List c_resource) {
    resource = c_resource;
    notifyListeners();
  }
}