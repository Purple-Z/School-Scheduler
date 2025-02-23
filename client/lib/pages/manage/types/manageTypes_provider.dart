import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManageTypesProvider extends ChangeNotifier {
  List types = [];

  loadManageTypesPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_types = await Connection.getTypes(appProvider);
    types = c_types;
    notifyListeners();
  }

  setTypes(List c_types) {
    types = c_types;
    notifyListeners();
  }
}