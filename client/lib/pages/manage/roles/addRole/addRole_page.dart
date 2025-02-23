import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
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


class AddRolePage extends StatefulWidget {
  const AddRolePage({super.key});

  @override
  State<AddRolePage> createState() => _AddRolePageState();
}

class _AddRolePageState extends State<AddRolePage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var addUserProvider = context.watch<AddUserProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.create_roles ?
    AddUserAdmin():
    Text("access denied!");
  }
}

class AddUserAdmin extends StatefulWidget {
  const AddUserAdmin({super.key});

  @override
  State<AddUserAdmin> createState() => _AddUserAdminState();
}

class _AddUserAdminState extends State<AddUserAdmin> {
  bool view_users = false;
  bool edit_users = false;
  bool create_users = false;
  bool delete_users = false;
  bool view_own_user = false;
  bool edit_own_user = false;
  bool create_own_user = false;
  bool delete_own_user = false;
  bool view_roles = false;
  bool edit_roles = false;
  bool create_roles = false;
  bool delete_roles = false;
  bool view_availability = false;
  bool edit_availability = false;
  bool create_availability = false;
  bool delete_availability = false;
  bool view_resources = false;
  bool edit_resources = false;
  bool create_resources = false;
  bool delete_resources = false;
  bool view_booking = false;
  bool edit_booking = false;
  bool create_booking = false;
  bool delete_booking = false;
  bool view_own_booking = false;
  bool edit_own_booking = false;
  bool create_own_booking = false;
  bool delete_own_booking = false;

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Role",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            buildTextField(nameController, "Name", Icons.security),
            SizedBox(height: fieldsSpacing),
            buildTextField(descriptionController, "Description", Icons.person_outline),

            const SizedBox(height: 30),

            const Text("Permission:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),


            ExpansionTile(
              title: Text('Users Permission'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Users", view_users, (value) {
                  setState(() {
                    view_users = value;
                  });
                }),
                buildSwitch(context, "Edit Users", edit_users, (value) {
                  setState(() {
                    edit_users = value;
                  });
                }),
                buildSwitch(context, "Create Users", create_users, (value) {
                  setState(() {
                    create_users = value;
                  });
                }),
                buildSwitch(context, "Delete Users", delete_users, (value) {
                  setState(() {
                    delete_users = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text('User Own Permission'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Own User", view_own_user, (value) {
                  setState(() {
                    view_own_user = value;
                  });
                }),
                buildSwitch(context, "Edit Own User", edit_own_user, (value) {
                  setState(() {
                    edit_own_user = value;
                  });
                }),
                buildSwitch(context, "Create Own User", create_own_user, (value) {
                  setState(() {
                    create_own_user = value;
                  });
                }),
                buildSwitch(context, "Delete Own User", delete_own_user, (value) {
                  setState(() {
                    delete_own_user = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text('Roles Permission'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Roles", view_roles, (value) {
                  setState(() {
                    view_roles = value;
                  });
                }),
                buildSwitch(context, "Edit Roles", edit_roles, (value) {
                  setState(() {
                    edit_roles = value;
                  });
                }),
                buildSwitch(context, "Create Roles", create_roles, (value) {
                  setState(() {
                    create_roles = value;
                  });
                }),
                buildSwitch(context, "Delete Roles", delete_roles, (value) {
                  setState(() {
                    delete_roles = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text('Availability Permission'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Availability", view_availability, (value) {
                  setState(() {
                    view_availability = value;
                  });
                }),
                buildSwitch(context, "Edit Availability", edit_availability, (value) {
                  setState(() {
                    edit_availability = value;
                  });
                }),
                buildSwitch(context, "Create Availability", create_availability, (value) {
                  setState(() {
                    create_availability = value;
                  });
                }),
                buildSwitch(context, "Delete Availability", delete_availability, (value) {
                  setState(() {
                    delete_availability = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text('Users Resources'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Resources", view_resources, (value) {
                  setState(() {
                    view_resources = value;
                  });
                }),
                buildSwitch(context, "Edit Resources", edit_resources, (value) {
                  setState(() {
                    edit_resources = value;
                  });
                }),
                buildSwitch(context, "Create Resources", create_resources, (value) {
                  setState(() {
                    create_resources = value;
                  });
                }),
                buildSwitch(context, "Delete Resources", delete_resources, (value) {
                  setState(() {
                    delete_resources = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text('Booking Permission'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Booking", view_booking, (value) {
                  setState(() {
                    view_booking = value;
                  });
                }),
                buildSwitch(context, "Edit Booking", edit_booking, (value) {
                  setState(() {
                    edit_booking = value;
                  });
                }),
                buildSwitch(context, "Create Booking", create_booking, (value) {
                  setState(() {
                    create_booking = value;
                  });
                }),
                buildSwitch(context, "Delete Booking", delete_booking, (value) {
                  setState(() {
                    delete_booking = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text('User Own Booking Permission'),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, "View Own Booking", view_own_booking, (value) {
                  setState(() {
                    view_own_booking = value;
                  });
                }),
                buildSwitch(context, "Edit Own Booking", edit_own_booking, (value) {
                  setState(() {
                    edit_own_booking = value;
                  });
                }),
                buildSwitch(context, "Create Own Booking", create_own_booking, (value) {
                  setState(() {
                    create_own_booking = value;
                  });
                }),
                buildSwitch(context, "Delete Own Booking", delete_own_booking, (value) {
                  setState(() {
                    delete_own_booking = value;
                  });
                }),
              ],
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
                  if (await Connection.addRole(
                      email: appProvider.email,
                      token: appProvider.token,
                      name: nameController.text,
                      view_users: view_users,
                      edit_users: edit_users,
                      create_users: create_users,
                      delete_users: delete_users,
                      view_own_user: view_own_user,
                      edit_own_user: edit_own_user,
                      create_own_user: create_own_user,
                      delete_own_user: delete_own_user,
                      view_roles: view_roles,
                      edit_roles: edit_roles,
                      create_roles: create_roles,
                      delete_roles: delete_roles,
                      view_availability: view_availability,
                      edit_availability: edit_availability,
                      create_availability: create_availability,
                      delete_availability: delete_availability,
                      view_resources: view_resources,
                      edit_resources: edit_resources,
                      create_resources: create_resources,
                      delete_resources: delete_resources,
                      view_booking: view_booking,
                      edit_booking: edit_booking,
                      create_booking: create_booking,
                      delete_booking: delete_booking,
                      view_own_booking: view_own_booking,
                      edit_own_booking: edit_own_booking,
                      create_own_booking: create_own_booking,
                      delete_own_booking: delete_own_booking,
                      description: descriptionController.text, 
                      appProvider: appProvider
                  )){
                    showTopMessage(context, "Role Created");
                    context.pop();
                  } else {
                    showTopMessage(context, "Error Occurred!");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add Role",
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
