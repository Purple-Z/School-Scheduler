import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
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


class ManageTypesPage extends StatefulWidget {
  const ManageTypesPage({super.key});

  @override
  State<ManageTypesPage> createState() => _ManageTypesPageState();
}

class _ManageTypesPageState extends State<ManageTypesPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var manageTypesProvider = context.watch<ManageTypesProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ManageTypesAdmin():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManageTypesAdmin extends StatefulWidget {
  const ManageTypesAdmin({super.key});

  @override
  _ManageTypesAdminState createState() => _ManageTypesAdminState();
}

class _ManageTypesAdminState extends State<ManageTypesAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshTypes() async {
    var appProvider = context.read<AppProvider>();
    var manageTypesProvider = context.read<ManageTypesProvider>();

    try {
      List types = await Connection.getTypes(appProvider);
      manageTypesProvider.setTypes(types);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    var manageTypesProvider = context.watch<ManageTypesProvider>();
    var appProvider = context.watch<AppProvider>();
    List types = manageTypesProvider.types;

    return Scaffold(
      floatingActionButton: appProvider.create_resources ?
        FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_Types_AddType);
        },
        label: Text(
          AppLocalizations.of(context)!.type_new_type,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
              id: 'manageTypes',
              header: [AppLocalizations.of(context)!.type_name, AppLocalizations.of(context)!.type_description],
              onRefresh: refreshTypes,
              onItemTap: (List item) {
                context.push(Routes.manage_Types_TypeDetails, extra: {'typeId': item[0]});
              },
              items: manageTypesProvider.types,
              itemsColumn: [
                null,  //0
                AppLocalizations.of(context)!.type_name, //1
                AppLocalizations.of(context)!.type_description,  //2
              ],
              itemCategories: [
                'other',
                'text',
                'text'
              ],
              refreshController: refreshController
          )
      ),
    );
  }
}
