import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../connection.dart';


class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var manageUsersProvider = context.watch<ManageUsersProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.admin ?
      ManageUsersAdmin():
      Text("access denied!");
  }
}

class ManageUsersAdmin extends StatefulWidget {
  const ManageUsersAdmin({super.key});

  @override
  _ManageUsersAdminState createState() => _ManageUsersAdminState();
}

class _ManageUsersAdminState extends State<ManageUsersAdmin> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _refreshUsers() async {
    var appProvider = context.read<AppProvider>();
    var manageUsersProvider = context.read<ManageUsersProvider>();

    try {
      List users = await Connection.getUsers(appProvider);
      manageUsersProvider.setUsers(users);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    var manageUsersProvider = context.watch<ManageUsersProvider>();
    List users = manageUsersProvider.users;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_Users_AddUsers);
        },
        label: Text("New User"),
        icon: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: Center(child: Text('Name', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Surname', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Email', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Roles', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold)))),
              ],
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _refreshUsers,
                header: MaterialClassicHeader(),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Divider(),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                          ),
                          onPressed: () {
                            context.push(Routes.manage_Users_userDetails, extra: {'userId': user[0]});
                          },
                          child: Row(
                            children: [
                              Expanded(child: Center(child: Text(user[1].toString()))),
                              Expanded(child: Center(child: Text(user[2].toString()))),
                              Expanded(child: Center(child: Text(user[3].toString()))),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (user[5] == 1) const Text("Admin"),
                                      if (user[6] == 1) const Text("Leader"),
                                      if (user[7] == 1) const Text("Professor"),
                                      if (user[8] == 1) const Text("Student"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
