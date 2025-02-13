import 'package:client/pages/account/account_provider.dart';
import 'package:client/pages/account/login/login_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/router/router.dart';

import 'app_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ManageProvider()),
        ChangeNotifierProvider(create: (_) => ManageUsersProvider()),
        ChangeNotifierProvider(create: (_) => AddUserProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, dataProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Raises",
            theme: dataProvider.themeData,
            routerConfig: router,
          );
        },
      ),
    );
  }
}