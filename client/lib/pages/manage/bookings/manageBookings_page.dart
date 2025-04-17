import 'package:client/app_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

import '../../../connection.dart';
import '../../functions.dart';
import '../../responsiveCalendarAndEvents.dart';
import '../classes.dart';
import '../requests/manageRequests_provider.dart';
import '../widgets.dart';

class ManageBookingsPage extends StatefulWidget {
  const ManageBookingsPage({super.key});

  @override
  State<ManageBookingsPage> createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends State<ManageBookingsPage> {
  @override
  Widget build(BuildContext context) {
    var manageBookingsProvider = context.watch<ManageBookingsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_booking
        ? ManageBookingsAdmin()
        : Text(AppLocalizations.of(context)!.access_denied);
  }
}



class ManageBookingsAdmin extends StatefulWidget {
  const ManageBookingsAdmin({super.key});

  @override
  _ManageBookingsAdminState createState() => _ManageBookingsAdminState();
}

class _ManageBookingsAdminState extends State<ManageBookingsAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();



  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    loadEvents(context);
  }



  List<Booking> _getEventsForDay(DateTime day, {bool f = false}) {
    var manageBookingProvider = Provider.of<ManageBookingsProvider>(context, listen: false);
    final normalizedDay = DateTime(day.year, day.month, day.day);
    if (f){
      print(manageBookingProvider.events.toString());
      print((manageBookingProvider.events[normalizedDay] ?? []).toString());
    }

    return manageBookingProvider.events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var manageBookingsProvider = context.watch<ManageBookingsProvider>();
    var appProvider = context.watch<AppProvider>();
    List pending_bookings = manageBookingsProvider.requests;

    DateTime now = DateTime.now();
    final normalizedDay = DateTime(now.year, now.month, now.day);
    List<Booking> currentEvents = manageBookingsProvider.events[normalizedDay] ?? [];

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ResponsiveCalendarAndEvents(
            appProvider: appProvider,
            currentEvents: currentEvents,
            events: manageBookingsProvider.events,
            canDelete: appProvider.delete_booking,
            loadEvents: loadEvents,
          )
      ),
    );
  }
}

void loadEvents(BuildContext context) async {
  var appProvider = Provider.of<AppProvider>(context, listen: false);
  var manageBookingProvider = Provider.of<ManageBookingsProvider>(context, listen: false);
  List bookings = await Connection.getBookings(appProvider);
  manageBookingProvider.events.clear();
  Map<DateTime, List<Booking>> events = {};

  for (List booking in bookings){
    DateTime time = DateTime.tryParse(booking[1]) ?? DateTime.now();
    events[DateTime(time.year, time.month, time.day)] = [];
  }

  for (List booking in bookings){
    Booking b = Booking(
        booking[0],
        DateTime.tryParse(booking[1]) ?? DateTime.now(),
        DateTime.tryParse(booking[2]) ?? DateTime.now(),
        booking[3],
        booking[4],
        booking[5],
        booking[6],
        booking[7],
        booking[8],
        booking[9],
        booking[10],
        booking[11],
        booking[12]
    );
    print('nuovo evento ' + events.toString());
    DateTime time = DateTime.tryParse(booking[1]) ?? DateTime.now();
    events[DateTime(time.year, time.month, time.day)]?.add(b);
  }

  manageBookingProvider.setBookings(events);
}