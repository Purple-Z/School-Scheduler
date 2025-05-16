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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../connection.dart';
import '../widgets.dart';


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

    return appProvider.view_user ?
      ManageUsersAdmin():
      Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManageUsersAdmin extends StatefulWidget {
  const ManageUsersAdmin({super.key});

  @override
  _ManageUsersAdminState createState() => _ManageUsersAdminState();
}

class _ManageUsersAdminState extends State<ManageUsersAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshUsers() async {
    var appProvider = context.read<AppProvider>();
    var manageUsersProvider = context.read<ManageUsersProvider>();

    try {
      List users = await Connection.getUsers(appProvider);
      manageUsersProvider.setUsers(users);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  getItem(List items){
    List newItems = [];
    for (List item in items){
      List newItem = [];
      for (var quality in item){
        newItem.add(quality);
      }

      if (item[item.length-1].length == 0){
        newItem[item.length-1] = "";
        newItems.add(newItem);
        continue;
      }
      List roles = item[item.length-1];

      String result = "";
      for (int i = 0; i < roles.length-1; i++){
        result += (roles[i] + ', \n');
      }
      result += (roles[roles.length-1]);



      newItem[item.length-1] = result;
      newItems.add(newItem);
    }
    return newItems;
  }

  @override
  Widget build(BuildContext context) {
    var manageUsersProvider = context.watch<ManageUsersProvider>();
    var appProvider = context.watch<AppProvider>();
    List users = manageUsersProvider.users;

    return Scaffold(
      floatingActionButton: appProvider.create_user ?
      FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_Users_AddUsers);
        },
        label: Text(
          AppLocalizations.of(context)!.user_new_user,
          style: TextStyle(
              color: Theme
                  .of(context)
                  .colorScheme
                  .surface
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Theme
              .of(context)
              .colorScheme
              .surface,
        ),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
            id: 'manageUsers',
            header: [AppLocalizations.of(context)!.user_name,
              AppLocalizations.of(context)!.user_surname,
              AppLocalizations.of(context)!.user_email,
              AppLocalizations.of(context)!.user_roles
            ],
            onRefresh: refreshUsers,
            onItemTap: (List item) {
              context.push(Routes.manage_Users_userDetails,
                  extra: {'userId': item[0]});
            },
            items: manageUsersProvider.users,
            itemsColumn: [
              null, //0
              AppLocalizations.of(context)!.user_name, //1
              AppLocalizations.of(context)!.user_surname, //2
              AppLocalizations.of(context)!.user_email, //3
              null, //4
              null, //5
              null, //6
              AppLocalizations.of(context)!.user_roles, //7
            ],
            itemCategories: [
              'other',
              'text',
              'text',
              'text',
              'other',
              'other',
              'other',
              'multi-text'
            ],
            refreshController: refreshController,
          )
      ),
    );
  }
}
