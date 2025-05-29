import 'package:client/app_provider.dart';
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


class ManagePlacesPage extends StatefulWidget {
  const ManagePlacesPage({super.key});

  @override
  State<ManagePlacesPage> createState() => _ManagePlacesPageState();
}

class _ManagePlacesPageState extends State<ManagePlacesPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ManagePlacesAdmin():
    Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ManagePlacesAdmin extends StatefulWidget {
  const ManagePlacesAdmin({super.key});

  @override
  _ManagePlacesAdminState createState() => _ManagePlacesAdminState();
}

class _ManagePlacesAdminState extends State<ManagePlacesAdmin> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshPlaces() async {
    var appProvider = context.read<AppProvider>();
    var managePlacesProvider = context.read<ManagePlacesProvider>();

    try {
      List places = await Connection.getPlaces(appProvider);
      managePlacesProvider.setPlaces(places);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    var managePlacesProvider = context.watch<ManagePlacesProvider>();
    var appProvider = context.watch<AppProvider>();
    List places = managePlacesProvider.places;

    return Scaffold(
      floatingActionButton: appProvider.create_resources ?
        FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.manage_Places_AddPlace);
        },
        label: Text(
          AppLocalizations.of(context)!.place_new_place,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      ) : null,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: DataTableWidget(
              id: 'managePlaces',
              header: [AppLocalizations.of(context)!.place_name, AppLocalizations.of(context)!.place_description],
              onRefresh: refreshPlaces,
              onItemTap: (List item) {
                context.push(Routes.manage_Places_PlaceDetails, extra: {'placeId': item[0]});
              },
              items: managePlacesProvider.places,
              itemsColumn: [
                null,  //0
                AppLocalizations.of(context)!.place_name, //1
                AppLocalizations.of(context)!.place_description,  //2
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
