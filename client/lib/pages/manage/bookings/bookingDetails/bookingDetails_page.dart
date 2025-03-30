import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/bookings/bookingDetails/bookingDetails_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_page.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/requests/requestDetails/requestDetails_provider.dart';
import 'package:client/pages/manage/types/typeDetails/typeDetails_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:client/graphics/graphics_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../functions.dart';
import '../../classes.dart';




class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var bookingDetailsProvider = context.watch<BookingDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources && appProvider.view_booking ?
    BookingDetails(booking: bookingDetailsProvider.booking,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class BookingDetails extends StatefulWidget {
  final Booking booking;
  const BookingDetails({
    super.key,
    required this.booking
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState(booking: booking);
}

class _BookingDetailsState extends State<BookingDetails> {
  late Booking booking;


  _BookingDetailsState({required this.booking});


  @override
  Widget build(BuildContext context) {
    var bookingDetailsProvider = context.watch<BookingDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    DateTime start = bookingDetailsProvider.booking.start;
    String start_str = '${start.year}/${start.month}/${start.day}\n';
    start_str += getTimePrintable(start);

    DateTime end = bookingDetailsProvider.booking.end;
    String end_str = '${end.year}/${end.month}/${end.day}\n';
    end_str += getTimePrintable(end);
    double margin = 7;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView(
        children: [
          Text(
            bookingDetailsProvider.booking.resource_name,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          Text(
            'User Email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
          ),

          Text(
            bookingDetailsProvider.booking.user_email,
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
                  color: (bookingDetailsProvider.booking.status == 0) ? Theme.of(context).colorScheme.primary:
                  (bookingDetailsProvider.booking.status == 1) ? Theme.of(context).colorScheme.tertiary:
                  Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                        ),

                        if (bookingDetailsProvider.booking.status == 0) Text(
                          'Pending',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (bookingDetailsProvider.booking.status == 1) Text(
                          'Accepted',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.surface
                          ),
                        ),
                        if (bookingDetailsProvider.booking.status == 2) Text(
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
                            bookingDetailsProvider.booking.quantity.toString(),
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

          if (bookingDetailsProvider.booking.validator_email != '') Padding(
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
                            bookingDetailsProvider.booking.validator_email,
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
                          if (bookingDetailsProvider.booking.is_resource_activity) Text(
                            "*From Resource",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                          ),

                          Text(
                            "Activity",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                          ),

                          Text(
                            bookingDetailsProvider.booking.activity_name,
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
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        if (bookingDetailsProvider.booking.is_resource_place) Text(
                          "*From Resource",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                        ),

                        Text(
                          "Place",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
                        ),

                        Text(
                          bookingDetailsProvider.booking.place_name,
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



          SizedBox(height: 30,),
        ],
      ),
    );
  }
}