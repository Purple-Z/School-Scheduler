import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/account/account_page.dart';
import 'package:client/pages/account/login/login_page.dart';
import 'package:client/pages/account/profile/chagePassword/changePassword_page.dart';
import 'package:client/pages/account/profile/permissions/permission_page.dart';
import 'package:client/pages/account/profile/profile_page.dart';
import 'package:client/pages/account/settings/settings_page.dart';
import 'package:client/pages/account/userBookings/userBookings_page.dart';
import 'package:client/pages/manage/activities/activityDetails/activityDetails_page.dart';
import 'package:client/pages/manage/activities/activityDetails/activityDetails_provider.dart';
import 'package:client/pages/manage/activities/addActivity/addActivity_page.dart';
import 'package:client/pages/manage/activities/manageActivities_page.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_page.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/pages/manage/manage_page.dart';
import 'package:client/pages/manage/places/addPlace/addPlace_page.dart';
import 'package:client/pages/manage/places/managePlaces_provider.dart';
import 'package:client/pages/manage/places/placeDetails/placeDetails_page.dart';
import 'package:client/pages/manage/places/placeDetails/placeDetails_provider.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/pages/manage/requests/manageRequests_provider.dart';
import 'package:client/pages/manage/requests/requestDetails/requestDetails_page.dart';
import 'package:client/pages/manage/requests/requestDetails/requestDetails_provider.dart';
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
import 'package:client/pages/manage/users/addUserCSV/addUserCSV_page.dart';
import 'package:client/pages/manage/users/manageUsers_page.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_page.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:client/pages/manage/resources/addResource/addResource_page.dart';
import 'package:client/pages/manage/resources/addResource/addResource_provider.dart';
import 'package:client/pages/manage/resources/manageResources_page.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/addAvailability/addAvailability_page.dart';
import 'package:client/pages/manage/resources/resourceDetails/addAvailability/addAvailability_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/availabilityDetails/availabilityDetails_page.dart';
import 'package:client/pages/manage/resources/resourceDetails/availabilityDetails/availabilityDetails_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/manageAvailability/manageAvailabilityDetails_page.dart';
import 'package:client/pages/manage/resources/resourceDetails/manageAvailability/manageAvailabilitiesDetails_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/resourceDetails_page.dart';
import 'package:client/pages/manage/resources/resourceDetails/resourceDetails_provider.dart';
import 'package:client/pages/resources/resource/resource_provider.dart';
import 'package:client/pages/resources/resources_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:client/router/routes.dart';

import '../pages/manage/classes.dart';
import '../pages/manage/places/managePlaces_page.dart';
import '../pages/resources/resource/resource_page.dart';
import 'layout_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
                path: Routes.account,
                builder: (context, state) => const AccountPage(),
                routes: [
                  GoRoute(
                    path: Routes.login,
                    builder: (context, state) => const LoginPage(),
                  ),
                  GoRoute(
                    path: Routes.settings,
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                      path: Routes.profile,
                      builder: (context, state) => const ProfilePage(),
                      routes: [
                        GoRoute(
                          path: Routes.changePassword,
                          builder: (context, state) => const ChangePasswordPage(),
                        ),
                        GoRoute(
                          path: Routes.permission,
                          builder: (context, state) => const PermissionPage(),
                        ),
                      ]
                  ),
                  GoRoute(
                    path: Routes.userBookings,
                    builder: (context, state) => const UserBookingsPage(),
                  ),
                ]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.resources,
                builder: (context, state) => ResourcesPage(),
                routes: [
                  GoRoute(
                    path: Routes.networkError,
                    builder: (context, state) => Expanded(child: Center(child: Text('Network\nError', style: TextStyle(fontSize: 25,),textAlign: TextAlign.center,),)),
                  ),
                  GoRoute(
                    path: Routes.resource,
                    builder: (context, state) => ResourcePage(),
                    redirect: (context, state) async {
                      var appProvider = Provider.of<AppProvider>(context, listen: false);

                      appProvider.setLoading(true);

                      try {
                        appProvider.setLoadingText(AppLocalizations.of(context)!.loading);

                        var resourceProvider = Provider.of<ResourceProvider>(context, listen: false);
                        final extraData = state.extra as Map<String, dynamic>?;

                        final resource_Id = extraData?['resourceId'];
                        resourceProvider.setResourceId(resource_Id);

                        final start = extraData?['start'];
                        resourceProvider.setStart(start);

                        final end = extraData?['end'];
                        resourceProvider.setEnd(end);

                        appProvider.setLoadingText(AppLocalizations.of(context)!.getting_places_list);
                        List places = await Connection.getPlaceList(appProvider);
                        resourceProvider.setPlaces(places, context);

                        appProvider.setLoadingText(AppLocalizations.of(context)!.getting_activity_list);
                        List activities = await Connection.getActivityList(appProvider);
                        resourceProvider.setActivities(activities, context);

                        appProvider.setLoadingText(AppLocalizations.of(context)!.loading);
                        await resourceProvider.loadResourcePage(context);

                      } catch (e, s) {
                        appProvider.setLoading(false);
                        return Routes.resource_NetworkError;
                      }

                      appProvider.setLoading(false);

                      return null;
                    },
                  ),
                ]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.manage,
                builder: (context, state) => ManagePage(),
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
                            var appProvider = Provider.of<AppProvider>(context, listen: false);

                            appProvider.setLoading(true);

                            try {
                              appProvider.setLoadingText(AppLocalizations.of(context)!.loading);

                              final roleId = extraData?['roleId'];
                              print("role id: " + roleId.toString());

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_role_info);
                              List role = await Connection.getRole(roleId, appProvider);
                              var userDetailsProvider = Provider.of<RoleDetailsProvider>(context, listen: false);
                              userDetailsProvider.setRole(role);

                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }

                            appProvider.setLoading(false);

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

                            appProvider.setLoading(true);


                            try {
                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_roles_list);
                              List roles = await Connection.getRoleList(appProvider);
                              var addUserProvider = Provider.of<AddUserProvider>(context, listen: false);
                              addUserProvider.setRoles(roles);
                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }

                            appProvider.setLoading(false);

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
                          path: Routes.addUsersCSV,
                          builder: (context, state) => AddUsersCSVPage(),
                        ),
                        GoRoute(
                          path: Routes.userDetails,
                          redirect: (context, state) async {
                            var appProvider = Provider.of<AppProvider>(context, listen: false);

                            appProvider.setLoading(true);

                            try {

                              appProvider.setLoadingText(AppLocalizations.of(context)!.loading);

                              final extraData = state.extra as Map<String, dynamic>?;
                              final userId = extraData?['userId'];

                              var userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_user_info);
                              List user = await Connection.getUser(userId, appProvider);
                              userDetailsProvider.setUser(user);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_roles_list);
                              List roles = await Connection.getRoleList(appProvider);
                              userDetailsProvider.setRoles(roles);

                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }


                            appProvider.setLoading(false);

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
                            var appProvider = Provider.of<AppProvider>(context, listen: false);

                            appProvider.setLoading(true);

                            try {

                              appProvider.setLoadingText(AppLocalizations.of(context)!.loading);

                              final extraData = state.extra as Map<String, dynamic>?;
                              final userId = extraData?['typeId'];

                              var typeDetailsProvider = Provider.of<TypeDetailsProvider>(context, listen: false);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_type_info);
                              List user = await Connection.getType(userId, appProvider);
                              typeDetailsProvider.setType(user);

                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }

                            appProvider.setLoading(false);

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
                      path: Routes.places,
                      builder: (context, state) => ManagePlacesPage(),
                      routes: [
                        GoRoute(
                          path: Routes.addPlace,
                          builder: (context, state) => AddPlacePage(),
                          onExit: (context) {
                            var managePlacesProvider = Provider.of<ManagePlacesProvider>(context, listen: false);
                            managePlacesProvider.loadManagePlacesPage(context);
                            return true;
                          },
                        ),
                        GoRoute(
                          path: Routes.placeDetails,
                          redirect: (context, state) async {
                            var appProvider = Provider.of<AppProvider>(context, listen: false);

                            appProvider.setLoading(true);

                            try {
                              appProvider.setLoadingText(AppLocalizations.of(context)!.loading);

                              final extraData = state.extra as Map<String, dynamic>?;
                              final placeId = extraData?['placeId'];

                              var placeDetailsProvider = Provider.of<PlaceDetailsProvider>(context, listen: false);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_place_info);

                              List place = await Connection.getPlace(placeId, appProvider);
                              placeDetailsProvider.setPlace(place);

                            } catch (error) {}

                            appProvider.setLoading(false);


                            return null;
                          },
                          builder: (context, state) => PlaceDetailsPage(),
                          onExit: (context) {
                            var managePlacesProvider = Provider.of<ManagePlacesProvider>(context, listen: false);
                            managePlacesProvider.loadManagePlacesPage(context);
                            return true;
                          },
                        ),
                      ]
                  ),
                  GoRoute(
                      path: Routes.activities,
                      builder: (context, state) => ManageActivitiesPage(),
                      routes: [
                        GoRoute(
                          path: Routes.addActivity,
                          builder: (context, state) => AddActivityPage(),
                          onExit: (context) {
                            var manageActivitiesProvider = Provider.of<ManageActivitiesProvider>(context, listen: false);
                            manageActivitiesProvider.loadManageActivitiesPage(context);
                            return true;
                          },
                        ),
                        GoRoute(
                          path: Routes.activityDetails,
                          redirect: (context, state) async {
                            var appProvider = Provider.of<AppProvider>(context, listen: false);

                            appProvider.setLoading(true);

                            try {
                              appProvider.setLoadingText(AppLocalizations.of(context)!.loading);

                              final extraData = state.extra as Map<String, dynamic>?;
                              final activityId = extraData?['activityId'];

                              var activityDetailsProvider = Provider.of<ActivityDetailsProvider>(context, listen: false);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_activity_info);
                              List activity = await Connection.getActivity(activityId, appProvider);
                              activityDetailsProvider.setActivity(activity);

                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }

                            appProvider.setLoading(false);

                            return null;
                          },
                          builder: (context, state) => ActivityDetailsPage(),
                          onExit: (context) {
                            var manageActivitiesProvider = Provider.of<ManageActivitiesProvider>(context, listen: false);
                            manageActivitiesProvider.loadManageActivitiesPage(context);
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

                            appProvider.setLoading(true);


                            try {
                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_types_list);
                              List types = await Connection.getTypeList(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_places_list);
                              List places = await Connection.getPlaceList(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_activities_list);
                              List activities = await Connection.getActivityList(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_users_list);
                              List users = await Connection.getUsers(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.setting_the_parameters);

                              var addResourceProvider = Provider.of<AddResourceProvider>(context, listen: false);
                              addResourceProvider.setTypes(types);
                              addResourceProvider.setPlaces(places, context);
                              addResourceProvider.setActivities(activities, context);
                              addResourceProvider.setUsers(users);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_roles_list);
                              List roles_with_description = await Connection.getRoleList(appProvider);
                              List<String> roles = [];
                              for (List element in roles_with_description){
                                roles.add(element[0]);
                              }

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_permissions_list);
                              Map roles_permission = await Connection.getResourcePermission(appProvider, roles: roles);
                              addResourceProvider.setResourcePermission(roles_permission);
                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }

                            appProvider.setLoading(false);



                            return null;
                          },
                          builder: (context, state) => AddResourcePage(),
                          onExit: (context) {
                            var manageUsersProvider = Provider.of<ManageResourcesProvider>(context, listen: false);
                            var addResourceProvider = Provider.of<AddResourceProvider>(context, listen: false);
                            addResourceProvider.auto_accept_check = false;
                            addResourceProvider.over_bookig_check = false;
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

                            appProvider.setLoading(true);

                            try {
                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_types_list);
                              List types = await Connection.getTypeList(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_places_list);
                              List places = await Connection.getPlaceList(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_activity_list);
                              List activities = await Connection.getActivityList(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_users_list);
                              List users = await Connection.getUsers(appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_resource_content);
                              List resource = await Connection.getResource(resourceId, appProvider);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.setting_the_parameters);

                              resourceDetailsProvider.setTypes(types);
                              resourceDetailsProvider.setPlaces(places, context);
                              resourceDetailsProvider.setActivities(activities, context);
                              resourceDetailsProvider.setUsers(users);
                              resourceDetailsProvider.setResource(resource);

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_roles_list);
                              List roles_with_description = await Connection.getRoleList(appProvider);
                              List<String> roles = [];
                              for (List element in roles_with_description){
                                roles.add(element[0]);
                              }

                              appProvider.setLoadingText(AppLocalizations.of(context)!.getting_permissions_list);
                              Map roles_permission = await Connection.getResourcePermission(appProvider, roles: roles, resource_id: resource[0]);
                              resourceDetailsProvider.setResourcePermission(roles_permission);
                            } catch (e, s) {
                              appProvider.setLoading(false);
                              return Routes.resource_NetworkError;
                            }

                            appProvider.setLoading(false);


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
                        GoRoute(
                          path: Routes.availabilityDetails,
                          redirect: (context, state) async {
                            final extraData = state.extra as Map<String, dynamic>?;
                            final availabilityID = extraData?['availabilityId'];

                            var appProvider = Provider.of<AppProvider>(context, listen: false);
                            var availabilityDetailsProvider = Provider.of<AvailabilityDetailsProvider>(context, listen: false);

                            List availability = await Connection.getAvailability(availabilityID, appProvider);
                            availabilityDetailsProvider.setAvailability(availability);

                            var resourceDetailsProvider = Provider.of<ResourceDetailsProvider>(context, listen: false);
                            availabilityDetailsProvider.setResource(resourceDetailsProvider.resource);
                            return null;
                          },
                          builder: (context, state) => AvailabilityDetailsPage(),
                          onExit: (context) {
                            var availabilityDetailsProvider = Provider.of<ManageAvailabilityProvider>(context, listen: false);
                            availabilityDetailsProvider.loadManageAvailabilitiesPage(context);
                            return true;
                          },
                        ),
                      ]
                  ),
                  GoRoute(
                      path: Routes.requests,
                      builder: (context, state) => ManageRequestsPage(),
                      routes: [
                        GoRoute(
                          path: Routes.requestDetails,
                          builder: (context, state) => RequestDetailsPage(),
                          redirect: (context, state) async {
                            final extraData = state.extra as Map<String, dynamic>?;
                            final requestId = extraData?['requestId'];
                            print("request id: " + requestId.toString());

                            var appProvider = Provider.of<AppProvider>(context, listen: false);
                            var requestDetailsProvider = Provider.of<RequestDetailsProvider>(context, listen: false);
                            var manageRequestsProvider = Provider.of<ManageRequestsProvider>(context, listen: false);
                            List request = [];

                            for (List r in manageRequestsProvider.requests){
                              if (r[0] == requestId){
                                request = r;
                                break;
                              }
                            }

                            if (request.isEmpty){
                              return null;
                            }

                            requestDetailsProvider.setRequest(request);
                            return null;
                          },
                          onExit: (context) {
                            var manageRequestsProvider = Provider.of<ManageRequestsProvider>(context, listen: false);
                            manageRequestsProvider.loadManageRequestsPage(context);
                            return true;
                          },
                        ),
                      ]
                  ),
                  GoRoute(
                    path: Routes.bookings,
                    builder: (context, state) => ManageBookingsPage(),
                  ),
                ]
            ),
          ],
        ),
      ],
    ),
  ],
);