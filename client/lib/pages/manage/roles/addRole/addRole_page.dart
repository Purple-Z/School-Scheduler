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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



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
    Text(AppLocalizations.of(context)!.access_denied);
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
            Text(
              AppLocalizations.of(context)!.role_add_new_role,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            buildTextField(nameController, AppLocalizations.of(context)!.role_name, Icons.security),
            SizedBox(height: fieldsSpacing),
            buildTextField(descriptionController, AppLocalizations.of(context)!.role_description, Icons.person_outline),

            const SizedBox(height: 30),

            Text(AppLocalizations.of(context)!.role_permissions, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),


            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_usersPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewUsers, view_users, (value) {
                  setState(() {
                    view_users = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editUsers, edit_users, (value) {
                  setState(() {
                    edit_users = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createUsers, create_users, (value) {
                  setState(() {
                    create_users = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteUsers, delete_users, (value) {
                  setState(() {
                    delete_users = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_userOwnPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewOwnUser, view_own_user, (value) {
                  setState(() {
                    view_own_user = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editOwnUser, edit_own_user, (value) {
                  setState(() {
                    edit_own_user = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createOwnUser, create_own_user, (value) {
                  setState(() {
                    create_own_user = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteOwnUser, delete_own_user, (value) {
                  setState(() {
                    delete_own_user = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_rolesPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewRoles, view_roles, (value) {
                  setState(() {
                    view_roles = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editRoles, edit_roles, (value) {
                  setState(() {
                    edit_roles = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createRoles, create_roles, (value) {
                  setState(() {
                    create_roles = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteRoles, delete_roles, (value) {
                  setState(() {
                    delete_roles = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_availabilityPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewAvailability, view_availability, (value) {
                  setState(() {
                    view_availability = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editAvailability, edit_availability, (value) {
                  setState(() {
                    edit_availability = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createAvailability, create_availability, (value) {
                  setState(() {
                    create_availability = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteAvailability, delete_availability, (value) {
                  setState(() {
                    delete_availability = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_resourcesPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewResources, view_resources, (value) {
                  setState(() {
                    view_resources = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editResources, edit_resources, (value) {
                  setState(() {
                    edit_resources = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createResources, create_resources, (value) {
                  setState(() {
                    create_resources = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteResources, delete_resources, (value) {
                  setState(() {
                    delete_resources = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_bookingPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewBooking, view_booking, (value) {
                  setState(() {
                    view_booking = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editBooking, edit_booking, (value) {
                  setState(() {
                    edit_booking = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createBooking, create_booking, (value) {
                  setState(() {
                    create_booking = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteBooking, delete_booking, (value) {
                  setState(() {
                    delete_booking = value;
                  });
                }),
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_userOwnBookingPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                buildSwitch(context, AppLocalizations.of(context)!.role_viewOwnBooking, view_own_booking, (value) {
                  setState(() {
                    view_own_booking = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_editOwnBooking, edit_own_booking, (value) {
                  setState(() {
                    edit_own_booking = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_createOwnBooking, create_own_booking, (value) {
                  setState(() {
                    create_own_booking = value;
                  });
                }),
                buildSwitch(context, AppLocalizations.of(context)!.role_deleteOwnBooking, delete_own_booking, (value) {
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
                    showTopMessage(context, AppLocalizations.of(context)!.role_create_success);
                    context.pop();
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.role_error_occurred);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context)!.role_add_role,
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
      ),
    );
  }
}
