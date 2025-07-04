import 'package:client/app_provider.dart';
import 'package:client/main.dart';
import 'package:client/router/routes.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

import '../connection.dart';
import '../graphics/graphics_methods.dart';
import '../style/svgMappers.dart';
import 'functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'manage/classes.dart';
import 'manage/manage_page.dart';
import 'manage/resources/addResource/addResource_page.dart';
import 'manage/widgetsStates_provider.dart';

enum Filters {
  Pending,
  Accepted,
  Refused,
  Cancelled,
}


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
                            AppLocalizations.of(context)!.pending,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          if (event.status == 1) Text(
                            AppLocalizations.of(context)!.accepted,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.tertiary
                            ),
                          ),
                          if (event.status == 2) Text(
                            AppLocalizations.of(context)!.refused,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.secondary
                            ),
                          ),
                          if (event.status == 3) Text(
                            AppLocalizations.of(context)!.cancelled,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.secondary
                            ),
                          ),
                          if (event.status == 4) Text(
                            AppLocalizations.of(context)!.expired,
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
                          Text(
                            AppLocalizations.of(context)!.from_maiusc,
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
                          Text(
                            AppLocalizations.of(context)!.to_maiusc,
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
                                if(await confirm(context, content: Text(AppLocalizations.of(context)!.ask_to_cancel))){

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
                                    showTopMessage(context, AppLocalizations.of(context)!.booking_cancelled);
                                  } else {
                                    showTopMessage(context, AppLocalizations.of(context)!.error_occurred);
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.cancel,
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
                                      builder: (context) => BookingDetailsPage(loadEvents: widget.loadEvents, booking: event, candelete: widget.canDelete,),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.view,
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
  final String id;

  ResponsiveCalendarAndEvents({
    Key? key,
    required this.appProvider,
    required this.currentEvents,
    required this.events,
    required this.canDelete,
    required this.loadEvents,
    required this.id,
  }) : super(key: key);



  @override
  State<ResponsiveCalendarAndEvents> createState() => _ResponsiveCalendarAndEventsState();
}

class _ResponsiveCalendarAndEventsState extends State<ResponsiveCalendarAndEvents> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  resetFilters(WidgetStatesProvider widgetProvider) async {
    widgetProvider.setState(widget.id, {});
  }

  List<Booking> _getEventsForDay(WidgetStatesProvider widgetProvider, DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);

    //print(widget.events.toString());
    //print((widget.events[normalizedDay] ?? []).toString());

    List<Booking> day_bookings = widget.events[normalizedDay] ?? [];

    List<Booking> final_day_booking = [];

    if (widgetProvider.states[widget.id] == null) {
      resetFilters(widgetProvider);
      return [];
    }

    for (Booking b in day_bookings){
      if (widgetProvider.states[widget.id].containsKey('time_range')){

        if  ((!(
              (
                (b.start.hour == widgetProvider.states[widget.id]['time_range'][1] && b.start.minute > 0) ||
                (b.start.hour > widgetProvider.states[widget.id]['time_range'][1])
              )
            &&
              (
                (b.end.hour == widgetProvider.states[widget.id]['time_range'][1] && b.end.minute > 0) ||
                (b.end.hour > widgetProvider.states[widget.id]['time_range'][1])
              )
            )
            )

            &&

            (!(
            (
                (b.start.hour < widgetProvider.states[widget.id]['time_range'][0])
            )
            &&
              (
                (b.end.hour < widgetProvider.states[widget.id]['time_range'][0])
              )
            )
          )
        ){
          final_day_booking.add(b);
        }
      } else {
        final_day_booking.add(b);
      }
    }

    day_bookings = final_day_booking;
    final_day_booking = [];

    for (Booking b in day_bookings){
      if (widgetProvider.states[widget.id].containsKey('users')){
        if (widgetProvider.states[widget.id]['users'].contains(b.user_email)){
          final_day_booking.add(b);
        }
      } else {
        final_day_booking.add(b);
      }
    }

    day_bookings = final_day_booking;
    final_day_booking = [];

    for (Booking b in day_bookings){
      if (widgetProvider.states[widget.id].containsKey('resources')){
        if (widgetProvider.states[widget.id]['resources'].contains(b.resource_name)){
          final_day_booking.add(b);
        }
      } else {
        final_day_booking.add(b);
      }
    }

    day_bookings = final_day_booking;
    final_day_booking = [];

    for (Booking b in day_bookings){
      if (widgetProvider.states[widget.id].containsKey('places')){
        if (widgetProvider.states[widget.id]['places'].contains(b.place_name)){
          final_day_booking.add(b);
        }
      } else {
        final_day_booking.add(b);
      }
    }

    day_bookings = final_day_booking;
    final_day_booking = [];


    for (Booking b in day_bookings){
      if (widgetProvider.states[widget.id].containsKey('activities')){
        if (widgetProvider.states[widget.id]['activities'].contains(b.activity_name)){
          final_day_booking.add(b);
        }
      } else {
        final_day_booking.add(b);
      }
    }

    day_bookings = final_day_booking;
    final_day_booking = [];


    for (Booking b in day_bookings){
      if (widgetProvider.states[widget.id].containsKey('quantity_range')){
        if ((widgetProvider.states[widget.id]['quantity_range'][0] <= b.quantity) && (widgetProvider.states[widget.id]['quantity_range'][1] >= b.quantity)){
          final_day_booking.add(b);
        }
      } else {
        final_day_booking.add(b);
      }
    }

    return final_day_booking;
  }


  @override
  Widget build(BuildContext context) {
    var widgetProvider = context.watch<WidgetStatesProvider>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < widget.appProvider.maxWidth) {
          return SingleChildScrollView(
            child: Column(
              children: [
                buildTopBar(widgetProvider),
                buildTableCalendar(widgetProvider),
                SizedBox(height: 30),
                EventListWidget(currentEvents: widget.currentEvents, canDelete: widget.canDelete, loadEvents: widget.loadEvents,),
                if (widget.currentEvents.length == 0) buildSvgNoBookings(),
              ],
            ),
          );
        } else {
          return Row(
            children: [
              Expanded(child: buildTableCalendar(widgetProvider)),
              SizedBox(width: 30),
              Expanded(
                child: (widget.currentEvents.length != 0) ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      buildTopBar(widgetProvider),
                      EventListWidget(currentEvents: widget.currentEvents, canDelete: widget.canDelete, loadEvents: widget.loadEvents,),
                    ],
                  ),
                ) : Column(
                  children: [
                    SizedBox(height: 20,),
                    buildTopBar(widgetProvider),
                    Expanded(
                      child: buildSvgNoBookings(),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }




  SvgPicture buildSvgNoBookings() {
    return SvgPicture.asset(
                      'assets/images/undraw_dreamer_gb41.svg',
                      width: 150,
                      height: 150,
                      colorMapper: CustomColorMapper(context),
                    );
  }

  Row buildTopBar(WidgetStatesProvider widgetProvider) {
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
                          Text(AppLocalizations.of(context)!.reload),
                          Icon(Icons.sync)
                        ],
                      )
                  ),


                  Expanded(child: SizedBox()),


                  IconButton(
                      onPressed: () async {

                        double start = 0;
                        double end =  24;
                        if (widgetProvider.states[widget.id].containsKey('time_range')){
                          start = widgetProvider.states[widget.id]['time_range'][0] as double;
                          end = widgetProvider.states[widget.id]['time_range'][1] as double;
                        }

                        List<Booking> all_bookings = [];

                        for (var day in widget.events.keys){
                          all_bookings = all_bookings + widget.events[day]!;
                        }

                        List users = [];
                        for (Booking b in all_bookings){
                          if (!users.contains(b.user_email)){
                            users.add(b.user_email);
                          }
                        }

                        for (int i = 0; i < users.length; i++){
                          bool fb = true;
                          if (widgetProvider.states[widget.id].containsKey('users')){
                            if (!widgetProvider.states[widget.id]['users'].contains(users[i])){
                              fb = false;
                            }
                          }
                          users[i] = [users[i], fb];
                        }


                        List resources = [];
                        for (Booking b in all_bookings){
                          if (!resources.contains(b.resource_name)){
                            resources.add(b.resource_name);
                          }
                        }

                        for (int i = 0; i < resources.length; i++){
                          bool fb = true;
                          if (widgetProvider.states[widget.id].containsKey('resources')){
                            if (!widgetProvider.states[widget.id]['resources'].contains(resources[i])){
                              fb = false;
                            }
                          }
                          resources[i] = [resources[i], fb];
                        }

                        List places = [];
                        for (Booking b in all_bookings){
                          if (!places.contains(b.place_name)){
                            places.add(b.place_name);
                          }
                        }

                        for (int i = 0; i < places.length; i++){
                          bool fb = true;
                          if (widgetProvider.states[widget.id].containsKey('places')){
                            if (!widgetProvider.states[widget.id]['places'].contains(places[i])){
                              fb = false;
                            }
                          }
                          places[i] = [places[i], fb];
                        }

                        List activities = [];
                        for (Booking b in all_bookings){
                          if (!activities.contains(b.activity_name)){
                            activities.add(b.activity_name);
                          }
                        }

                        for (int i = 0; i < activities.length; i++){
                          bool fb = true;
                          if (widgetProvider.states[widget.id].containsKey('activities')){
                            if (!widgetProvider.states[widget.id]['activities'].contains(activities[i])){
                              fb = false;
                            }
                          }
                          activities[i] = [activities[i], fb];
                        }

                        int absolute_min = all_bookings[0].quantity;
                        int absolute_max = all_bookings[0].quantity;

                        for (Booking b in all_bookings){
                          if (absolute_min > b.quantity){
                            absolute_min = b.quantity;
                          } else if (absolute_max < b.quantity){
                            absolute_max = b.quantity;
                          }
                        }

                        int quantity_min = absolute_min;
                        int quantity_max = absolute_max;

                        if (widgetProvider.states[widget.id].containsKey('quantity_range')){
                          quantity_min = widgetProvider.states[widget.id]['quantity_range'][0].toInt();
                          quantity_max = widgetProvider.states[widget.id]['quantity_range'][1].toInt();
                        }

                        print('min/max: '+ absolute_min.toString() + ', ' + absolute_max.toString());



                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FiltersPage(
                              loadEvents: widget.loadEvents,
                              start_time: start,
                              end_time: end,
                              users: users,
                              resources: resources,
                              places: places,
                              activities: activities,
                              absolute_min: absolute_min,
                              absolute_max: absolute_max,
                              quantity_min: quantity_min.toDouble(),
                              quantity_max: quantity_max.toDouble(),
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            widgetProvider.setState(widget.id, result);
                            widget.currentEvents = _getEventsForDay(widgetProvider, _selectedDay ?? DateTime.now());
                          });
                        }
                      },
                      icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary, size: 30,)
                  ),
                ],
              );
  }

  TableCalendar<Booking> buildTableCalendar(WidgetStatesProvider widgetProvider) {
    return TableCalendar<Booking>(
      firstDay: DateTime(2010, 10, 16),
      lastDay: DateTime(2030, 3, 14),
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          setState(() {
            widget.currentEvents = _getEventsForDay(widgetProvider, _selectedDay ?? DateTime.now());
            //widget.currentEvents = _getEventsForDay(DateTime(2025, 04, 14));
          });
          //widget.manageBookingsProvider.setCurrentEvents(_getEventsForDay(_selectedDay ?? DateTime.now()));
        });
      },
      locale: widget.appProvider.locale.toLanguageTag(),
      eventLoader: (day) {
        return _getEventsForDay(widgetProvider, day);
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
  List users;
  List resources;
  List places;
  List activities;
  int absolute_min;
  int absolute_max;
  late SfRangeValues time_slider_values;
  late SfRangeValues quantity_slider_values;

  FiltersPage({
  super.key,
  required this.loadEvents,
  required double start_time,
  required double end_time,
  required double quantity_min,
  required double quantity_max,
  required this.users,
  required this.resources,
  required this.places,
  required this.activities,
  required this.absolute_min,
  required this.absolute_max
  }){
    this.time_slider_values = SfRangeValues(start_time, end_time);
    this.quantity_slider_values = SfRangeValues(quantity_min, quantity_max);
  }

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  Set<Filters> selectedFilters = <Filters>{};

  @override
  void initState() {
    super.initState();
    selectedFilters.add(Filters.Accepted);
    selectedFilters.add(Filters.Pending);
    selectedFilters.add(Filters.Refused);
    selectedFilters.add(Filters.Cancelled);
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.filters,
                          style: TextStyle(fontSize: 30),
                        ),
                        Expanded(child: SizedBox())
                      ],
                    ),
                    SizedBox(height: 20,),


                    if (1 != 1) SegmentedButton<Filters>(
                      multiSelectionEnabled: true,
                      segments: <ButtonSegment<Filters>>[
                        ButtonSegment<Filters>(
                            value: Filters.Accepted,
                            label: Text(
                              AppLocalizations.of(context)!.accepted,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            )),
                        ButtonSegment<Filters>(
                            value: Filters.Pending,
                            label: Text(
                              AppLocalizations.of(context)!.pending,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            )),
                        ButtonSegment<Filters>(
                            value: Filters.Refused,
                            label: Text(
                              AppLocalizations.of(context)!.refused,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            )),
                        ButtonSegment<Filters>(
                            value: Filters.Cancelled,
                            label: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            )),
                      ],
                      selected: selectedFilters,
                      onSelectionChanged: (Set<Filters> newSelection) {
                        setState(() {
                          selectedFilters = newSelection;
                          print('Filtri selezionati: $selectedFilters');
                        });
                      },
                    ),


                    Text(
                      AppLocalizations.of(context)!.time_range,
                      style: TextStyle(fontSize: 20),
                    ),
                    SfRangeSlider(
                      min: 0,
                      max: 24,
                      values: widget.time_slider_values,
                      interval: 6,
                      showTicks: false,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 5,
                      stepSize: 1,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (SfRangeValues values){
                        setState(() {
                          widget.time_slider_values = values;
                        });
                      },
                    ),

                    SizedBox(height: 40,),

                    Text(
                      AppLocalizations.of(context)!.quantity_range,
                      style: TextStyle(fontSize: 20),
                    ),
                    SfRangeSlider(
                      min: widget.absolute_min,
                      max: widget.absolute_max,
                      values: widget.quantity_slider_values,
                      interval: 5,
                      showTicks: false,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 5,
                      stepSize: 1,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (SfRangeValues values){
                        setState(() {
                          widget.quantity_slider_values = values;
                        });
                      },
                    ),

                    SizedBox(height: 40,),

                    Row(
                      children: [
                        OptionButton(
                          child: Text(
                            AppLocalizations.of(context)!.people,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          onTap: () async {
                            List<SelectedListItem<ListItem>> selections = [];
                            for (List user in widget.users){
                              selections.add(SelectedListItem<ListItem>(
                                  data: ListItem(
                                    display: (user[0]),
                                    value: user[0],
                                  ),
                                  isSelected: user.last
                              ));
                            }
                            DropDownState<ListItem>(
                              dropDown: DropDown<ListItem>(
                                enableMultipleSelection: true,
                                data: selections,
                                onSelected: (selectedItems) {
                                  List<String> list = [];
                                  for (var item in selectedItems) {
                                    list.add(item.data.value);
                                  }

                                  setState(() {

                                    for (List user in widget.users){
                                      String user_email = user[0];
                                      if (list.contains(user_email)){
                                        user[user.length-1] = true;
                                      } else {
                                        user[user.length-1] = false;
                                      }
                                    }
                                  });
                                },
                              ),
                            ).showModal(context);
                          },
                        ),
                        Expanded(
                          child: OptionButton(
                            child: Text(
                              AppLocalizations.of(context)!.resources,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onTap: ()  async {
                              List<SelectedListItem<ListItem>> selections = [];
                              for (List resource in widget.resources){
                                selections.add(SelectedListItem<ListItem>(
                                    data: ListItem(
                                      display: (resource[0]),
                                      value: resource[0],
                                    ),
                                    isSelected: resource.last
                                ));
                              }
                              DropDownState<ListItem>(
                                dropDown: DropDown<ListItem>(
                                  enableMultipleSelection: true,
                                  data: selections,
                                  onSelected: (selectedItems) {
                                    List<String> list = [];
                                    for (var item in selectedItems) {
                                      list.add(item.data.value);
                                    }
                          
                                    setState(() {
                          
                                      for (List resource in widget.resources){
                                        String resource_name = resource[0];
                                        if (list.contains(resource_name)){
                                          resource[resource.length-1] = true;
                                        } else {
                                          resource[resource.length-1] = false;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ).showModal(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OptionButton(
                            child: Text(
                              AppLocalizations.of(context)!.activities,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onTap: () async {
                              List<SelectedListItem<ListItem>> selections = [];
                              for (List activity in widget.activities){
                                selections.add(SelectedListItem<ListItem>(
                                    data: ListItem(
                                      display: (activity[0]),
                                      value: activity[0],
                                    ),
                                    isSelected: activity.last
                                ));
                              }
                              DropDownState<ListItem>(
                                dropDown: DropDown<ListItem>(
                                  enableMultipleSelection: true,
                                  data: selections,
                                  onSelected: (selectedItems) {
                                    List<String> list = [];
                                    for (var item in selectedItems) {
                                      list.add(item.data.value);
                                    }

                                    setState(() {

                                      for (List activity in widget.activities){
                                        String activity_name = activity[0];
                                        if (list.contains(activity_name)){
                                          activity[activity.length-1] = true;
                                        } else {
                                          activity[activity.length-1] = false;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ).showModal(context);
                            },
                          ),
                        ),
                        OptionButton(
                          child: Text(
                            AppLocalizations.of(context)!.places,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          onTap: () async {
                            List<SelectedListItem<ListItem>> selections = [];
                            for (List place in widget.places){
                              selections.add(SelectedListItem<ListItem>(
                                  data: ListItem(
                                    display: (place[0]),
                                    value: place[0],
                                  ),
                                  isSelected: place.last
                              ));
                            }
                            DropDownState<ListItem>(
                              dropDown: DropDown<ListItem>(
                                enableMultipleSelection: true,
                                data: selections,
                                onSelected: (selectedItems) {
                                  List<String> list = [];
                                  for (var item in selectedItems) {
                                    list.add(item.data.value);
                                  }

                                  setState(() {

                                    for (List resource in widget.places){
                                      String place_name = resource[0];
                                      if (list.contains(place_name)){
                                        resource[resource.length-1] = true;
                                      } else {
                                        resource[resource.length-1] = false;
                                      }
                                    }
                                  });
                                },
                              ),
                            ).showModal(context);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 40,),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                _cancelFilters();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)
                              ),
                          ),
                        ),

                        SizedBox(width: 15,),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilters();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.apply,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  void _applyFilters() {
    List<String> users = [];
    for (List user in widget.users){
      String user_email = user[0];
      if (user[user.length-1] == true){
        users.add(user_email);
      }
    }

    List<String> resources = [];
    for (List resource in widget.resources){
      String resource_name = resource[0];
      if (resource[resource.length-1] == true){
        resources.add(resource_name);
      }
    }

    List<String> places = [];
    for (List place in widget.places){
      String place_name = place[0];
      if (place[place.length-1] == true){
        places.add(place_name);
      }
    }

    List<String> activities = [];
    for (List activity in widget.activities){
      String activity_name = activity[0];
      if (activity[activity.length-1] == true){
        activities.add(activity_name);
      }
    }

    Map<String, dynamic> filtersResult = {
      'time_range': [widget.time_slider_values.start, widget.time_slider_values.end],
      'users': users,
      'resources': resources,
      'places': places,
      'activities': activities,
      'quantity_range': [widget.quantity_slider_values.start, widget.quantity_slider_values.end],
    };
    Navigator.pop(context, filtersResult);
  }


  void _cancelFilters() {
    Navigator.pop(context, null);
  }
}

class BookingDetailsPage extends StatefulWidget {
  final Function loadEvents;
  final Booking booking;
  final bool candelete;

  const BookingDetailsPage({super.key, required this.loadEvents, required this.booking, required this.candelete});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources && appProvider.view_booking ?
    BookingDetails(booking: widget.booking, loadEvents: widget.loadEvents, canDelete: widget.candelete,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class BookingDetails extends StatefulWidget {
  final Booking booking;
  final Function loadEvents;
  final bool canDelete;
  const BookingDetails({
    super.key,
    required this.booking, required this.loadEvents, required this.canDelete
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
            AppLocalizations.of(context)!.user,
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
                          AppLocalizations.of(context)!.status,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                        ),

                        if (widget.booking.status == 0) Text(
                          AppLocalizations.of(context)!.pending,
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (widget.booking.status == 1) Text(
                          AppLocalizations.of(context)!.accepted,
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (widget.booking.status == 2) Text(
                          AppLocalizations.of(context)!.refused,
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (widget.booking.status == 3) Text(
                          AppLocalizations.of(context)!.cancelled,
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (widget.booking.status == 4) Text(
                          AppLocalizations.of(context)!.expired,
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
                            AppLocalizations.of(context)!.quantity,
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
                            AppLocalizations.of(context)!.validator_email,
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
                            AppLocalizations.of(context)!.from_maiusc,
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
                          AppLocalizations.of(context)!.to_maiusc,
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
                            "*" + AppLocalizations.of(context)!.from_resource,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                          ),

                          Text(
                            AppLocalizations.of(context)!.activity,
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
                            "*" + AppLocalizations.of(context)!.from_resource,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                          ),

                          Text(
                            AppLocalizations.of(context)!.place,
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

          if ((widget.booking.status == 1) && widget.canDelete)  SizedBox(height: 50,),

          if ((widget.booking.status == 1) && widget.canDelete)  Text(
            AppLocalizations.of(context)!.cancel_this_booking,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
          ),

          if ((widget.booking.status == 1) && widget.canDelete)  SizedBox(height: 10,),

          if ((widget.booking.status == 1) && widget.canDelete)  Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
            child: ElevatedButton(
              onPressed: () async {
                if(await confirm(context, content: Text(AppLocalizations.of(context)!.ask_to_cancel))){

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
                    showTopMessage(context, AppLocalizations.of(context)!.booking_cancelled);
                    context.pop();
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.error_occurred);
                  }
                }
              },
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text(
                    AppLocalizations.of(context)!.cancel,
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