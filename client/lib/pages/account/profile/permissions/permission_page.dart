import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/account/settings/settings_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import '../../../../graphics/graphics_methods.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var settingsProvider = context.watch<SettingsProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.logged ?
    Permission():
    Center(child: Text(AppLocalizations.of(context)!.profile_not_logged));
  }
}


class Permission extends StatefulWidget {
  const Permission({
    super.key,
  });

  @override
  State<Permission> createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {

  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    double fontSize1 = 20;


    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.permission,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Text(
              appProvider.email,
              style: TextStyle(fontSize: fontSize1),
            ),
        
            SizedBox(height: 30,),

        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_usersPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_user, text: AppLocalizations.of(context)!.role_viewUsers,),
                PermissionTile(allowed: appProvider.edit_user, text: AppLocalizations.of(context)!.role_editUsers,),
                PermissionTile(allowed: appProvider.create_user, text: AppLocalizations.of(context)!.role_createUsers,),
                PermissionTile(allowed: appProvider.delete_user, text: AppLocalizations.of(context)!.role_deleteUsers,),

              ],
            ),
        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_userOwnPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_own_user, text: AppLocalizations.of(context)!.role_viewOwnUser,),
                PermissionTile(allowed: appProvider.edit_own_user, text: AppLocalizations.of(context)!.role_editOwnUser,),
                PermissionTile(allowed: appProvider.create_own_user, text: AppLocalizations.of(context)!.role_createOwnUser,),
                PermissionTile(allowed: appProvider.delete_own_users, text: AppLocalizations.of(context)!.role_deleteOwnUser,),
                SizedBox(height: 10,)
              ],
            ),
        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_rolesPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_roles, text: AppLocalizations.of(context)!.role_viewRoles,),
                PermissionTile(allowed: appProvider.edit_roles, text: AppLocalizations.of(context)!.role_editRoles,),
                PermissionTile(allowed: appProvider.create_roles, text: AppLocalizations.of(context)!.role_createRoles,),
                PermissionTile(allowed: appProvider.delete_roles, text: AppLocalizations.of(context)!.role_deleteRoles,),
                SizedBox(height: 10,)
              ],
            ),
        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_availabilityPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_availability, text: AppLocalizations.of(context)!.role_viewAvailability,),
                PermissionTile(allowed: appProvider.edit_availability, text: AppLocalizations.of(context)!.role_editAvailability,),
                PermissionTile(allowed: appProvider.create_availability, text: AppLocalizations.of(context)!.role_createAvailability,),
                PermissionTile(allowed: appProvider.delete_availability, text: AppLocalizations.of(context)!.role_deleteAvailability,),
                SizedBox(height: 10,)
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_resourcesPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_resources, text: AppLocalizations.of(context)!.role_viewResources,),
                PermissionTile(allowed: appProvider.edit_resources, text: AppLocalizations.of(context)!.role_editResources,),
                PermissionTile(allowed: appProvider.create_resources, text: AppLocalizations.of(context)!.role_createResources,),
                PermissionTile(allowed: appProvider.delete_resources, text: AppLocalizations.of(context)!.role_deleteResources,),
                SizedBox(height: 10,)
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_bookingPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_booking, text: AppLocalizations.of(context)!.role_viewBooking,),
                PermissionTile(allowed: appProvider.edit_booking, text: AppLocalizations.of(context)!.role_editBooking,),
                PermissionTile(allowed: appProvider.create_booking, text: AppLocalizations.of(context)!.role_createBooking,),
                PermissionTile(allowed: appProvider.delete_booking, text: AppLocalizations.of(context)!.role_deleteBooking,),
                SizedBox(height: 10,)
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_userOwnBookingPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_own_booking, text: AppLocalizations.of(context)!.role_viewOwnBooking,),
                PermissionTile(allowed: appProvider.edit_own_booking, text: AppLocalizations.of(context)!.role_editOwnBooking,),
                PermissionTile(allowed: appProvider.create_own_booking, text: AppLocalizations.of(context)!.role_createOwnBooking,),
                PermissionTile(allowed: appProvider.delete_own_booking, text: AppLocalizations.of(context)!.role_deleteOwnBooking,),
                SizedBox(height: 10,)
              ],
            ),

            SizedBox(height: 30,)

          ],
        ),
      ),
    );
  }
}

class PermissionTile extends StatelessWidget {
  const PermissionTile({
    super.key,
    required this.allowed, required this.text,
  });

  final bool allowed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(allowed ? Icons.check_circle : Icons.cancel, color: allowed ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,),
          SizedBox(width: 7,),
          Text(
            text,
            style: TextStyle(
              color: allowed ? Theme.of(context).colorScheme.onSurface : Color.lerp(Theme.of(context).colorScheme.onSurface, Theme.of(context).colorScheme.surface, 0.6),
              fontSize: 17
            ),
          ),
        ],
      ),
    );
  }
}