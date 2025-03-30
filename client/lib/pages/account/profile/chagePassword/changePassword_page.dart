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






class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var settingsProvider = context.watch<SettingsProvider>();
    var appProvider = context.watch<AppProvider>();

    return Center(
      child: appProvider.logged ?
      Settings():
      Text(AppLocalizations.of(context)!.profile_not_logged),
    );
  }
}


class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    currentPassword.text = '';
    newPassword.text = '';
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    double fontSize1 = 20;


    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Change Password",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Text(
                appProvider.email,
                style: TextStyle(fontSize: fontSize1),
              ),

              SizedBox(height: 30,),

              buildTextField(currentPassword, 'Current Password', Icons.abc, obscureText: true),

              SizedBox(height: 20,),

              buildTextField(newPassword, 'New Password', Icons.abc, obscureText: true),

              SizedBox(height: 20,),

              ElevatedButton(
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
              )
            ],
          ),


          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}