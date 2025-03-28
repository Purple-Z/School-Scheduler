import 'package:flutter/material.dart';


class RequestDetailsProvider extends ChangeNotifier {
  List request = [];

  loadRequestDetailsPage() async {
    notifyListeners();
  }

  setRequest (List c_request) {
    request = c_request;
    notifyListeners();
  }
}