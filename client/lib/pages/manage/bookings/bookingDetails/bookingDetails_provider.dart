import 'package:flutter/material.dart';

import '../../classes.dart';
import '../manageBookings_page.dart';


class BookingDetailsProvider extends ChangeNotifier {
  late Booking booking;

  loadBookingDetailsPage() async {
    notifyListeners();
  }

  setBooking (Booking c_booking) {
    booking = c_booking;
    notifyListeners();
  }
}