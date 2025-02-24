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
    Text("access denied!");
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


  Future<DateTime?> _selectDate(DateTime initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );


    if (pickedDate != null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialDate.hour,
        initialDate.minute,
      );
    }

    return null;
  }

  Future<DateTime?> _selectTime(DateTime initialDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime != null) {
      return DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    return null;
  }

  String getTimePrintable(DateTime currTime){
    String out = '';
    out += currTime.hour.toString();
    out += ':';
    if (currTime.minute < 10) {
      out += '0';
    }
    out += currTime.minute.toString();

    return out;
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
            const Text(
              "Availability for",
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
                      "Start availability",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      onPressed: () async {
                        DateTime? pickedDate = await _selectDate(startDate);

                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        '${startDate.year}/${startDate.month}/${startDate.day}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      onPressed: () async {
                        DateTime? pickedDate = await _selectTime(startDate);

                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
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
                      "End availability",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      onPressed: () async {
                        DateTime? pickedDate = await _selectDate(endDate);

                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        '${endDate.year}/${endDate.month}/${endDate.day}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      onPressed: () async {
                        DateTime? pickedDate = await _selectTime(endDate);

                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
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
              'Max availability, ' + maxAvailabilityValue.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            SizedBox(height: 5),
            buildTextField(quantityController, "Quantity", Icons.person, editable: appProvider.edit_user, inputType: TextInputType.numberWithOptions()),
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
                      "Check Quantity",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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
                        if (
                        await Connection.updateAvailability(
                            appProvider,
                            availability_id: availabilityDetailsProvider.availability[0],
                            start: startDate,
                            end: endDate,
                            quantity: int.tryParse(quantityController.text) ?? 0
                        )
                        ){
                          showTopMessage(context, "Availability Updated!");
                        } else {
                          showTopMessage(context, "Error Occurred!");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Update Availability",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                      backgroundColor: WidgetStatePropertyAll(Color(0xFFB00020)),
                      textStyle: WidgetStatePropertyAll(
                          TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary
                          )
                      )
                  ),
                  onPressed: () async {
                    if(await confirm(context, content: Text("Delete availability?"))){
                      if (await Connection.deleteAvailability(
                          availabilityDetailsProvider.availability[0],
                          appProvider
                      )){
                        showTopMessage(context, "Availability deleted");
                        context.pop();
                      } else {
                        showTopMessage(context, "Error Occurred");
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Delete Availability",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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