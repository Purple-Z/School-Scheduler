import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/requests/manageRequests_provider.dart';
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
import '../../functions.dart';
import '../widgets.dart';


class ManageRequestsPage extends StatefulWidget {
  const ManageRequestsPage({super.key});

  @override
  State<ManageRequestsPage> createState() => _ManageRequestsPageState();
}

class _ManageRequestsPageState extends State<ManageRequestsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var manageRequestsProvider = context.watch<ManageRequestsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources && appProvider.view_booking ?
    ManagePendingRequestsAdmin():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManagePendingRequestsAdmin extends StatefulWidget {
  const ManagePendingRequestsAdmin({super.key});

  @override
  _ManagePendingRequestsAdminState createState() => _ManagePendingRequestsAdminState();
}

class _ManagePendingRequestsAdminState extends State<ManagePendingRequestsAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshRequests() async {
    var appProvider = context.read<AppProvider>();
    var manageRequestsProvider = context.read<ManageRequestsProvider>();

    try {
      List pendingBookings = await Connection.getPendingBookings(appProvider);
      manageRequestsProvider.setPendingBookings(pendingBookings);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  getItem(List items){
    print(items.toString());
    List newItems = [];
    for (List item in items){
      List newItem = [];
      for (var quality in item){
        newItem.add(quality);
      }



      for (int i in [1, 2]){
        DateTime dateTime = DateTime.tryParse(newItem[i]) ?? DateTime.now();
        newItem[i] = '${dateTime.year}/${dateTime.month}/${dateTime.day}\n';
        newItem[i] += getTimePrintable(dateTime);
      }

      newItems.add(newItem);
    }
    return newItems;
  }


  @override
  Widget build(BuildContext context) {
    var manageRequestsProvider = context.watch<ManageRequestsProvider>();
    var appProvider = context.watch<AppProvider>();
    List pending_bookings = manageRequestsProvider.requests;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
              header: ['Start', 'End', 'Quantity', 'Resource'],
              onRefresh: refreshRequests,
              onItemTap: (List item) {
                context.push(Routes.manage_Requests_RequestDetails, extra: {'requestId': item[0]});
              },
              items: getItem(manageRequestsProvider.requests),
              itemsColumn: [
                false,  //0
                true, //1
                true,  //2
                true,  //3
                false, //4
                true,  //5
                false,  //6
              ],
              refreshController: refreshController
          )
      ),
    );
  }
}
