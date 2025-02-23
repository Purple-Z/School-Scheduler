import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/resources/manageResources_provider.dart';
import 'package:client/pages/resources/resourceDetails/manageAvailability/manageAvailabilitiesDetails_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../connection.dart';
import '../../../manage/widgets.dart';



class ManageAvailabilityPage extends StatefulWidget {
  const ManageAvailabilityPage({super.key});

  @override
  State<ManageAvailabilityPage> createState() => _ManageAvailabilityPageState();
}

class _ManageAvailabilityPageState extends State<ManageAvailabilityPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var manageAvailabilityProvider = context.watch<ManageAvailabilityProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_availability ?
    ManageAvailability():
    Text("access denied!");
  }
}

class ManageAvailability extends StatefulWidget {
  const ManageAvailability({super.key});

  @override
  _ManageAvailabilityState createState() => _ManageAvailabilityState();
}

class _ManageAvailabilityState extends State<ManageAvailability> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshAvailabilities() async {
    var appProvider = context.read<AppProvider>();
    var manageAvailabilityProvider = context.read<ManageAvailabilityProvider>();

    try {
      List availabilities = await Connection.getAvailabilities(appProvider, resource_id: manageAvailabilityProvider.resource[0]);
      manageAvailabilityProvider.setAvailabilities(availabilities);
      refreshController.refreshCompleted();
    } catch (e) {
      print(e);
      refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    var manageAvailabilityProvider = context.watch<ManageAvailabilityProvider>();
    var appProvider = context.watch<AppProvider>();
    List availabilities = manageAvailabilityProvider.availabilities;

    return Scaffold(
      floatingActionButton: appProvider.create_availability ?
      FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_ManageResources_AddAvailability);
        },
        label: Text("New Availability"),
        icon: Icon(Icons.add),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
              header: ['Start', 'End', 'Quantity'],
              onRefresh: refreshAvailabilities,
              onItemTap: (List item) {
                //context.push(Routes.manage_ManageResources_ResourceDetails, extra: {'resourceId': item[0]});
              },
              items: manageAvailabilityProvider.availabilities,
              itemsColumn: [
                false,  //0
                true, //1
                true,  //2
                true, //3
                false,  //4
              ],
              refreshController: refreshController
          )
      ),
    );
  }
}
