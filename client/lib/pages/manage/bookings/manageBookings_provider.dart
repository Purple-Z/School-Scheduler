import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../connection.dart';
import 'manageBookings_page.dart';


class ManageBookingsProvider extends ChangeNotifier {
  List requests = [];
  Map<DateTime, List<Booking>> events = {};

  loadManageBookingsPage(BuildContext context) async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    List c_bookings = await Connection.getPendingBookings(appProvider);
    requests = c_bookings;
    notifyListeners();
  }

  setBookings(Map<DateTime, List<Booking>> c_bookings) {
    events = c_bookings;
    notifyListeners();
  }
}