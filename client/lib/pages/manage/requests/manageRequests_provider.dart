import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';


class ManageRequestsProvider extends ChangeNotifier {
  List requests = [];

  loadManageRequestsPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_bookings = await Connection.getPendingBookings(appProvider);
    requests = c_bookings;
    notifyListeners();
  }

  setPendingBookings(List c_bookings) {
    requests = c_bookings;
    notifyListeners();
  }
}