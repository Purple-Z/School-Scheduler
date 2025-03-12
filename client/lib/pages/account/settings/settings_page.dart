import 'package:client/app_provider.dart';
import 'package:client/pages/account/settings/settings_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';




class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var settingsProvider = context.watch<SettingsProvider>();
    var appProvider = context.watch<AppProvider>();

    return Center(
      child: appProvider.logged ?
      Settings():
      Text('Not Logged'),
    );
  }
}


class Settings extends StatelessWidget {
  const Settings({
    super.key,
  });

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
              Row(
                children: [
                  Text(
                    'Theme',
                    style: TextStyle(fontSize: fontSize1),
                  ),
                  SizedBox(width: 20,),
                  DarlightButton(
                      type: Darlights.DarlightTwo,
                      onChange: (ThemeMode theme) {
                        appProvider.toggleTheme();
                      },
                      options: DarlightTwoOption(
                        darkBackGroundColor: Theme.of(context).colorScheme.primary,
                        lightBackGroundColor: Theme.of(context).colorScheme.primary
                      )
                  ),


                ],
              ),
            ],
          ),


          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}