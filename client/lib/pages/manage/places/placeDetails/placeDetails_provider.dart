import 'package:flutter/material.dart';


class PlaceDetailsProvider extends ChangeNotifier {
  List place = [];

  loadPlaceDetailsPage() async {
    notifyListeners();
  }

  setPlace (List c_place) {
    place = c_place;
    notifyListeners();
  }
}