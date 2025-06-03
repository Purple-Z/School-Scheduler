import 'dart:io';

import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/addUserCSV/addUserCSV_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:client/graphics/graphics_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class AddUsersCSVPage extends StatefulWidget {
  const AddUsersCSVPage({super.key});

  @override
  State<AddUsersCSVPage> createState() => _AddUsersCSVPageState();
}

class _AddUsersCSVPageState extends State<AddUsersCSVPage> {
  @override
  Widget build(BuildContext context) {
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
  @override
  Widget build(BuildContext context) {
    double fieldsSpacing = 15;
    var appProvider = context.watch<AppProvider>();
    var addUsersCSVProvider = context.watch<AddUsersCSVProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                AppLocalizations.of(context)!.load_CSV_file,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                AppLocalizations.of(context)!.description_CSV,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv', 'CSV']
                  );

                  if (result != null) {
                    File file = File(result.files.single.path!);

                    final contents = await file.readAsString();

                    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(contents);

                    List users = [];
                    for (int i = 1; i < rowsAsListOfValues.length; i++) {
                      final user = rowsAsListOfValues[i];
                      String name = user[0];
                      String surname = user[1];
                      String email = user[2];
                      List roles = user.sublist(3);
                      users.add([name, surname, email, roles]);
                    }
                    addUsersCSVProvider.setCanLoad(true);
                    addUsersCSVProvider.setUsers(users);
                    print(users);
                  } else {
                    addUsersCSVProvider.setCanLoad(false);
                  }
                },
                child: Text(AppLocalizations.of(context)!.choose_CSV_file)
              ),
            ),

            if (addUsersCSVProvider.canLoad) Center(
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
                  if (!await confirm(context, content: Text(AppLocalizations.of(context)!.add+' '+addUsersCSVProvider.users.length.toString()+' '+AppLocalizations.of(context)!.users+'?'))){
                    return;
                  }
                  int result = await Connection.addUsers(users: addUsersCSVProvider.users, appProvider: appProvider);
                  if (result == 0){
                    showTopMessage(context, AppLocalizations.of(context)!.all_users_created);
                  } else if (result != -1) {
                    showTopMessage(context, result.toString()+' '+AppLocalizations.of(context)!.users_uncreated, isOK: false);
                  } else {
                    showTopMessage(context, AppLocalizations.of(context)!.error_occurred, isOK: false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context)!.add_users,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
            ),

            if (addUsersCSVProvider.canLoad) SizedBox(height: 40,),

            if (addUsersCSVProvider.canLoad) Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.preview,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    '('+addUsersCSVProvider.users.length.toString()+' '+AppLocalizations.of(context)!.total+')',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            if (addUsersCSVProvider.canLoad) Column(
              children: [
                for (int j = 0; j < addUsersCSVProvider.users.length; j++)
                  Container(
                    decoration: BoxDecoration(
                      color: j%2==1 ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (j+1).toString(),
                              style: TextStyle(
                                  color: j%2==1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface
                              ),
                            ),
                          ),
                          for (int i = 0; i < 3; i++)
                            Expanded(child: Center(child: Text(
                                addUsersCSVProvider.users[j][i],
                                  style: TextStyle(
                                    color: j%2==1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface
                                  ),
                                )
                              ),
                            ),
                          Expanded(child: Center(child: Text(
                              addUsersCSVProvider.users[j][3].join(',\n'),
                                style: TextStyle(
                                  color: j%2==1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
