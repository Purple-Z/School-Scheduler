import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/resources/addResource/addResource_provider.dart';
import 'package:client/pages/resources/resourceDetails/addAvailability/addAvailability_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:client/graphics/graphics_methods.dart';


class AddAvailabilityPage extends StatefulWidget {
  const AddAvailabilityPage({super.key});

  @override
  State<AddAvailabilityPage> createState() => _AddAvailabilityPageState();
}

class _AddAvailabilityPageState extends State<AddAvailabilityPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var addAvailabilityProvider = context.watch<AddAvailabilityProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.create_availability ?
    AddAvailability():
    Text("access denied!");
  }
}

class AddAvailability extends StatefulWidget {
  const AddAvailability({super.key});

  @override
  State<AddAvailability> createState() => _AddAvailabilityState();
}

class _AddAvailabilityState extends State<AddAvailability> {
  final TextEditingController quantityController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int maxAvailabilityValue = 0;
  bool maxAvailabilityShow = false;

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
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double fieldsSpacing = 15;
    var appProvider = context.watch<AppProvider>();
    var addAvailabilityProvider = context.watch<AddAvailabilityProvider>();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Availability for",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              '"' + addAvailabilityProvider.resource[1] + '"',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
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
            buildTextField(quantityController, "Quantity", Icons.person_outline, inputType: TextInputType.number),
            const SizedBox(height: 30),
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
                          resource_id: addAvailabilityProvider.resource[0],
                          start: startDate,
                          end: endDate
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

            SizedBox(height: 10,),

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
                  if (await Connection.addAvailability(
                      start: startDate,
                      end: endDate,
                      quantity: int.tryParse(quantityController.text) ?? 0,
                      resource_id: addAvailabilityProvider.resource[0],
                      appProvider: appProvider
                  )){
                    showTopMessage(context, "Availability Created!");
                    context.pop();
                  } else {
                    showTopMessage(context, "Error Occurred!");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add Availability",
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
