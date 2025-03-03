import 'package:flutter/material.dart';


class ResourceDetailsProvider extends ChangeNotifier {
  List resource = [];
  List types = [];
  Map resource_permission = {};
  var type;


  loadResourceDetailsPage() async {
    notifyListeners();
  }

  changeTypeValue(bool value){
    type = value;
    notifyListeners();
  }

  setTypes (List c_types) {
    types = c_types;
    type = types.first[0];
    notifyListeners();
  }

  setResource (List c_resource) {
    resource = c_resource;
    notifyListeners();
  }

  setResourcePermission (Map c_resource_permission){
    resource_permission = c_resource_permission;
    notifyListeners();
  }
}