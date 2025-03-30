import 'package:client/pages/account/account_provider.dart';
import 'package:client/pages/account/login/login_provider.dart';
import 'package:client/pages/account/profile/chagePassword/changePassword_provider.dart';
import 'package:client/pages/account/profile/profile_provider.dart';
import 'package:client/pages/account/settings/settings_provider.dart';
import 'package:client/pages/account/userBookings/userBookings_provider.dart';
import 'package:client/pages/manage/activities/activityDetails/activityDetails_provider.dart';
import 'package:client/pages/manage/activities/addActivity/addActivity_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/bookings/bookingDetails/bookingDetails_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/places/addPlace/addPlace_provider.dart';
import 'package:client/pages/manage/places/managePlaces_provider.dart';
import 'package:client/pages/manage/places/placeDetails/placeDetails_provider.dart';
import 'package:client/pages/manage/requests/manageRequests_provider.dart';
import 'package:client/pages/manage/requests/requestDetails/requestDetails_provider.dart';
import 'package:client/pages/manage/roles/addRole/addRole_provider.dart';
import 'package:client/pages/manage/roles/manageRoles_provider.dart';
import 'package:client/pages/manage/roles/roleDetails/roleDetails_provider.dart';
import 'package:client/pages/manage/types/addType/addType_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/types/typeDetails/typeDetails_provider.dart';
import 'package:client/pages/manage/users/addUser/addUser_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/users/userDetails/userDetails_provider.dart';
import 'package:client/pages/manage/resources/addResource/addResource_provider.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/addAvailability/addAvailability_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/availabilityDetails/availabilityDetails_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/manageAvailability/manageAvailabilitiesDetails_provider.dart';
import 'package:client/pages/manage/resources/resourceDetails/resourceDetails_provider.dart';
import 'package:client/pages/resources/resource/resource_provider.dart';
import 'package:client/pages/resources/resources_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:client/router/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        ChangeNotifierProvider(create: (_) => ManageRolesProvider()),
        ChangeNotifierProvider(create: (_) => AddRoleProvider()),
        ChangeNotifierProvider(create: (_) => RoleDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ManageTypesProvider()),
        ChangeNotifierProvider(create: (_) => AddTypeProvider()),
        ChangeNotifierProvider(create: (_) => TypeDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ManageResourcesProvider()),
        ChangeNotifierProvider(create: (_) => AddResourceProvider()),
        ChangeNotifierProvider(create: (_) => ResourceDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ManageAvailabilityProvider()),
        ChangeNotifierProvider(create: (_) => AddAvailabilityProvider()),
        ChangeNotifierProvider(create: (_) => AvailabilityDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ResourcesProvider()),
        ChangeNotifierProvider(create: (_) => ResourceProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ManagePlacesProvider()),
        ChangeNotifierProvider(create: (_) => AddPlaceProvider()),
        ChangeNotifierProvider(create: (_) => PlaceDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ManageActivitiesProvider()),
        ChangeNotifierProvider(create: (_) => AddActivityProvider()),
        ChangeNotifierProvider(create: (_) => ActivityDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ManageRequestsProvider()),
        ChangeNotifierProvider(create: (_) => RequestDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ManageBookingsProvider()),
        ChangeNotifierProvider(create: (_) => BookingDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => UserBookingsProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, dataProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Raises",
            theme: dataProvider.themeData,
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: dataProvider.locale,
          );
        },
      ),
    );
  }
}