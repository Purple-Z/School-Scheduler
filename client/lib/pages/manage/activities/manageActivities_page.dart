import 'package:client/app_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/places/managePlaces_provider.dart';
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


class ManageActivitiesPage extends StatefulWidget {
  const ManageActivitiesPage({super.key});

  @override
  State<ManageActivitiesPage> createState() => _ManageActivitiesPageState();
}

class _ManageActivitiesPageState extends State<ManageActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ManageActivitiesAdmin():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManageActivitiesAdmin extends StatefulWidget {
  const ManageActivitiesAdmin({super.key});

  @override
  _ManageActivitiesAdminState createState() => _ManageActivitiesAdminState();
}

class _ManageActivitiesAdminState extends State<ManageActivitiesAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshActivities() async {
    var appProvider = context.read<AppProvider>();
    var manageActivitiesProvider = context.read<ManageActivitiesProvider>();

    try {
      List activities = await Connection.getActivities(appProvider);
      manageActivitiesProvider.setActivities(activities);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    var manageActivitiesProvider = context.watch<ManageActivitiesProvider>();
    var appProvider = context.watch<AppProvider>();
    List places = manageActivitiesProvider.activities;

    return Scaffold(
      floatingActionButton: appProvider.create_resources ?
        FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_Activities_addActivity);
        },
        label: Text(AppLocalizations.of(context)!.activity_new_activity),
        icon: Icon(Icons.add),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
              header: [AppLocalizations.of(context)!.activity_name, AppLocalizations.of(context)!.activity_description],
              onRefresh: refreshActivities,
              onItemTap: (List item) {
                context.push(Routes.manage_Activities_activityDetails, extra: {'activityId': item[0]});
              },
              items: manageActivitiesProvider.activities,
              itemsColumn: [
                false,  //0
                true, //1
                true,  //2
              ],
              refreshController: refreshController,
              itemCategories: [
                'other',
                'other',
                'other'
              ],
          )
      ),
    );
  }
}
