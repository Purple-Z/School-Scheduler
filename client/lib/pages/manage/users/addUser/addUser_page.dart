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



class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var addUserProvider = context.watch<AddUserProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.create_user ?
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
  List rolesValues = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double fieldsSpacing = 15;
    var appProvider = context.watch<AppProvider>();
    var addUserProvider = context.watch<AddUserProvider>();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.user_add_new_user,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            buildTextField(nameController, AppLocalizations.of(context)!.user_name, Icons.person),
            SizedBox(height: fieldsSpacing),
            buildTextField(surnameController, AppLocalizations.of(context)!.user_surname, Icons.person_outline),
            SizedBox(height: fieldsSpacing),
            buildTextField(emailController, AppLocalizations.of(context)!.user_email, Icons.email, inputType: TextInputType.emailAddress),

            const SizedBox(height: 30),

            Text(AppLocalizations.of(context)!.user_roles, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),


            for (int i = 0; i < addUserProvider.roles.length; i++)
              buildSwitch(context, addUserProvider.roles[i][0], addUserProvider.rolesValues[i], (value) {
                setState(() {
                  addUserProvider.rolesValues[i] = value;
                });
              }),

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
                  List<String> rolesValues = [];
                  for (int i = 0; i < addUserProvider.rolesValues.length; i++){
                    if (addUserProvider.rolesValues[i]){
                      rolesValues.add(addUserProvider.roles[i][0]);
                    }
                  }
                  if (await Connection.addUser(
                      new_email: emailController.text,
                      new_name: nameController.text,
                      new_surname: surnameController.text,
                      new_roles: rolesValues,
                      appProvider: appProvider
                  )){
                    showTopMessage(context, AppLocalizations.of(context)!.user_create_success);
                    context.pop();
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.user_error_occurred, isOK: false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context)!.user_add_user,
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
