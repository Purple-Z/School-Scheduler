import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
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




class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var userDetailsProvider = context.watch<UserDetailsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_user ?
    UserDetailsAdmin(user: userDetailsProvider.user,):
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class UserDetailsAdmin extends StatefulWidget {
  final List user;
  const UserDetailsAdmin({
    super.key,
    required this.user
  });

  @override
  State<UserDetailsAdmin> createState() => _UserDetailsAdminState(user: user);
}

class _UserDetailsAdminState extends State<UserDetailsAdmin> {
  List user = [];
  List roles = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  _UserDetailsAdminState({required this.user}){
    nameController.text = user[1];
    surnameController.text = user[2];
  }


  @override
  Widget build(BuildContext context) {
    var userDetailsProvider = context.watch<UserDetailsProvider>();
    var appProvider = context.watch<AppProvider>();
    double fieldsSpacing = 15;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.user_details,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              userDetailsProvider.user[3],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            buildTextField(nameController, AppLocalizations.of(context)!.user_name, Icons.person, editable: appProvider.edit_user),
            SizedBox(height: fieldsSpacing),
            buildTextField(surnameController, AppLocalizations.of(context)!.user_surname, Icons.person, editable: appProvider.edit_user),
            SizedBox(height: fieldsSpacing),

            const SizedBox(height: 30),

            Text(AppLocalizations.of(context)!.user_update_roles, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            for (int i = 0; i < userDetailsProvider.roles.length; i++)
              buildSwitch(context, userDetailsProvider.roles[i][0], userDetailsProvider.rolesValues[i], (value) {
                setState(() {
                  userDetailsProvider.rolesValues[i] = value;
                });
              }, isEditable: appProvider.edit_user),

            const SizedBox(height: 30),

            if (appProvider.edit_user)
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(
                                  color: Theme.of(context).colorScheme.surface
                              )
                          )
                      ),
                      onPressed: () async {
                        List<String> rolesValues = [];
                        for (int i = 0; i < userDetailsProvider.rolesValues.length; i++){
                          if (userDetailsProvider.rolesValues[i]){
                            rolesValues.add(userDetailsProvider.roles[i][0]);
                          }
                        }
                        if (
                        await Connection.updateUser(
                          appProvider,
                          user_id: userDetailsProvider.user[0],
                          new_name: nameController.text,
                          new_surname: surnameController.text,
                          roles: rolesValues,
                        )
                        ){
                          showTopMessage(context, AppLocalizations.of(context)!.user_updated_success);
                        } else {
                          showTopMessage(context, AppLocalizations.of(context)!.user_error_occurred);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.user_update_user,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(
                                  color: Theme.of(context).colorScheme.surface
                              )
                          )
                      ),
                      onPressed: () async {
                        if(await confirm(context, content: Text(AppLocalizations.of(context)!.user_password_reset_confirmation))){
                          if (await Connection.resetPassword(userDetailsProvider.user[0], appProvider)){
                            showTopMessage(context, AppLocalizations.of(context)!.user_password_reset);
                          } else {
                            showTopMessage(context, AppLocalizations.of(context)!.user_error_occurred);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.user_restore_password,
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

            const SizedBox(height: 10,),

            if (appProvider.delete_user)
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.9, 0)),
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                      textStyle: WidgetStatePropertyAll(
                          TextStyle(
                              color: Theme.of(context).colorScheme.surface
                          )
                      )
                  ),
                  onPressed: () async {
                    if(await confirm(context, content: Text(AppLocalizations.of(context)!.user_delete + " " + userDetailsProvider.user[3] + "?"))){
                      if (await Connection.deleteUser(userDetailsProvider.user[0], appProvider)){
                        showTopMessage(context, AppLocalizations.of(context)!.user_delete_success);
                        context.pop();
                      } else {
                        showTopMessage(context, AppLocalizations.of(context)!.user_error_occurred);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.user_delete_user,
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