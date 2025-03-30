import 'package:client/app_provider.dart';
import 'package:client/pages/account/userBookings/userBookings_provider.dart';
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

import '../../../connection.dart';
import '../../functions.dart';
import '../../manage/classes.dart';


class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({super.key});

  @override
  State<UserBookingsPage> createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  @override
  Widget build(BuildContext context) {
    var userBookingsProvider = context.watch<UserBookingsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_own_booking
        ? UserBookingsAdmin()
        : Text(AppLocalizations.of(context)!.access_denied);
  }
}

class UserBookingsAdmin extends StatefulWidget {
  const UserBookingsAdmin({super.key});

  @override
  _UserBookingsAdminState createState() => _UserBookingsAdminState();
}

class _UserBookingsAdminState extends State<UserBookingsAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();



  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _loadEvents();
  }


  void _loadEvents() async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    var userBookingsProvider = Provider.of<UserBookingsProvider>(context, listen: false);
    List bookings = await Connection.getUserBookings(appProvider);
    userBookingsProvider.events.clear();
    Map<DateTime, List<Booking>> events = {};

    for (List booking in bookings){
      DateTime time = DateTime.tryParse(booking[1]) ?? DateTime.now();
      events[DateTime(time.year, time.month, time.day)] = [];
    }

    for (List booking in bookings){
      Booking b = Booking(
          booking[0].toString(),
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
          booking[11]
      );
      print('nuovo evento ' + events.toString());
      DateTime time = DateTime.tryParse(booking[1]) ?? DateTime.now();
      events[DateTime(time.year, time.month, time.day)]?.add(b);
    }

    userBookingsProvider.setBookings(events);
  }

  List<Booking> _getEventsForDay(DateTime day) {
    var userBookingsProvider = Provider.of<UserBookingsProvider>(context, listen: false);
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return userBookingsProvider.events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var userBookingsProvider = context.watch<UserBookingsProvider>();
    var appProvider = context.watch<AppProvider>();
    List pending_bookings = userBookingsProvider.requests;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: [
              TableCalendar<Booking>(
                firstDay: DateTime(2010, 10, 16),
                lastDay: DateTime(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                locale: appProvider.locale.toLanguageTag(),
                eventLoader: (day) {
                  return _getEventsForDay(day);
                },
                calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${events.length}',
                                style:
                                TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary, // Colore per il giorno selezionato
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },

                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Column(
                  children: _getEventsForDay(_selectedDay ?? DateTime.now()).map((event) =>
                      Column(
                        children: [
                          Divider(thickness: 0.5,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    if (event.status == 0) Text(
                                      'Pending',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).colorScheme.primary
                                      ),
                                    ),
                                    if (event.status == 1) Text(
                                      'Accepted',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).colorScheme.tertiary
                                      ),
                                    ),
                                    if (event.status == 2) Text(
                                      'Refuzed',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).colorScheme.secondary
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      event.resource_name,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text(
                                      event.user_email,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Text(
                                      'From',
                                      style: TextStyle(fontSize: 15,),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      '${event.start.day}/${event.start.month}/${event.start.year}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      getTimePrintable(event.start),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text(
                                      event.quantity.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'To',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      '${event.end.day}/${event.end.month}/${event.end.year}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      getTimePrintable(event.end),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Text(
                                      event.activity_name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    Text(
                                      event.place_name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.push(Routes.manage_Bookings_BookingsDetails, extra: {
                                          'booking': event,
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'View',
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.surface
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_outward,
                                            color: Theme.of(context).colorScheme.surface,
                                          )
                                        ],
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ).toList(),
                ),
              ),
            ],
          )
      ),
    );
  }
}
