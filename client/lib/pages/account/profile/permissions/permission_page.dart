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
              "Permission",
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
                PermissionTile(allowed: appProvider.view_user, text: 'View Users',),
                PermissionTile(allowed: appProvider.edit_user, text: 'Edit Users',),
                PermissionTile(allowed: appProvider.create_user, text: 'Crete Users',),
                PermissionTile(allowed: appProvider.delete_user, text: 'Delete Users',),

              ],
            ),
        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_userOwnPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_own_user, text: 'View Own Users',),
                PermissionTile(allowed: appProvider.edit_own_user, text: 'Edit Own Users',),
                PermissionTile(allowed: appProvider.create_own_user, text: 'Crete Own Users',),
                PermissionTile(allowed: appProvider.delete_own_users, text: 'Delete Own Users',),
                SizedBox(height: 10,)
              ],
            ),
        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_rolesPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_roles, text: 'View Roles',),
                PermissionTile(allowed: appProvider.edit_roles, text: 'Edit Roles',),
                PermissionTile(allowed: appProvider.create_roles, text: 'Create Roles',),
                PermissionTile(allowed: appProvider.delete_roles, text: 'Delete Roles',),
                SizedBox(height: 10,)
              ],
            ),
        
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_availabilityPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_availability, text: 'View Availability',),
                PermissionTile(allowed: appProvider.edit_availability, text: 'Edit Availability',),
                PermissionTile(allowed: appProvider.create_availability, text: 'Create Availability',),
                PermissionTile(allowed: appProvider.delete_availability, text: 'Delete Availability',),
                SizedBox(height: 10,)
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_resourcesPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_resources, text: 'View Resources',),
                PermissionTile(allowed: appProvider.edit_resources, text: 'Edit Resources',),
                PermissionTile(allowed: appProvider.create_resources, text: 'Create Resources',),
                PermissionTile(allowed: appProvider.delete_resources, text: 'Delete Resources',),
                SizedBox(height: 10,)
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_bookingPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_booking, text: 'View Bookings',),
                PermissionTile(allowed: appProvider.edit_booking, text: 'Edit Bookings',),
                PermissionTile(allowed: appProvider.create_booking, text: 'Create Bookings',),
                PermissionTile(allowed: appProvider.delete_booking, text: 'Delete Bookings',),
                SizedBox(height: 10,)
              ],
            ),

            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.role_userOwnBookingPermissions),
              //subtitle: Text('Leading expansion arrow icon'),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                PermissionTile(allowed: appProvider.view_own_booking, text: 'View Own Bookings',),
                PermissionTile(allowed: appProvider.edit_own_booking, text: 'Edit Own Bookings',),
                PermissionTile(allowed: appProvider.create_own_booking, text: 'Create Own Bookings',),
                PermissionTile(allowed: appProvider.delete_own_booking, text: 'Delete Own Bookings',),
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



class ChangePasswordButtonWidget extends StatelessWidget {
  const ChangePasswordButtonWidget({
    super.key,
    required this.appProvider,
    required this.currentPassword,
    required this.newPassword,
  });

  final AppProvider appProvider;
  final TextEditingController currentPassword;
  final TextEditingController newPassword;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)
        ),
        onPressed: () async {
          bool r = await showSimpleLoadingDialog<bool>(
            context: context,
            future: () async {
              bool r = await Connection.changePassword(
                  appProvider,
                  current_password: currentPassword.text,
                  new_password: newPassword.text
              );
              await Connection.reload(appProvider);
              return r;
            },
          );

          if (r){
            showTopMessage(context, 'Password Changed');
          } else {
            showTopMessage(context, 'Error Occurred');
          }
        },
        child: Text(
          'Change Password',
          style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 20
          ),
        )
    );
  }
}

class ChangePasswordFieldsWidget extends StatelessWidget {
  const ChangePasswordFieldsWidget({
    super.key,
    required this.currentPassword,
    required this.newPassword,
  });

  final TextEditingController currentPassword;
  final TextEditingController newPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(currentPassword, 'Current Password', Icons.abc, obscureText: true),

        SizedBox(height: 20,),

        buildTextField(newPassword, 'New Password', Icons.abc, obscureText: true),

        SizedBox(height: 20,),
      ],
    );
  }
}