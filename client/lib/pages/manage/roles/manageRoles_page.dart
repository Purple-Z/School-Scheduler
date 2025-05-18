import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/roles/manageRoles_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../connection.dart';
import '../widgets.dart';

class ManageRolesPage extends StatefulWidget {
  const ManageRolesPage({super.key});

  @override
  State<ManageRolesPage> createState() => _ManageRolesPageState();
}

class _ManageRolesPageState extends State<ManageRolesPage> {
  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    return appProvider.view_roles ? ManageUsersAdmin() : Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManageUsersAdmin extends StatefulWidget {
  const ManageUsersAdmin({super.key});

  @override
  _ManageUsersAdminState createState() => _ManageUsersAdminState();
}

class _ManageUsersAdminState extends State<ManageUsersAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshRoles() async {
    var appProvider = context.read<AppProvider>();
    var manageRolesProvider = context.read<ManageRolesProvider>();

    try {
      List roles = await Connection.getRoles(appProvider);
      manageRolesProvider.setRoles(roles);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  List<List<String>> getItems() {
    var manageRolesProvider = context.read<ManageRolesProvider>();
    List<List<String>> items = [];

    for (var role in manageRolesProvider.roles) {
      String id = role[0].toString();
      String name = role[1];
      String description = role[2] ?? "";

      bool view_users = role[3] == 1;
      bool edit_users = role[4] == 1;
      bool create_users = role[5] == 1;
      bool delete_users = role[6] == 1;
      bool view_own_users = role[7] == 1;
      bool edit_own_users = role[8] == 1;
      bool create_own_users = role[9] == 1;
      bool delete_own_users = role[10] == 1;
      bool view_roles = role[11] == 1;
      bool edit_roles = role[12] == 1;
      bool create_roles = role[13] == 1;
      bool delete_roles = role[14] == 1;
      bool view_availability = role[15] == 1;
      bool edit_availability = role[16] == 1;
      bool create_availability = role[17] == 1;
      bool delete_availability = role[18] == 1;
      bool view_resources = role[19] == 1;
      bool edit_resources = role[20] == 1;
      bool create_resources = role[21] == 1;
      bool delete_resources = role[22] == 1;
      bool view_booking = role[23] == 1;
      bool edit_booking = role[24] == 1;
      bool create_booking = role[25] == 1;
      bool delete_booking = role[26] == 1;
      bool view_own_booking = role[27] == 1;
      bool edit_own_booking = role[28] == 1;
      bool create_own_booking = role[29] == 1;
      bool delete_own_booking = role[30] == 1;

      List<String> item = [id, name, description];
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var manageRolesProvider = context.watch<ManageRolesProvider>();
    var appProvider = context.watch<AppProvider>();

    return Scaffold(
      floatingActionButton: appProvider.create_roles ?
      FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_Roles_AddRole);
        },
        label: Text(
          AppLocalizations.of(context)!.role_new_role,
          style: TextStyle(
              color: Theme.of(context).colorScheme.surface
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.surface
        ),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: DataTableWidget(
          id: 'manageRoles',
          header: [AppLocalizations.of(context)!.role_name, AppLocalizations.of(context)!.role_description],
          onRefresh: refreshRoles,
          refreshController: refreshController,
          itemsColumn: [
            null,
            AppLocalizations.of(context)!.role_name,
            AppLocalizations.of(context)!.role_description
          ],
          itemCategories: [
            'other',
            'text',
            'text'
          ],
          onItemTap: (List item) {
            context.push(Routes.manage_Roles_RoleDetails, extra: {'roleId': item[0]});
          },
          items: getItems(),
        ),
      ),
    );
  }
}
