import 'package:client/main.dart';
import 'package:client/pages/manage/bookings/bookingDetails/bookingDetails_provider.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

import '../functions.dart';
import 'bookings/bookingDetails/bookingDetails_page.dart';
import 'classes.dart';



class EventListWidget extends StatefulWidget {
  final List<Booking> currentEvents;

  const EventListWidget({Key? key, required this.currentEvents}) : super(key: key);

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    var bookingDetailsProvider = context.watch<BookingDetailsProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: Column(
        children: widget.currentEvents.map((event) =>
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
                          bookingDetailsProvider.setBooking(event);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsPage(),
                            ),
                          );
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



class ResponsiveCalendarAndEvents extends StatefulWidget {
  final dynamic appProvider;
  List<Booking> currentEvents;
  Map<DateTime, List<Booking>> events = {};

  ResponsiveCalendarAndEvents({
    Key? key,
    required this.appProvider,
    required this.currentEvents,
    required this.events
  }) : super(key: key);

  @override
  State<ResponsiveCalendarAndEvents> createState() => _ResponsiveCalendarAndEventsState();
}

class _ResponsiveCalendarAndEventsState extends State<ResponsiveCalendarAndEvents> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  List<Booking> _getEventsForDay(DateTime day, {bool f = false}) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    if (f){
      print(widget.events.toString());
      print((widget.events[normalizedDay] ?? []).toString());
    }

    return widget.events[normalizedDay] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < widget.appProvider.maxWidth) {
          return SingleChildScrollView(
            child: Column(
              children: [
                buildTableCalendar(),
                SizedBox(height: 30),
                EventListWidget(currentEvents: widget.currentEvents),
              ],
            ),
          );
        } else {
          return Row(
            children: [
              Expanded(child: buildTableCalendar()),
              SizedBox(width: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: EventListWidget(currentEvents: widget.currentEvents),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  TableCalendar<Booking> buildTableCalendar() {
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
          setState(() {
            widget.currentEvents = _getEventsForDay(_selectedDay ?? DateTime.now());
            //widget.currentEvents = _getEventsForDay(DateTime(2025, 04, 14));
          });
          //widget.manageBookingsProvider.setCurrentEvents(_getEventsForDay(_selectedDay ?? DateTime.now()));
        });
      },
      locale: widget.appProvider.locale.toLanguageTag(),
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
        },
      ),
    );
  }
}