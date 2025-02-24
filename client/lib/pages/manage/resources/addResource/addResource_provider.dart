import 'package:flutter/material.dart';


class AddResourceProvider extends ChangeNotifier {
  List types = [];
  var type;

  loadAddResourcePage() async {
    notifyListeners();
  }

  changeTypeValue(var value){
    type = value;
    notifyListeners();
  }

  setTypes (List c_types) {
    types = c_types;
    type = c_types.first[0];
    notifyListeners();
  }
}