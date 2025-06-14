import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ResourcesProvider extends ChangeNotifier {
  Map resources = {};

  loadResourcesPage(BuildContext context) async {
    notifyListeners();
  }

  setResources(Map c_resources) {
    resources = c_resources;
    notifyListeners();
  }
}