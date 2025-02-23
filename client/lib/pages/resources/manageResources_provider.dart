import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManageResourcesProvider extends ChangeNotifier {
  List resources = [];

  loadManageResourcesPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_resources = await Connection.getResources(appProvider);
    resources = c_resources;
    notifyListeners();
  }

  setResources(List c_resources) {
    resources = c_resources;
    notifyListeners();
  }
}