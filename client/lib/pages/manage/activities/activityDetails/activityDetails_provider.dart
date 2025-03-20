import 'package:flutter/material.dart';


class ActivityDetailsProvider extends ChangeNotifier {
  List activity = [];

  loadActivityDetailsPage() async {
    notifyListeners();
  }

  setActivity (List c_activity) {
    activity = c_activity;
    notifyListeners();
  }
}