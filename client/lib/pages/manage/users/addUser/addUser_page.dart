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

    return appProvider.admin ?
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
  bool isAdmin = false;
  bool isLeader = false;
  bool isProfessor = false;
  bool isStudent = false;

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

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New User",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            buildTextField(nameController, "Name", Icons.person),
            SizedBox(height: fieldsSpacing),
            buildTextField(surnameController, "Surname", Icons.person_outline),
            SizedBox(height: fieldsSpacing),
            buildTextField(emailController, "Email", Icons.email, inputType: TextInputType.emailAddress),

            const SizedBox(height: 30),

            const Text("Roles:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                  if (await Connection.addUser(
                      email: appProvider.email,
                      token: appProvider.token,
                      new_email: emailController.text,
                      new_name: nameController.text,
                      new_surname: surnameController.text,
                      new_admin: isAdmin,
                      new_leader: isLeader,
                      new_professor: isProfessor,
                      new_student: isStudent,
                      appProvider: appProvider
                  )){
                    showTopMessage(context, "User Created!");
                    context.pop();
                  } else {
                    showTopMessage(context, "Error Occurred!");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Add User",
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
