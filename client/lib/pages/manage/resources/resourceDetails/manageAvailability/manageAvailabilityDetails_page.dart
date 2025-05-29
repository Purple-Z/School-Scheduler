import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/manageAvailability/manageAvailabilitiesDetails_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:client/pages/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../../connection.dart';
import '../../../../manage/widgets.dart';



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
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManageAvailability extends StatefulWidget {
  const ManageAvailability({super.key});

  @override
  _ManageAvailabilityState createState() => _ManageAvailabilityState();
}

class _ManageAvailabilityState extends State<ManageAvailability> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);
  DateTime dateFor = DateTime.now();

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

  getItem(List items){
    print(items.toString());
    List newItems = [];
    for (List item in items){
      List newItem = [];
      for (var quality in item){
        newItem.add(quality);
      }

      DateTime startDateTime = DateTime.tryParse(newItem[1]) ?? DateTime.now();
      if (startDateTime.year != dateFor.year || startDateTime.month != dateFor.month || startDateTime.day != dateFor.day){
        continue;
      }

      newItems.add(newItem);
    }
    return newItems;
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
        label: Text(
          AppLocalizations.of(context)!.availability_new_availability,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface
          ),
        ),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface,),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10,),
                  ElevatedButton(
                    style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                    onPressed: () async {
                      DateTime? pickedDate = await selectDate(context, dateFor, firstDate: DateTime(2025));
                  
                      if (pickedDate != null) {
                        setState(() {
                          dateFor = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      getDatePrintable(dateFor, context),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
              Expanded(
                child: DataTableWidget(
                    id: 'manageAvailabilityDetails',
                    header: [
                      AppLocalizations.of(context)!.availability_start,
                      AppLocalizations.of(context)!.availability_end,
                      AppLocalizations.of(context)!.availability_quantity
                    ],
                    onRefresh: refreshAvailabilities,
                    onItemTap: (List item) {
                      context.push(Routes.manage_ManageResources_AvailabilityDetails, extra: {'availabilityId': item[0]});
                    },
                    items: getItem(manageAvailabilityProvider.availabilities),
                    itemsColumn: [
                      null,  //0
                      AppLocalizations.of(context)!.availability_start, //1
                      AppLocalizations.of(context)!.availability_end,  //2
                      AppLocalizations.of(context)!.availability_quantity, //3
                      null,  //4
                    ],
                    itemCategories: [
                      'other',
                      'time',
                      'time',
                      'number',
                      'other'
                    ],
                    refreshController: refreshController
                ),
              ),
            ],
          )
      ),
    );
  }
}
