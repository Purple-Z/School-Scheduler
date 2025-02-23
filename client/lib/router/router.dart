import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/account/account_page.dart';
import 'package:client/pages/account/login/login_page.dart';
import 'package:client/pages/manage/manage_page.dart';
import 'package:client/pages/manage/roles/addRole/addRole_page.dart';
import 'package:client/pages/manage/roles/manageRoles_page.dart';
import 'package:client/pages/manage/roles/manageRoles_provider.dart';
import 'package:client/pages/manage/roles/roleDetails/roleDetails_page.dart';
import 'package:client/pages/manage/roles/roleDetails/roleDetails_provider.dart';
import 'package:client/pages/manage/types/addType/addType_page.dart';
import 'package:client/pages/manage/types/manageTypes_page.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/types/typeDetails/typeDetails_page.dart';
import 'package:client/pages/manage/types/typeDetails/typeDetails_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_page.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_page.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_page.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:client/pages/resources/addResource/addResource_page.dart';
import 'package:client/pages/resources/addResource/addResource_provider.dart';
import 'package:client/pages/resources/manageResources_page.dart';
import 'package:client/pages/resources/manageResources_provider.dart';
import 'package:client/pages/resources/resourceDetails/addAvailability/addAvailability_page.dart';
import 'package:client/pages/resources/resourceDetails/addAvailability/addAvailability_provider.dart';
import 'package:client/pages/resources/resourceDetails/manageAvailability/manageAvailabilityDetails_page.dart';
import 'package:client/pages/resources/resourceDetails/manageAvailability/manageAvailabilitiesDetails_provider.dart';
import 'package:client/pages/resources/resourceDetails/resourceDetails_page.dart';
import 'package:client/pages/resources/resourceDetails/resourceDetails_provider.dart';
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
                  path: Routes.roles,
                  builder: (context, state) => ManageRolesPage(),
                  routes: [
                    GoRoute(
                      path: Routes.addRole,
                      builder: (context, state) => AddRolePage(),
                      onExit: (context) {
                        var manageRolesProvider = Provider.of<ManageRolesProvider>(context, listen: false);
                        manageRolesProvider.loadManageRolesPage(context);
                        return true;
                      },
                    ),
                    GoRoute(
                      path: Routes.roleDetails,
                      builder: (context, state) => RoleDetailsPage(),
                      redirect: (context, state) async {
                        final extraData = state.extra as Map<String, dynamic>?;
                        final roleId = extraData?['roleId'];
                        print("role id: " + roleId.toString());

                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        List role = await Connection.getRole(roleId, appProvider);
                        var userDetailsProvider = Provider.of<RoleDetailsProvider>(context, listen: false);
                        userDetailsProvider.setRole(role);
                        return null;
                      },
                      onExit: (context) {
                        var manageRolesProvider = Provider.of<ManageRolesProvider>(context, listen: false);
                        manageRolesProvider.loadManageRolesPage(context);
                        return true;
                      },
                    ),
                  ]
                ),
                GoRoute(
                  path: Routes.users,
                  builder: (context, state) => ManageUsersPage(),
                  routes: [
                    GoRoute(
                      path: Routes.addUsers,
                      redirect: (context, state) async {
                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        List roles = await Connection.getRoleList(appProvider);
                        var addUserProvider = Provider.of<AddUserProvider>(context, listen: false);
                        addUserProvider.setRoles(roles);
                        return null;
                      },
                      builder: (context, state) => AddUserPage(),
                      onExit: (context) {
                        var manageUsersProvider = Provider.of<ManageUsersProvider>(context, listen: false);
                        manageUsersProvider.loadManageUsersPage(context);
                        return true;
                      },
                    ),
                    GoRoute(
                      path: Routes.userDetails,
                      redirect: (context, state) async {
                        final extraData = state.extra as Map<String, dynamic>?;
                        final userId = extraData?['userId'];

                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        var userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);

                        List user = await Connection.getUser(userId, appProvider);
                        userDetailsProvider.setUser(user);

                        List roles = await Connection.getRoleList(appProvider);
                        userDetailsProvider.setRoles(roles);
                        return null;
                      },
                      builder: (context, state) => UserDetailsPage(),
                      onExit: (context) {
                        var manageUsersProvider = Provider.of<ManageUsersProvider>(context, listen: false);
                        manageUsersProvider.loadManageUsersPage(context);
                        return true;
                      },
                    ),
                  ]
                ),
                GoRoute(
                  path: Routes.types,
                  builder: (context, state) => ManageTypesPage(),
                  routes: [
                    GoRoute(
                      path: Routes.addType,
                      builder: (context, state) => AddTypePage(),
                      onExit: (context) {
                        var manageTypesProvider = Provider.of<ManageTypesProvider>(context, listen: false);
                        manageTypesProvider.loadManageTypesPage(context);
                        return true;
                      },
                    ),
                    GoRoute(
                      path: Routes.typeDetails,
                      redirect: (context, state) async {
                        final extraData = state.extra as Map<String, dynamic>?;
                        final userId = extraData?['typeId'];

                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        var typeDetailsProvider = Provider.of<TypeDetailsProvider>(context, listen: false);

                        List user = await Connection.getType(userId, appProvider);
                        typeDetailsProvider.setType(user);
                        return null;
                      },
                      builder: (context, state) => TypeDetailsPage(),
                      onExit: (context) {
                        var manageTypesProvider = Provider.of<ManageTypesProvider>(context, listen: false);
                        manageTypesProvider.loadManageTypesPage(context);
                        return true;
                      },
                    ),
                  ]
                ),
                GoRoute(
                  path: Routes.manageResources,
                  builder: (context, state) => ManageResourcesPage(),
                  routes: [
                    GoRoute(
                      path: Routes.addResource,
                      redirect: (context, state) async {
                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        List types = await Connection.getTypeList(appProvider);
                        var addResourceProvider = Provider.of<AddResourceProvider>(context, listen: false);
                        addResourceProvider.setTypes(types);
                        return null;
                      },
                      builder: (context, state) => AddResourcePage(),
                      onExit: (context) {
                        var manageUsersProvider = Provider.of<ManageResourcesProvider>(context, listen: false);
                        manageUsersProvider.loadManageResourcesPage(context);
                        return true;
                      },
                    ),
                    GoRoute(
                      path: Routes.resourceDetails,
                      redirect: (context, state) async {
                        final extraData = state.extra as Map<String, dynamic>?;
                        final resourceId = extraData?['resourceId'];

                        var appProvider = Provider.of<AppProvider>(context, listen: false);
                        var resourceDetailsProvider = Provider.of<ResourceDetailsProvider>(context, listen: false);

                        List resource = await Connection.getResource(resourceId, appProvider);
                        resourceDetailsProvider.setResource(resource);

                        List types = await Connection.getTypeList(appProvider);
                        resourceDetailsProvider.setTypes(types);
                        return null;
                      },
                      builder: (context, state) => ResourceDetailsPage(),
                      onExit: (context) {
                        var manageResourcesProvider = Provider.of<ManageResourcesProvider>(context, listen: false);
                        manageResourcesProvider.loadManageResourcesPage(context);
                        return true;
                      },
                    ),
                    GoRoute(
                      path: Routes.manageAvailabilities,
                      redirect: (context, state) async {
                        var manageAvailabilityProvider = Provider.of<ManageAvailabilityProvider>(context, listen: false);
                        var resourceDetailsProvider = Provider.of<ResourceDetailsProvider>(context, listen: false);

                        manageAvailabilityProvider.setResource(resourceDetailsProvider.resource);
                        return null;
                      },
                      builder: (context, state) => ManageAvailabilityPage(),
                    ),
                    GoRoute(
                      path: Routes.addAvailability,
                      redirect: (context, state) async {
                        var addAvailabilityProvider = Provider.of<AddAvailabilityProvider>(context, listen: false);
                        var resourceDetailsProvider = Provider.of<ResourceDetailsProvider>(context, listen: false);

                        addAvailabilityProvider.setResource(resourceDetailsProvider.resource);
                        return null;
                      },
                      builder: (context, state) => AddAvailabilityPage(),
                      onExit: (context) {
                        var availabilityDetailsProvider = Provider.of<ManageAvailabilityProvider>(context, listen: false);
                        availabilityDetailsProvider.loadManageAvailabilitiesPage(context);
                        return true;
                      },
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