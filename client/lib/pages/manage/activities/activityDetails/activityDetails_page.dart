import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/activities/activityDetails/activityDetails_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/places/placeDetails/placeDetails_provider.dart';
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




class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({super.key});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var activityDetailsProvider = context.watch<ActivityDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ActivityDetails(activity: activityDetailsProvider.activity,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ActivityDetails extends StatefulWidget {
  final List activity;
  const ActivityDetails({
    super.key,
    required this.activity
  });

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState(activity: activity);
}

class _ActivityDetailsState extends State<ActivityDetails> {
  List activity = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  _ActivityDetailsState({required this.activity}){
    nameController.text = activity[1];
    descriptionController.text = activity[2];
  }


  @override
  Widget build(BuildContext context) {
    var activityDetailsProvider = context.watch<ActivityDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          Text(
            AppLocalizations.of(context)!.activity_details_for,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            activityDetailsProvider.activity[1],
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          buildTextField(nameController, AppLocalizations.of(context)!.activity_name, Icons.person, editable: appProvider.edit_resources),
          SizedBox(height: fieldsSpacing),
          buildTextField(descriptionController, AppLocalizations.of(context)!.activity_description, Icons.person, editable: appProvider.edit_resources),
          SizedBox(height: fieldsSpacing),


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
                    await Connection.updateActivity(
                      appProvider,
                      activity_id: activityDetailsProvider.activity[0],
                      name: nameController.text,
                      description: descriptionController.text,
                    )
                    ){
                      showTopMessage(context, AppLocalizations.of(context)!.activity_update_success);
                    } else {
                      showTopMessage(context, AppLocalizations.of(context)!.activity_error_occurred);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.activity_update_activity,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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
                  backgroundColor: WidgetStatePropertyAll(Color(0xFFB00020)),
                  textStyle: WidgetStatePropertyAll(
                      TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                      )
                  )
              ),
              onPressed: () async {
                if(await confirm(context, content: Text(AppLocalizations.of(context)!.activity_delete_confirmation + " " + activityDetailsProvider.activity[1] + "?"))){
                  if (await Connection.deleteActivity(activityDetailsProvider.activity[0], appProvider)){
                    showTopMessage(context, AppLocalizations.of(context)!.activity_delete_success);
                    context.pop();
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.activity_error_occurred);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.activity_delete_activity,
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
    );
  }
}