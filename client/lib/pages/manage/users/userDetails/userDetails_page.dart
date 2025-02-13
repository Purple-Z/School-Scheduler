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

    return appProvider.admin ?
    UserDetailsAdmin(user: userDetailsProvider.user,):
    Text("access denied!");
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
  bool isAdmin = false;
  bool isLeader = false;
  bool isProfessor = false;
  bool isStudent = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  _UserDetailsAdminState({required this.user}){
    isAdmin = user[5] == 1;
    isLeader = user[6] == 1;
    isProfessor = user[7] == 1;
    isStudent = user[8] == 1;

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
            const Text(
              "Details for",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              userDetailsProvider.user[3],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            buildTextField(nameController, "Name", Icons.person),
            SizedBox(height: fieldsSpacing),
            buildTextField(surnameController, "Surname", Icons.person),
            SizedBox(height: fieldsSpacing),

            const SizedBox(height: 30),

            const Text("Update Roles", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            buildSwitch(context, "Admin", isAdmin, (value) {
              setState(() {
                isAdmin = value;
              });
            }),
            buildSwitch(context, "Leader", isLeader, (value) {
              setState(() {
                isLeader = value;
              });
            }),
            buildSwitch(context, "Professor", isProfessor, (value) {
              setState(() {
                isProfessor = value;
              });
            }),
            buildSwitch(context, "Student", isStudent, (value) {
              setState(() {
                isStudent = value;
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
                  if (
                    await Connection.updateUser(
                        appProvider,
                        user_id: userDetailsProvider.user[0],
                        new_name: nameController.text,
                        new_surname: surnameController.text,
                        new_admin: isAdmin,
                        new_leader: isLeader,
                        new_professor: isProfessor,
                        new_student: isStudent
                    )
                  ){
                    showTopMessage(context, "User Updated!");
                  } else {
                    showTopMessage(context, "Error Occurred!");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Update User",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
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
                            color: Theme.of(context).colorScheme.onPrimary
                        )
                    )
                ),
                onPressed: () async {
                  if(await confirm(context, content: Text("Reset Password?"))){
                    if (await Connection.resetPassword(userDetailsProvider.user[0], appProvider)){
                      showTopMessage(context, "password reset");
                    } else {
                      showTopMessage(context, "Error Occurred");
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Restore Password",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10,),

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
                  if(await confirm(context, content: Text("Delete " + userDetailsProvider.user[3] + "?"))){
                    if (await Connection.deleteUser(userDetailsProvider.user[0], appProvider)){
                      showTopMessage(context, "Account deleted");
                      context.pop();
                    } else {
                      showTopMessage(context, "Error Occurred");
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Delete User",
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