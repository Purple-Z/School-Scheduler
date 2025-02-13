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
        if (appProvider.admin) AdminManageWidget(),
      ],
    );
  }
}

class AdminManageWidget extends StatelessWidget {
  const AdminManageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.push(Routes.manage_Users);
        },
        child: Row(
          children: [
            Text("Manage users"),
            SizedBox(width: 10,),
            Icon(Icons.manage_accounts_rounded)
          ],
        )
    );
  }
}