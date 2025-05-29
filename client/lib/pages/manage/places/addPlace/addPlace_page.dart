import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/addType/addType_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:client/graphics/graphics_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.create_resources ?
    AddPlace():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double fieldsSpacing = 15;
    var appProvider = context.watch<AppProvider>();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.place_add_new_place,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                buildTextField(nameController, AppLocalizations.of(context)!.place_name, Icons.abc),
                SizedBox(height: fieldsSpacing),
                buildTextField(descriptionController, AppLocalizations.of(context)!.place_description, Icons.type_specimen),
                SizedBox(height: fieldsSpacing),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
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
                if (await Connection.addPlace(
                    name: nameController.text,
                    description: descriptionController.text,
                    appProvider: appProvider
                )){
                  showTopMessage(context, AppLocalizations.of(context)!.place_create_success);
                  context.pop();
                } else {
                  showTopMessage(context, AppLocalizations.of(context)!.place_error_occurred);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.place_add_place,
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
