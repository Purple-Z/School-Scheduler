import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/resources/addResource/addResource_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:client/graphics/graphics_methods.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class AddResourcePage extends StatefulWidget {
  const AddResourcePage({super.key});

  @override
  State<AddResourcePage> createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var addResourceProvider = context.watch<AddResourceProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.create_resources ?
    AddResource():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class AddResource extends StatefulWidget {
  const AddResource({super.key});

  @override
  State<AddResource> createState() => _AddResourceState();
}

class _AddResourceState extends State<AddResource> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double fieldsSpacing = 15;
    var appProvider = context.watch<AppProvider>();
    var addResourceProvider = context.watch<AddResourceProvider>();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.resource_add_new_resource,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            buildTextField(nameController, AppLocalizations.of(context)!.resource_name, Icons.person),
            SizedBox(height: fieldsSpacing),
            buildTextField(descriptionController, AppLocalizations.of(context)!.resource_description, Icons.person_outline),
            SizedBox(height: fieldsSpacing),
            buildTextField(quantityController, AppLocalizations.of(context)!.resource_quantity, Icons.person_outline, inputType: TextInputType.number),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(child: SizedBox()),
                Column(
                  children: [
                    Text("Place", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),


                    ElevatedButton(
                      onPressed: () async {
                        List<SelectedListItem<String>> selections = [];
                        for (var data in addResourceProvider.places){
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

                              addResourceProvider.changePlaceValue(list.first);
                            },
                          ),
                        ).showModal(context);
                      },
                      child: Text(
                        addResourceProvider.place,
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
                    Text("Activity", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),


                    ElevatedButton(
                      onPressed: () async {
                        List<SelectedListItem<String>> selections = [];
                        for (var data in addResourceProvider.activities){
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

                              addResourceProvider.changeActivityValue(list.first);
                            },
                          ),
                        ).showModal(context);
                      },
                      child: Text(
                        addResourceProvider.activity,
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
                        for (var data in addResourceProvider.types){
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

                              addResourceProvider.changeTypeValue(list.first);
                            },
                          ),
                        ).showModal(context);
                      },
                      child: Text(
                        addResourceProvider.type,
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

              title: Text('Referents', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                            for (List user in addResourceProvider.users){
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

                                  addResourceProvider.changeUsersValue(list);
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
                              if(addResourceProvider.users.every((riga) => riga[riga.length-1] == false))
                                Text('Empty list, tap to add'),
                              for (var user in addResourceProvider.users)
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

            const SizedBox(height: 20),
            
            Text(AppLocalizations.of(context)!.resource_permissions, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: addResourceProvider.resource_permission.entries.map((entry){
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
                  print('qt ' + quantityController.text);

                  if (await Connection.addResource(
                      name: nameController.text,
                      description: descriptionController.text,
                      quantity: int.tryParse(quantityController.text) ?? 0,
                      type: addResourceProvider.type,
                      appProvider: appProvider,
                      resource_permissions: addResourceProvider.resource_permission,
                      place: addResourceProvider.place,
                      activity: addResourceProvider.activity,
                      slot: -1,
                      referents: addResourceProvider.getUser()
                  )){
                    showTopMessage(context, AppLocalizations.of(context)!.resource_create_success);
                    context.pop();
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.resource_error_occurred);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context)!.resource_add_resource,
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
