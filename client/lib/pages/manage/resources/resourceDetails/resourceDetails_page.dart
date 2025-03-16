import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/resourceDetails_provider.dart';
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




class ResourceDetailsPage extends StatefulWidget {
  const ResourceDetailsPage({super.key});

  @override
  State<ResourceDetailsPage> createState() => _ResourceDetailsPageState();
}

class _ResourceDetailsPageState extends State<ResourceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var resourceDetailsProvider = context.watch<ResourceDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ResourceDetails(resource: resourceDetailsProvider.resource,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ResourceDetails extends StatefulWidget {
  final List resource;
  const ResourceDetails({
    super.key,
    required this.resource
  });

  @override
  State<ResourceDetails> createState() => _ResourceDetailsState(resource: resource);
}

class _ResourceDetailsState extends State<ResourceDetails> {
  List resource = [];
  List types = [];
  var type;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  _ResourceDetailsState({required this.resource}){
    nameController.text = resource[1];
    descriptionController.text = resource[2];
    quantityController.text = resource[3].toString();
    type = resource[4].toString();
  }


  @override
  Widget build(BuildContext context) {
    var resourceDetailsProvider = context.watch<ResourceDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.resource_details_for,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              resourceDetailsProvider.resource[1],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            buildTextField(nameController, AppLocalizations.of(context)!.resource_name, Icons.person, editable: appProvider.edit_resources),
            SizedBox(height: fieldsSpacing),
            buildTextField(descriptionController, AppLocalizations.of(context)!.resource_description, Icons.person, editable: appProvider.edit_resources),
            SizedBox(height: fieldsSpacing),
            buildTextField(quantityController, AppLocalizations.of(context)!.resource_quantity, Icons.person, editable: appProvider.edit_resources, inputType: TextInputType.number),
            SizedBox(height: fieldsSpacing),

            const SizedBox(height: 30),

            Text(AppLocalizations.of(context)!.resource_type, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            DropdownMenu<String>(
              //enabled: appProvider.edit_resources
              enabled: false,
              initialSelection: type,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  type = value!;
                });
              },
              dropdownMenuEntries: resourceDetailsProvider.types
                  .map<DropdownMenuEntry<String>>((type) => DropdownMenuEntry(value: type[0], label: type[0]))
                  .toList(),
            ),

            const SizedBox(height: 30),

            Text(AppLocalizations.of(context)!.resource_permissions, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: resourceDetailsProvider.resource_permission.entries.map((entry){
                return ExpansionTile(
                  title: Text(entry.key),
                  controlAffinity: ListTileControlAffinity.leading,
                  children: <Widget>[
                    buildSwitch(context, AppLocalizations.of(context)!.resource_view, entry.value[0], (value) {
                      setState(() {
                        entry.value[0] = value;
                      });
                    }, isEditable: appProvider.edit_resources),
                    buildSwitch(context, AppLocalizations.of(context)!.resource_remove, entry.value[1], (value) {
                      setState(() {
                        entry.value[1] = value;
                      });
                    }, isEditable: appProvider.edit_resources),
                    buildSwitch(context, AppLocalizations.of(context)!.resource_edit, entry.value[2], (value) {
                      setState(() {
                        entry.value[2] = value;
                      });
                    }, isEditable: appProvider.edit_resources),
                    buildSwitch(context, AppLocalizations.of(context)!.resource_book, entry.value[3], (value) {
                      setState(() {
                        entry.value[3] = value;
                      });
                    }, isEditable: appProvider.edit_resources),
                  ],
                );
              }
              ).toList(),
            ),



            const SizedBox(height: 30),

            if (appProvider.view_availability)
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary
                              )
                          )
                      ),
                      onPressed: () {
                        context.push(Routes.manage_ManageResources_ManageAvailabilities);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.resource_view_availability,
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


            if (appProvider.edit_resources)
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
                        await Connection.updateResource(
                            appProvider,
                            resource_id: resourceDetailsProvider.resource[0],
                            name: nameController.text,
                            description: descriptionController.text,
                            quantity: int.tryParse(quantityController.text) ?? 0,
                            type: type,
                            resource_permissions: resourceDetailsProvider.resource_permission
                        )){
                          showTopMessage(context, AppLocalizations.of(context)!.resource_update_success);
                        } else {
                          showTopMessage(context, AppLocalizations.of(context)!.resource_error_occurred);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.resource_update_resource,
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


            if (appProvider.delete_resources)
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
                    if(await confirm(context, content: Text(AppLocalizations.of(context)!.resource_delete_confirmation + " " + resourceDetailsProvider.resource[1] + "?"))){
                      if (await Connection.deleteResource(resourceDetailsProvider.resource[0], appProvider)){
                        showTopMessage(context, AppLocalizations.of(context)!.resource_delete_success);
                        context.pop();
                      } else {
                        showTopMessage(context, AppLocalizations.of(context)!.resource_error_occurred);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.resource_delete_resource,
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