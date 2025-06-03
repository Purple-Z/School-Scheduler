import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/account/settings/settings_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import '../../../graphics/graphics_methods.dart';
import '../../../router/routes.dart';





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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    nameController.text = appProvider.name;
    surnameController.text = appProvider.surname;
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
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.profile,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox()),
                  ElevatedButton(
                      onPressed: () {
                        appProvider.logout();
                      },
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.account_logout,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.logout,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ],
                      )
                  ),
                ],
              ),
              Text(
                appProvider.email,
                style: TextStyle(fontSize: fontSize1),
              ),

              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints)
                {
                  if (constraints.maxWidth < appProvider.maxWidth) {
                    return Column(
                      children: [
                        ProfileFieldWidget(appProvider: appProvider, nameController: nameController, surnameController: surnameController),
                        SizedBox(height: 20,),
                        ProfileButtonsWidget(appProvider: appProvider, nameController: nameController, surnameController: surnameController)
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ProfileButtonsWidget(appProvider: appProvider, nameController: nameController, surnameController: surnameController),
                        )),
                        SizedBox(width: 20,),
                        Expanded(child: ProfileFieldWidget(appProvider: appProvider, nameController: nameController, surnameController: surnameController)),
                      ],
                    );
                  }
                },
              ),


            ],
          ),


          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class ProfileButtonsWidget extends StatelessWidget {
  const ProfileButtonsWidget({
    super.key,
    required this.appProvider,
    required this.nameController,
    required this.surnameController,
  });

  final AppProvider appProvider;
  final TextEditingController nameController;
  final TextEditingController surnameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (appProvider.edit_own_user & appProvider.view_own_user) SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary)
              ),
              onPressed: () async {
                bool r = await showSimpleLoadingDialog<bool>(
                  context: context,
                  future: () async {
                    bool r = await Connection.updateOwnUser(
                        appProvider,
                        new_name: nameController.text,
                        new_surname: surnameController.text
                    );
                    await Connection.reload(appProvider);
                    return r;
                  },
                );
    
                if (r){
                  showTopMessage(context, AppLocalizations.of(context)!.profile_updated);
                } else {
                  showTopMessage(context, AppLocalizations.of(context)!.error_occurred);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.update_profile,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 20
                ),
              )
          ),
        ),
    
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
              ),
              onPressed: () {
                context.push(Routes.account_Profile_ChangePassword);
              },
              child: Text(
                AppLocalizations.of(context)!.change_password,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 20
                ),
              )
          ),
        ),

        if (appProvider.view_own_user) SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)
              ),
              onPressed: () {
                context.push(Routes.account_Profile_Permission);
              },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.check_permission,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(width: 7,),
                    Icon(Icons.open_in_new, color: Theme.of(context).colorScheme.surface,)
                  ],
                ),
              )
          ),
        )
      ],
    );
  }
}

class ProfileFieldWidget extends StatelessWidget {
  const ProfileFieldWidget({
    super.key,
    required this.appProvider,
    required this.nameController,
    required this.surnameController,
  });

  final AppProvider appProvider;
  final TextEditingController nameController;
  final TextEditingController surnameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (appProvider.view_own_user) SizedBox(height: 30,),
    
        if (appProvider.view_own_user) buildTextField(nameController, AppLocalizations.of(context)!.name, Icons.abc, editable: appProvider.edit_own_user),
    
        if (appProvider.view_own_user) SizedBox(height: 20,),
    
        if (appProvider.view_own_user) buildTextField(surnameController, AppLocalizations.of(context)!.surname, Icons.abc, editable: appProvider.edit_own_user),
      ],
    );
  }
}