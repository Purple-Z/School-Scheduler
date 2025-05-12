import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManageUsersProvider extends ChangeNotifier {
  List users = [];

  List filters = [];

  setFilters(c_filters) {
    c_filters = filters;
    print('valore filtri dall interno: '+ filters.toString());
    notifyListeners();
  }

  loadManageUsersPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_users = await Connection.getUsers(appProvider);
    var manageUsersProvider = Provider.of<ManageUsersProvider>(context, listen: false);
    users = c_users;
    notifyListeners();
  }

  setUsers(List c_users) {
    users = c_users;
    notifyListeners();
  }
}