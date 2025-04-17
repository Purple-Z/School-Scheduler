import 'package:client/app_provider.dart';
import 'package:client/main.dart';
import 'package:client/router/routes.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

import '../connection.dart';
import '../graphics/graphics_methods.dart';
import 'functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'manage/classes.dart';




class EventListWidget extends StatefulWidget {
  final List<Booking> currentEvents;
  bool canDelete = false;
  final Function loadEvents;

   EventListWidget({Key? key, required this.currentEvents, required this.canDelete, required this.loadEvents}) : super(key: key);
  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();

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
                            'Refused',
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.secondary
                            ),
                          ),
                          if (event.status == 3) Text(
                            'Cancelled',
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (event.status == 1 && widget.canDelete) Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if(await confirm(context, content: Text("Cancel?"))){

                                  if (await showSimpleLoadingDialog<bool>(
                                    context: context,
                                    future: () async {
                                      bool result = await Connection.cancelBooking(appProvider, booking_id: event.id);

                                      return result;
                                    },
                                  )){
                                    await showSimpleLoadingDialog(
                                      context: context,
                                      future: () async {
                                        await widget.loadEvents(context);
                                      },
                                    );
                                    showTopMessage(context, "Booking Cancelled");
                                  } else {
                                    showTopMessage(context, "Error Occurred");
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.surface,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)
                              ),
                            ),
                          ),

                          if (event.status == 1 && widget.canDelete) SizedBox(width: 10,),

                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingDetailsPage(loadEvents: widget.loadEvents, booking: event,),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.surface,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_outward,
                                      color: Theme.of(context).colorScheme.surface,
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                                ),
                              ),
                            ),
                          ),
                        ],
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
  bool canDelete = false;
  final Function loadEvents;

  ResponsiveCalendarAndEvents({
    Key? key,
    required this.appProvider,
    required this.currentEvents,
    required this.events,
    required this.canDelete,
    required this.loadEvents
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
                buildTopBar(),
                buildTableCalendar(),
                SizedBox(height: 30),
                EventListWidget(currentEvents: widget.currentEvents, canDelete: widget.canDelete, loadEvents: widget.loadEvents,),
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
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      buildTopBar(),
                      EventListWidget(currentEvents: widget.currentEvents, canDelete: widget.canDelete, loadEvents: widget.loadEvents,),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Row buildTopBar() {
    return  Row(
              children: [
                  ElevatedButton(
                      onPressed: () async {
                        await showSimpleLoadingDialog(
                          context: context,
                          future: () async {
                            await widget.loadEvents(context);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Text('Reload'),
                          Icon(Icons.sync)
                        ],
                      )
                  ),


                  Expanded(child: SizedBox()),


                  IconButton(
                      onPressed: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FiltersPage(loadEvents: widget.loadEvents,),
                          ),
                        );
                      },
                      icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary, size: 30,)
                  ),
                ],
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

class FiltersPage extends StatefulWidget {
  final Function loadEvents;

  const FiltersPage({super.key, required this.loadEvents});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var appProvider = context.watch<AppProvider>();

    return Scaffold(
      body: Center(child: Text('Filters'))
    );
  }
}

class BookingDetailsPage extends StatefulWidget {
  final Function loadEvents;
  final Booking booking;

  const BookingDetailsPage({super.key, required this.loadEvents, required this.booking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources && appProvider.view_booking ?
    BookingDetails(booking: widget.booking, loadEvents: widget.loadEvents,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class BookingDetails extends StatefulWidget {
  final Booking booking;
  final Function loadEvents;
  const BookingDetails({
    super.key,
    required this.booking, required this.loadEvents
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState(booking: booking);
}

class _BookingDetailsState extends State<BookingDetails> {
  late Booking booking;


  _BookingDetailsState({required this.booking});


  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    DateTime start = widget.booking.start;
    String start_str = getDatePrintable(start, context)+'\n';
    start_str += getTimePrintable(start);

    DateTime end = widget.booking.end;
    String end_str = getDatePrintable(end, context)+'\n';
    end_str += getTimePrintable(end);
    double margin = 7;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView(
        children: [
          Text(
            widget.booking.resource_name,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          Text(
            'User Email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
          ),

          Text(
            widget.booking.user_email,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onPrimary),
          ),

          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                Card(
                  margin: EdgeInsets.all(margin),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: (widget.booking.status == 0) ? Theme.of(context).colorScheme.primary:
                  (widget.booking.status == 1) ? Theme.of(context).colorScheme.tertiary:
                  Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                        ),

                        if (widget.booking.status == 0) Text(
                          'Pending',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (widget.booking.status == 1) Text(
                          'Accepted',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (widget.booking.status == 2) Text(
                          'Refuzed',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(margin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Quantity',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                          ),

                          Text(
                            widget.booking.quantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.booking.validator_email != '') Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(margin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Validator Email',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                          ),

                          Text(
                            widget.booking.validator_email,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(margin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "From",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                          ),

                          Text(
                            start_str,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(margin),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "To",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                        ),

                        Text(
                          end_str,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.surface),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(margin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          if (widget.booking.is_resource_activity) Text(
                            "*From Resource",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                          ),

                          Text(
                            "Activity",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                          ),

                          OverflowTextAnimated(
                            text: widget.booking.activity_name,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.surface),
                            curve: Curves.easeInOut,
                            animation: OverFlowTextAnimations.scrollOpposite,
                            animateDuration: Duration(milliseconds: 2000),
                            delay: Duration(milliseconds: 500),
                            loopSpace: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(margin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          if (widget.booking.is_resource_place) Text(
                            "*From Resource",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                          ),

                          Text(
                            "Place",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                          ),

                          OverflowTextAnimated(
                            text: widget.booking.place_name,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.surface),
                            curve: Curves.easeInOut,
                            animation: OverFlowTextAnimations.scrollOpposite,
                            animateDuration: Duration(milliseconds: 2000),
                            delay: Duration(milliseconds: 500),
                            loopSpace: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.booking.status == 1)  SizedBox(height: 50,),

          if (widget.booking.status == 1)  Text(
            'Cancel this booking',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
          ),

          if (widget.booking.status == 1)  SizedBox(height: 10,),

          if (widget.booking.status == 1)  Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
            child: ElevatedButton(
              onPressed: () async {
                if(await confirm(context, content: Text("Cancel?"))){

                  if (await showSimpleLoadingDialog<bool>(
                    context: context,
                    future: () async {
                      bool result = await Connection.cancelBooking(appProvider, booking_id: widget.booking.id);

                      return result;
                    },
                  )){
                    await showSimpleLoadingDialog(
                      context: context,
                      future: () async {
                        await widget.loadEvents(context);
                      },
                    );
                    showTopMessage(context, "Booking Cancelled");
                    context.pop();
                  } else {
                    showTopMessage(context, "Error Occurred");
                  }
                }
              },
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )
                  ),
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)
              ),
            ),
          ),


          SizedBox(height: 30,),
        ],
      ),
    );
  }
}