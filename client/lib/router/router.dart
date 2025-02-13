import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/account/account_page.dart';
import 'package:client/pages/account/login/login_page.dart';
import 'package:client/pages/manage/manage_page.dart';
import 'package:client/pages/manage/users/addUser/addUser_page.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_page.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_page.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:client/router/routes.dart';

import 'layout_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.account,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.resources,
              redirect: (context, state) async {

                return null;
              },
              builder: (context, state) => Center(child: const Text("resources")),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.manage,
              builder: (context, state) => ManagePage(),
              redirect: (context, state) async {

                return null;
              },
              routes: [
                GoRoute(
                  path: Routes.users,
                  builder: (context, state) => ManageUsersPage(),
                  redirect: (context, state) async {
                    var manageUsersProvider = Provider.of<ManageUsersProvider>(context, listen: false);
                    manageUsersProvider.loadManageUsersPage(context);
                    return null;
                  },
                  routes: [
                    GoRoute(
                      path: Routes.addUsers,
                      redirect: (context, state) async {

                        return null;
                      },
                      builder: (context, state) => AddUserPage(),
                    ),
                    GoRoute(
                      path: Routes.userDetails,
                      redirect: (context, state) async {
                        final extraData = state.extra as Map<String, dynamic>?;
                        final userId = extraData?['userId'];

                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        List user = await Connection.getUser(userId, appProvider);
                        var userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
                        userDetailsProvider.setUser(user);
                        return null;
                      },
                      builder: (context, state) => UserDetailsPage(),
                    ),
                  ]
                ),
              ]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.account,
              redirect: (context, state) async {
                return null;
              },
              builder: (context, state) => const AccountPage(),
              routes: [
                GoRoute(
                  path: Routes.login,
                  redirect: (context, state) async {
                    return null;
                  },
                  builder: (context, state) => const LoginPage(),
                ),
              ]
            ),
          ],
        ),
      ],
    ),
  ],
);