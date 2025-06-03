import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/availabilityDetails/availabilityDetails_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:client/graphics/graphics_methods.dart';
import 'package:client/pages/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




class AvailabilityDetailsPage extends StatefulWidget {
  const AvailabilityDetailsPage({super.key});

  @override
  State<AvailabilityDetailsPage> createState() => _AvailabilityDetailsPageState();
}

class _AvailabilityDetailsPageState extends State<AvailabilityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var availabilityDetailsProvider = context.watch<AvailabilityDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_availability ?
    AvailabilityDetails(availability: availabilityDetailsProvider.availability,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class AvailabilityDetails extends StatefulWidget {
  final List availability;
  const AvailabilityDetails({
    super.key,
    required this.availability
  });

  @override
  State<AvailabilityDetails> createState() => _AvailabilityDetailsState(availability: availability);
}

class _AvailabilityDetailsState extends State<AvailabilityDetails> {
  List availability = [];
  List resource = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int maxAvailabilityValue = 0;
  bool maxAvailabilityShow = false;

  final TextEditingController quantityController = TextEditingController();


  _AvailabilityDetailsState({required this.availability}){
    quantityController.text = availability[3].toString();
    print(availability[1]);
    startDate = DateTime.tryParse(availability[1]) ?? DateTime.now();
    endDate = DateTime.tryParse(availability[2]) ?? DateTime.now();
  }


  @override
  Widget build(BuildContext context) {
    var availabilityDetailsProvider = context.watch<AvailabilityDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.availability_availability_for,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              availabilityDetailsProvider.resource[1],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.availability_start_availability,
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0)), backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                      onPressed: appProvider.edit_availability ? () async {
                        DateTime? pickedDate = await selectDate(context, startDate);

                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      } : null,
                      child: Text(
                        '${startDate.year}/${startDate.month}/${startDate.day}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0)), backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                      onPressed: appProvider.edit_availability ? () async {
                        DateTime? pickedDate = await selectTime(context, startDate);

                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      } : null,
                      child: Text(
                        getTimePrintable(startDate),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
              ],
            ),

            SizedBox(height: 20,),

            Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.availability_end_availability,
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0)), backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                      onPressed: appProvider.edit_availability ? () async {
                        DateTime? pickedDate = await selectDate(context, endDate);

                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      } : null,
                      child: Text(
                        '${endDate.year}/${endDate.month}/${endDate.day}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0)), backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                      onPressed: appProvider.edit_availability ? () async {
                        DateTime? pickedDate = await selectTime(context, endDate);

                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      } : null,
                      child: Text(
                        getTimePrintable(endDate),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
              ],
            ),

            SizedBox(height: fieldsSpacing),

            if (maxAvailabilityShow) Text(
              AppLocalizations.of(context)!.availability_max_availability + ', ' + maxAvailabilityValue.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            SizedBox(height: 5),
            buildTextField(quantityController, AppLocalizations.of(context)!.availability_quantity, Icons.person, editable: appProvider.edit_availability, inputType: TextInputType.numberWithOptions()),
            SizedBox(height: fieldsSpacing),

            if (appProvider.view_availability)
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                      textStyle: WidgetStatePropertyAll(
                          TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary
                          )
                      )
                  ),
                  onPressed: () async {
                    int quantity = await showSimpleLoadingDialog<int>(
                      context: context,
                      future: () async {
                        int quantity = await Connection.checkAvailabilityQuantity(appProvider,
                            resource_id: availabilityDetailsProvider.resource[0],
                            start: startDate,
                            end: endDate,
                            remove_availability_id: availabilityDetailsProvider.availability[0]
                        );

                        return quantity;
                      },
                    );

                    setState(() {
                      maxAvailabilityValue = quantity;
                      maxAvailabilityShow = true;
                    });
                    print(quantity);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.availability_check_quantity,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (appProvider.edit_availability)
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary
                              )
                          )
                      ),
                      onPressed: () async {
                        switch (await Connection.updateAvailability(
                            appProvider,
                            availability_id: availabilityDetailsProvider.availability[0],
                            start: startDate,
                            end: endDate,
                            quantity: int.tryParse(quantityController.text) ?? 0
                        )) {
                          case 0:
                            showTopMessage(context, AppLocalizations.of(context)!.availability_update_success);
                            break;

                          case 1:
                            showTopMessage(context, "Can't update availability.\nTry remove some bookings", isOK: false);
                            break;

                          case 2:
                            showTopMessage(context, AppLocalizations.of(context)!.availability_error_occurred);
                            break;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.availability_update_availability,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),

            if (appProvider.delete_availability)
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                      textStyle: WidgetStatePropertyAll(
                          TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary
                          )
                      )
                  ),
                  onPressed: () async {
                    if(await confirm(context, content: Text(AppLocalizations.of(context)!.availability_delete_confirmation))){
                      switch (await Connection.deleteAvailability(
                          availabilityDetailsProvider.availability[0],
                          appProvider
                      )) {
                        case 0:
                          showTopMessage(context, AppLocalizations.of(context)!.availability_delete_success);
                          context.pop();
                          break;

                        case 1:
                          showTopMessage(context, "Can't delete availability.\nTry remove some bookings", isOK: false);
                          break;

                        case 2:
                          showTopMessage(context, AppLocalizations.of(context)!.availability_error_occurred);
                          break;
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.availability_delete_availability,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}