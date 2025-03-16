import 'package:client/app_provider.dart';
import 'package:client/pages/account/settings/settings_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';





class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    double fontSize1 = 20;


    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Profile",
                style: TextStyle(fontSize: fontSize1),
              ),
            ],
          ),


          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}