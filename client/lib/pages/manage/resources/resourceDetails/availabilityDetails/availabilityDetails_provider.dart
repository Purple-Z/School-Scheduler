import 'package:flutter/material.dart';


class AvailabilityDetailsProvider extends ChangeNotifier {
  List availability = [];
  List resource = [];


  loadAvailabilityDetailsPage() async {
    notifyListeners();
  }



  setResource (List c_resource) {
    resource = c_resource;
    notifyListeners();
  }
  
  setAvailability (List c_availability) {
    availability = c_availability;
    notifyListeners();
  }
}