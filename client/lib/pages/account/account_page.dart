import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../../graphics/graphics_methods.dart';
import '../../router/routes.dart';
import '../../style/svgMappers.dart';
import '../manage/manage_page.dart';
import 'account_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var accountProvider = context.watch<AccountProvider>();
    var appProvider = context.watch<AppProvider>();

    return Center(
      child: appProvider.logged ? LoggedPage() : NotLoggedPage(),
    );
  }
}

class NotLoggedPage extends StatelessWidget {
  const NotLoggedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.account_not_logged,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            context.push(Routes.account_Login);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              AppLocalizations.of(context)!.account_login,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
            ),
          ),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}

class LoggedPage extends StatelessWidget {
  const LoggedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    String x = '';

    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints)
          {
            if (constraints.maxWidth < appProvider.maxWidth) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: AccountButtonsWidget(context, appProvider),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(150, 0, 150, 0),
                child: AccountButtonsWidget(context, appProvider),
              );
            }
          },          
        ),
      ],
    );
  }



  Column AccountButtonsWidget(BuildContext context, AppProvider appProvider) {
    return Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.account_hello,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    appProvider.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.your_account,
                    style: TextStyle(fontSize: 35,),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),


              Row(
                children: [
                  Expanded(
                    child: AccountOptionButton(
                      label: AppLocalizations.of(context)!.account_your_bookings,
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {
                        context.push(Routes.account_UserBookings);
                      },
                    ),
                  ),
                  AccountOptionButton(
                    label: AppLocalizations.of(context)!.account_your_profile,
                    color: Theme.of(context).colorScheme.onPrimary,
                    onTap: () {
                      context.push(Routes.account_Profile);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  OptionButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.sync, color: Theme.of(context).colorScheme.surface, size: 35),
                    ),
                    color: Theme.of(context).colorScheme.onPrimary,
                    onTap: () async {
                      await showSimpleLoadingDialog(
                      context: context,
                      future: () async {
                        await Connection.reload(appProvider);
                        return;
                      },
                      );
                    },
                  ),
                  Expanded(
                    child: AccountOptionButton(
                      label: AppLocalizations.of(context)!.account_settings,
                      color: Theme.of(context).colorScheme.tertiary,
                      onTap: () {
                        context.push(Routes.account_Settings);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}

class AccountOptionButton extends StatelessWidget {
  const AccountOptionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.color
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,30, 20,30),
              child: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 17,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
