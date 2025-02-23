import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router/routes.dart';
import 'package:go_router/go_router.dart';


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

    return Column(
      children: [
        SizedBox(height: 25,),
        if (appProvider.view_user) ManageUserWidget(),
        if (appProvider.view_roles) ManageRolesWidget(),
        if (appProvider.view_resources) ManageTypesWidget(),
        if (appProvider.view_resources) ManageResourcesWidget(),
      ],
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
                "Manage Users",
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
                  Text("Go to page"),
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
                "Manage Roles",
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
                  Text("Go to page"),
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
                "Manage Types",
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
                  Text("Go to page"),
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
                "Manage Resources",
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
                  Text("Go to page"),
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