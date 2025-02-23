import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManageRolesProvider extends ChangeNotifier {
  List roles = [];

  loadManageRolesPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_roles = await Connection.getRoles(appProvider);
    roles = c_roles;
    notifyListeners();
  }

  setRoles(List c_roles) {
    roles = c_roles;
    notifyListeners();
  }
}