import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
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




class RequestDetailsPage extends StatefulWidget {
  const RequestDetailsPage({super.key});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var requestDetailsProvider = context.watch<RequestDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources && appProvider.view_booking ?
    RequestDetails(request: requestDetailsProvider.request,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class RequestDetails extends StatefulWidget {
  final List request;
  const RequestDetails({
    super.key,
    required this.request
  });

  @override
  State<RequestDetails> createState() => _RequestDetailsState(request: request);
}

class _RequestDetailsState extends State<RequestDetails> {
  List request = [];


  _RequestDetailsState({required this.request});


  @override
  Widget build(BuildContext context) {
    var requestDetailsProvider = context.watch<RequestDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    DateTime start = DateTime.tryParse(requestDetailsProvider.request[1]) ?? DateTime.now();
    String start_str = getDatePrintable(start, context)+'\n';
    start_str += getTimePrintable(start);

    DateTime end = DateTime.tryParse(requestDetailsProvider.request[2]) ?? DateTime.now();
    String end_str = getDatePrintable(end, context)+'\n';
    end_str += getTimePrintable(end);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          Text(
            AppLocalizations.of(context)!.request_details_from,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            requestDetailsProvider.request[4],
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          Row(
            children: [

              Expanded(child: SizedBox()),

              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.from_maiusc,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    start_str,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),

              Expanded(child: SizedBox()),

              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.to_maiusc,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    end_str,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),

              Expanded(child: SizedBox()),

            ],
          ),




          SizedBox(height: 30,),




          Row(
            children: [

              Expanded(child: SizedBox()),

              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.quantity,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    requestDetailsProvider.request[3].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),

              Expanded(child: SizedBox()),

              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.type,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    requestDetailsProvider.request[5],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),

              Expanded(child: SizedBox()),

            ],
          ),


          SizedBox(height: 25),



          if (appProvider.edit_resources) Column(
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
                    await Connection.acceptPendingBookings(appProvider, request_id: requestDetailsProvider.request[0])
                    ){
                      showTopMessage(context, AppLocalizations.of(context)!.request_accepted);
                      context.pop();
                    } else {
                      showTopMessage(context, AppLocalizations.of(context)!.type_error_occurred);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.accept,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10,),
            ],
          ),

          if (appProvider.delete_resources) Center(
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
                if(await confirm(context, content: Text(AppLocalizations.of(context)!.ask_for_refuse))){
                  if (await Connection.refusePendingBookings(appProvider, request_id: requestDetailsProvider.request[0])){
                    showTopMessage(context, AppLocalizations.of(context)!.request_refused);
                    context.pop();
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.type_error_occurred);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.refuse,
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
    );
  }
}