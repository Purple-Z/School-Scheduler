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
    _loadEvents();
  }


  void _loadEvents() async {
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

    manageBookingProvider.setBookings(events);
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
    List<Booking> currentEvents = manageBookingsProvider.currentEvents;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints)
            {
              if (constraints.maxWidth < appProvider.maxWidth) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      buildTableCalendar(appProvider, manageBookingsProvider),
                      SizedBox(height: 30),
                      EventListWidget(),
                    ],
                  ),
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: buildTableCalendar(appProvider, manageBookingsProvider)),
                    SizedBox(width: 30),
                    Expanded(
                        child: SingleChildScrollView(
                            child: EventListWidget()
                        )
                    ),
                  ],
                );
              }
            },
          )
      ),
    );
  }

  TableCalendar<Booking> buildTableCalendar(AppProvider appProvider, ManageBookingsProvider manageBookingsProvider) {
    return TableCalendar<Booking>(
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
                  manageBookingsProvider.setCurrentEvents(_getEventsForDay(_selectedDay ?? DateTime.now()));
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
                            TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 10),
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
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  );
                }

              ),
            );
  }
}

class EventListWidget extends StatefulWidget {

  const EventListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    var manageBookingsProvider = context.watch<ManageBookingsProvider>();
    List<Booking> currentEvents = manageBookingsProvider.currentEvents;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: Column(
        children: currentEvents.map((event) =>
            Column(
              children: [
                const Divider(thickness: 0.5,),
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
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OverflowTextAnimated(
                              key: ValueKey(event.id),
                              text: event.resource_name.toString(),
                              style: const TextStyle(fontSize: 25),
                              curve: Curves.easeInOut,
                              animation: OverFlowTextAnimations.scrollOpposite,
                              animateDuration: const Duration(milliseconds: 2000),
                              delay: const Duration(milliseconds: 500),
                              loopSpace: 10,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OverflowTextAnimated(
                              key: ValueKey(event.id),
                              text: event.user_email,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                              ),
                              curve: Curves.easeInOut,
                              animation: OverFlowTextAnimations.scrollOpposite,
                              animateDuration: const Duration(milliseconds: 2000),
                              delay: const Duration(milliseconds: 500),
                              loopSpace: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const Text(
                            'From',
                            style: TextStyle(fontSize: 15,),
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            getDatePrintable(event.start, context),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            getTimePrintable(event.start),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Text(
                            event.quantity.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'To',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            getDatePrintable(event.end, context),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            getTimePrintable(event.end),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: OverflowTextAnimated(
                              key: ValueKey(event.id),
                              text: event.activity_name,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200
                              ),
                              curve: Curves.easeInOut,
                              animation: OverFlowTextAnimations.scrollOpposite,
                              animateDuration: const Duration(milliseconds: 2000),
                              delay: const Duration(milliseconds: 500),
                              loopSpace: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: OverflowTextAnimated(
                              key: ValueKey(event.id),
                              text: event.place_name,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200
                              ),
                              curve: Curves.easeInOut,
                              animation: OverFlowTextAnimations.scrollOpposite,
                              animateDuration: const Duration(milliseconds: 2000),
                              delay: const Duration(milliseconds: 500),
                              loopSpace: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      ElevatedButton(
                        onPressed: () {
                          context.push(Routes.manage_Bookings_BookingsDetails, extra: {
                            'booking': event,
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(child: SizedBox()),
                            Text(
                              'View',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ).toList(),
      ),
    );
  }
}
