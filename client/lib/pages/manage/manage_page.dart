import 'package:client/app_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var accountProvider = context.watch<ManageProvider>();
    var appProvider = context.watch<AppProvider>();

    return Expanded(
      child: ListView(
        children:
        [
          SizedBox(height: 25,),
          if (appProvider.view_user) ManageUserWidget(),
          if (appProvider.view_roles) ManageRolesWidget(),
          if (appProvider.view_resources) ManageTypesWidget(),
          if (appProvider.view_resources) ManagePlacesWidget(),
          if (appProvider.view_resources) ManageActivitiesWidget(),
          if (appProvider.view_resources) ManageResourcesWidget(),
          if (appProvider.view_resources) ManageRequestsPage(),
        ]
      ),
    );
  }
}

class ManageUserWidget extends StatelessWidget {
  const ManageUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.manage_users,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_Users);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.manage_accounts_rounded)
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ManageRolesWidget extends StatelessWidget {
  const ManageRolesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.manage_roles,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_Roles);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.security)
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ManageTypesWidget extends StatelessWidget {
  const ManageTypesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.manage_types,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_Types);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.type_specimen)
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ManagePlacesWidget extends StatelessWidget {
  const ManagePlacesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.manage_places,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_Places);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.place)
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ManageActivitiesWidget extends StatelessWidget {
  const ManageActivitiesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.manage_activities,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_Activities);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.directions_run)
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ManageResourcesWidget extends StatelessWidget {
  const ManageResourcesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.manage_resources,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_ManageResources);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.account_balance_rounded)
                ],
              )
          ),
        ],
      ),
    );
  }
}


class ManageRequestsWidget extends StatelessWidget {
  const ManageRequestsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Manage Requests',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
              onPressed: () {
                context.push(Routes.manage_Requests);
              },
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.manage_go_to_page),
                  SizedBox(width: 10,),
                  Icon(Icons.account_balance_rounded)
                ],
              )
          ),
        ],
      ),
    );
  }
}