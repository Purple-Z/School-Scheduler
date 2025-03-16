import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
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




class TypeDetailsPage extends StatefulWidget {
  const TypeDetailsPage({super.key});

  @override
  State<TypeDetailsPage> createState() => _TypeDetailsPageState();
}

class _TypeDetailsPageState extends State<TypeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var typeDetailsProvider = context.watch<TypeDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    TypeDetails(type: typeDetailsProvider.type,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class TypeDetails extends StatefulWidget {
  final List type;
  const TypeDetails({
    super.key,
    required this.type
  });

  @override
  State<TypeDetails> createState() => _TypeDetailsState(type: type);
}

class _TypeDetailsState extends State<TypeDetails> {
  List type = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  _TypeDetailsState({required this.type}){
    nameController.text = type[1];
    descriptionController.text = type[2];
  }


  @override
  Widget build(BuildContext context) {
    var typeDetailsProvider = context.watch<TypeDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.type_details_for,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  typeDetailsProvider.type[1],
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                buildTextField(nameController, AppLocalizations.of(context)!.type_name, Icons.person, editable: appProvider.edit_resources),
                SizedBox(height: fieldsSpacing),
                buildTextField(descriptionController, AppLocalizations.of(context)!.type_description, Icons.person, editable: appProvider.edit_resources),
                SizedBox(height: fieldsSpacing),


              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Column(
            children: [
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
                        await Connection.updateType(
                          appProvider,
                          type_id: typeDetailsProvider.type[0],
                          name: nameController.text,
                          description: descriptionController.text,
                        )
                        ){
                          showTopMessage(context, AppLocalizations.of(context)!.type_update_success);
                        } else {
                          showTopMessage(context, AppLocalizations.of(context)!.type_error_occurred);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.type_update_type,
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
                    if(await confirm(context, content: Text(AppLocalizations.of(context)!.type_delete_confirmation + " " + typeDetailsProvider.type[1] + "?"))){
                      if (await Connection.deleteType(typeDetailsProvider.type[0], appProvider)){
                        showTopMessage(context, AppLocalizations.of(context)!.type_delete_success);
                        context.pop();
                      } else {
                        showTopMessage(context, AppLocalizations.of(context)!.type_error_occurred);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.type_delete_type,
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
        ],
      ),
    );
  }
}