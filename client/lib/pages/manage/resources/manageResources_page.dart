import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../connection.dart';
import '../../manage/widgets.dart';


class ManageResourcesPage extends StatefulWidget {
  const ManageResourcesPage({super.key});

  @override
  State<ManageResourcesPage> createState() => _ManageResourcesPageState();
}

class _ManageResourcesPageState extends State<ManageResourcesPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var manageResourcesProvider = context.watch<ManageResourcesProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ManageResources():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManageResources extends StatefulWidget {
  const ManageResources({super.key});

  @override
  _ManageResourcesState createState() => _ManageResourcesState();
}

class _ManageResourcesState extends State<ManageResources> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshResources() async {
    var appProvider = context.read<AppProvider>();
    var manageResourcesProvider = context.read<ManageResourcesProvider>();

    try {
      List resources = await Connection.getResources(appProvider);
      manageResourcesProvider.setResources(resources);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    var manageResourcesProvider = context.watch<ManageResourcesProvider>();
    var appProvider = context.watch<AppProvider>();
    List resources = manageResourcesProvider.resources;

    return Scaffold(
      floatingActionButton: appProvider.create_resources ?
      FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_ManageResources_AddResource);
        },
        label: Text(
          AppLocalizations.of(context)!.resource_new_resource,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface
          ),
        ),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
              id: 'manageResources',
              header: [
                AppLocalizations.of(context)!.resource_name,
                AppLocalizations.of(context)!.resource_description,
                AppLocalizations.of(context)!.resource_quantity,
                AppLocalizations.of(context)!.resource_type
              ],
              onRefresh: refreshResources,
              onItemTap: (List item) {
                context.push(Routes.manage_ManageResources_ResourceDetails, extra: {'resourceId': item[0]});
              },
              items: manageResourcesProvider.resources,
              itemsColumn: [
                null,  //0
                AppLocalizations.of(context)!.resource_name, //1
                AppLocalizations.of(context)!.resource_description,  //2
                AppLocalizations.of(context)!.resource_quantity, //3
                null,  //4
                null,  //5
                null, //6
                null,  //7
                null,  //8
                AppLocalizations.of(context)!.resource_type,  //9
              ],
              itemCategories: [
                'other',
                'text',
                'text',
                'number',
                'other',
                'other',
                'other',
                'other',
                'other',
                'text'
              ],
              refreshController: refreshController
          )
      ),
    );
  }
}
