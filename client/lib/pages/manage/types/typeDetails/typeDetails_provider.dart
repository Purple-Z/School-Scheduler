import 'package:flutter/material.dart';


class TypeDetailsProvider extends ChangeNotifier {
  List type = [];

  loadTypeDetailsPage() async {
    notifyListeners();
  }

  setType (List c_type) {
    type = c_type;
    notifyListeners();
  }
}