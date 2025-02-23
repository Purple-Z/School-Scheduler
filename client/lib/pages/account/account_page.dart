import 'package:client/app_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router/routes.dart';
import 'account_provider.dart';
import 'package:go_router/go_router.dart';




class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var accountProvider = context.watch<AccountProvider>();
    var appProvider = context.watch<AppProvider>();

    return Center(
      child: appProvider.logged ?
      LoggedPage():
      NotLoggedPage(),
    );
  }
}

class NotLoggedPage extends StatelessWidget {
  const NotLoggedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Not Logged", style: TextStyle(fontSize: 30),),
        SizedBox(height: 10,),
        ElevatedButton(
          onPressed: (){
            context.push(Routes.account_Login);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("login", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),),
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}

class LoggedPage extends StatelessWidget {
  const LoggedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();

    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          children: [
            Column(
              children: [
                Text("Signed as"),
                appProvider.provisoryFlag? Text("Student"):SizedBox(height: 0,),
                appProvider.provisoryFlag? Text("Professor"):SizedBox(height: 0,),
                appProvider.provisoryFlag? Text("Leader"):SizedBox(height: 0,),
                appProvider.provisoryFlag? Text("Admin"):SizedBox(height: 0,),
              ],
            ),
            Expanded(child: SizedBox()),
            ElevatedButton(
                onPressed: () {
                  appProvider.logout();
                },
                child: Row(
                  children: [
                    Text("Logout"),
                    SizedBox(width: 10,),
                    Icon(Icons.logout)
                  ],
                )
            ),
          ],
        ),
        SizedBox(height: 30,),
        Row(
          children: [
            Expanded(child: SizedBox()),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text(appProvider.name),
                  ],
                ),
                Row(
                  children: [
                    Text("Surname", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text(appProvider.surname),
                  ],
                ),
                Row(
                  children: [
                    Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text(appProvider.email),
                  ],
                ),
                Row(
                  children: [
                    Text("Token", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    SizedBox(width: 150, child: Text(appProvider.token)),
                  ],
                ),
              ],
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              print(appProvider.roles);
            },
            child: Text("print")
        ),
      ],
    );
  }
}