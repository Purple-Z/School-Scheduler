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
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:duration_picker/duration_picker.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  _ResourceDetailsState({required this.resource}){
    nameController.text = resource[1];
    descriptionController.text = resource[2];
    quantityController.text = resource[3].toString();
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

            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: resourceDetailsProvider.slot_chek,
                  onChanged: (bool? value) {
                    setState(() {
                      resourceDetailsProvider.slot_chek = value!;
                    });
                  },
                ),
                SizedBox(width: 20,),
                Text(
                    'Manage With Slots',
                    style: TextStyle(fontSize: 20)
                )
              ],
            ),

            if (resourceDetailsProvider.slot_chek) Column(
              children: [
                SizedBox(height: fieldsSpacing),
                ElevatedButton(
                    onPressed: () async {
                      resourceDetailsProvider.setSlotDuration(
                          await showDurationPicker(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).colorScheme.surface
                            ),
                            context: context,
                            initialTime: resourceDetailsProvider.slot_duration,
                          ) ?? resourceDetailsProvider.slot_duration
                      );

                    },
                    child: Text(
                        resourceDetailsProvider.slot_duration.inHours.toString()+' hours '+
                            (resourceDetailsProvider.slot_duration.inMinutes-resourceDetailsProvider.slot_duration.inHours*60).toString()+' minutes'
                    )
                )
              ],
            ),

            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: resourceDetailsProvider.resource[8],
                  onChanged: (bool? value) {
                    setState(() {
                      resourceDetailsProvider.resource[8] = value!;
                    });
                  },
                ),
                SizedBox(width: 20,),
                Text(
                  'Auto Accept',
                  style: TextStyle(fontSize: 20)
                )
              ],
            ),

            if (!resourceDetailsProvider.resource[8]) Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: resourceDetailsProvider.resource[9],
                  onChanged: (bool? value) {
                    setState(() {
                      resourceDetailsProvider.resource[9] = value!;
                    });
                  },
                ),
                SizedBox(width: 20,),
                Text(
                  'Allow Over Booking',
                  style: TextStyle(fontSize: 20)
                )
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.resource_place, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),


                    ElevatedButton(
                      onPressed: () async {
                        List<SelectedListItem<String>> selections = [];
                        for (var data in resourceDetailsProvider.places){
                          selections.add(SelectedListItem<String>(data: data[0]));
                        }
                        DropDownState<String>(
                          dropDown: DropDown<String>(
                            data: selections,
                            onSelected: (selectedItems) {
                              List<String> list = [];
                              for (var item in selectedItems) {
                                list.add(item.data);
                              }

                              resourceDetailsProvider.changePlaceValue(list.first);
                            },
                          ),
                        ).showModal(context);
                      },
                      child: Text(
                        resourceDetailsProvider.place,
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(Colors.transparent)
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.resource_activity, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),


                    ElevatedButton(
                      onPressed: () async {
                        List<SelectedListItem<String>> selections = [];
                        for (var data in resourceDetailsProvider.activities){
                          selections.add(SelectedListItem<String>(data: data[0]));
                        }
                        DropDownState<String>(
                          dropDown: DropDown<String>(
                            data: selections,
                            onSelected: (selectedItems) {
                              List<String> list = [];
                              for (var item in selectedItems) {
                                list.add(item.data);
                              }

                              resourceDetailsProvider.changeActivityValue(list.first);
                            },
                          ),
                        ).showModal(context);
                      },
                      child: Text(
                        resourceDetailsProvider.activity,
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(Colors.transparent)
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.resource_type, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),


                    ElevatedButton(
                      onPressed: () async {
                        List<SelectedListItem<String>> selections = [];
                        for (var data in resourceDetailsProvider.types){
                          selections.add(SelectedListItem<String>(data: data[0]));
                        }
                        DropDownState<String>(
                          dropDown: DropDown<String>(
                            data: selections,
                            onSelected: (selectedItems) {
                              List<String> list = [];
                              for (var item in selectedItems) {
                                list.add(item.data);
                              }

                              resourceDetailsProvider.changeTypeValue(list.first);
                            },
                          ),
                        ).showModal(context);
                      },
                      child: Text(
                        resourceDetailsProvider.type,
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(Colors.transparent)
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox())
              ],
            ),

            ExpansionTile(

              title: Text(AppLocalizations.of(context)!.resource_referents, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            List<SelectedListItem<ListItem>> selections = [];
                            for (List user in resourceDetailsProvider.users){
                              selections.add(SelectedListItem<ListItem>(
                                  data: ListItem(
                                    display: (user[1]+', '+user[2]+'\n'+user[3]),
                                    value: user[3],
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

                                  resourceDetailsProvider.changeUsersValue(list);
                                },
                              ),
                            ).showModal(context);
                          },
                          style: const ButtonStyle(
                              shadowColor: WidgetStatePropertyAll(Colors.transparent),
                              overlayColor: WidgetStatePropertyAll(Colors.transparent)
                          ),
                          child: Column(
                            children: [
                              if(resourceDetailsProvider.users.every((riga) => riga[riga.length-1] == false))
                                Text(AppLocalizations.of(context)!.resource_referents_empty),
                              for (var user in resourceDetailsProvider.users)
                                if (user.last == true)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          user[1]+' '+user[2],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context).colorScheme.primary
                                          ),
                                        ),
                                        Text(
                                          user[3],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context).colorScheme.primary
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
              ],
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
                    buildSwitch(context, AppLocalizations.of(context)!.resource_can_accept, entry.value[4], (value) {
                      setState(() {
                        entry.value[4] = value;
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
                        switch (await Connection.updateResource(
                            appProvider,
                            resource_id: resourceDetailsProvider.resource[0],
                            name: nameController.text,
                            description: descriptionController.text,
                            quantity: int.tryParse(quantityController.text) ?? 0,
                            auto_accept: resourceDetailsProvider.resource[8],
                            over_booking: resourceDetailsProvider.getOverbooking(),
                            type: resourceDetailsProvider.type,
                            resource_permissions: resourceDetailsProvider.resource_permission,
                            place: resourceDetailsProvider.place,
                            activity: resourceDetailsProvider.activity,
                            slot: resourceDetailsProvider.getSlotDuration(),
                            referents: resourceDetailsProvider.getUser()
                        )) {
                          case 0:
                            showTopMessage(context, AppLocalizations.of(context)!.resource_update_success);
                            break;

                          case 1:
                            showTopMessage(context, "Can't Toggle auto accept.\nTry remove pending bookings", isOK: false);
                            break;

                          case 2:
                            showTopMessage(context, AppLocalizations.of(context)!.resource_error_occurred, isOK: false);
                            break;
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

class ListItem {
  final String display;
  final dynamic value;

  ListItem({required this.display, required this.value});
  @override
  String toString() {
    // TODO: implement toString
    return display;
  }
}
