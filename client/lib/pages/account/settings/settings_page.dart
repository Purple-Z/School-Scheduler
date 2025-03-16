import 'package:client/app_provider.dart';
import 'package:client/pages/account/settings/settings_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';





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
      Text(AppLocalizations.of(context)!.settings_not_logged),
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

    void _onLanguageChanged(Locale newLanguage) {
      setState(() {
        appProvider.setLocale(newLanguage);
        appProvider.loadLocale();
      });
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Text(
                AppLocalizations.of(context)!.settings_theme,
                style: TextStyle(fontSize: fontSize1),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
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
                  Expanded(child: SizedBox())
                ],
              ),

              SizedBox(height: 20,),

              Text(
                AppLocalizations.of(context)!.settings_language,
                style: TextStyle(fontSize: fontSize1),
              ),

              SizedBox(height: 10,),

              Row(
                children: [
                  LinguaComboBox(
                    onLinguaChanged: _onLanguageChanged,
                    linguaCorrente: appProvider.locale,
                  ),
                  Expanded(child: SizedBox())
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

class LinguaComboBox extends StatefulWidget {
  final Function(Locale) onLinguaChanged;
  final Locale linguaCorrente;

  LinguaComboBox({required this.onLinguaChanged, required this.linguaCorrente});

  @override
  _LinguaComboBoxState createState() => _LinguaComboBoxState();
}

class _LinguaComboBoxState extends State<LinguaComboBox> {
  late Locale _linguaSelezionata;

  @override
  void initState() {
    super.initState();
    _linguaSelezionata = widget.linguaCorrente;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: _linguaSelezionata,
      onChanged: (Locale? nuovaLingua) {
        if (nuovaLingua != null) {
          setState(() {
            _linguaSelezionata = nuovaLingua;
          });
          widget.onLinguaChanged(nuovaLingua);
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('it'),
          child: Text('Italiano'),
        ),
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
      ],
    );
  }
}