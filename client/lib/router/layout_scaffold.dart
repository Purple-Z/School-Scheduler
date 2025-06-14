import 'dart:ui';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:client/app_provider.dart';
import 'package:client/router/destination.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../connection.dart';
import '../style/svgMappers.dart';
import 'appBars.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppProvider>();
    appState.topBarContent = standardAppBar(context);

    Widget loadingWidget = Center(
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Row(
            children: [
              Expanded(child: SizedBox()),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LoadingIndicator(
                      indicatorType: Indicator.circleStrokeSpin,
                      colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary],
                      strokeWidth: 10,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(height: 30,),
          Text(
            appState.loadingText,
            style: TextStyle(
                fontSize: 17
            ),
          ),
          Expanded(child: SizedBox())
        ],
      ),
    );

    Widget noConnectionWidget = Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No Connection',
                style: TextStyle(
                  fontSize: 25
                ),
              ),
              SizedBox(height: 35,),
              SvgPicture.asset(
                'assets/images/undraw_server-down_lxs9.svg',
                width: 150,
                height: 150,
                colorMapper: CustomColorMapper(context),
              ),
              SizedBox(height: 30,),
              Text('Please Estabilish a Connection'),
              SizedBox(height: 25,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try{
                          await showSimpleLoadingDialog(
                            context: context,
                            future: () async {
                              await Connection.reload(appState);
                              return;
                            },
                          );
                          showDialog<String>(
                            context: context,
                            builder:
                                (BuildContext context) => AlertDialog(
                              icon: Icon(Icons.check_circle, size: 50, color: Theme.of(context).colorScheme.tertiary,),
                              title: const Text('Back Online'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Close'),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                          appState.setNoConnection(false);
                        } catch (e) {
                          showDialog<String>(
                            context: context,
                            builder:
                                (BuildContext context) => AlertDialog(
                              icon: Icon(Icons.warning, size: 50,),
                              title: const Text('Connection Refused'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Close'),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                          appState.setNoConnection(true);
                        }

                      },
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 18
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                      ),
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: () {
                      appState.setNoConnection(false);
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 18
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );

    List destinations = [
      Destination(label: AppLocalizations.of(context)!.account, icon: Icons.account_circle_outlined),
      Destination(label: AppLocalizations.of(context)!.resources, icon: Icons.account_balance_rounded),
      if (
        appState.view_user ||
        appState.edit_user ||
        appState.create_user ||
        appState.delete_user ||
        appState.view_roles ||
        appState.edit_roles ||
        appState.create_roles ||
        appState.delete_roles ||
        appState.view_availability ||
        appState.edit_availability ||
        appState.create_availability ||
        appState.delete_availability ||
        appState.view_resources ||
        appState.edit_resources ||
        appState.create_resources ||
        appState.delete_resources ||
        appState.view_booking ||
        appState.edit_booking ||
        appState.create_booking ||
        appState.delete_booking
      ) Destination(label: AppLocalizations.of(context)!.manage, icon: Icons.account_tree_rounded),
    ];

    LayoutBuilder body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < appState.maxWidth) {
          final List<TabItem> items = destinations.map((destination) =>
              TabItem(
                icon: destination.icon, // destination.icon è già IconData
                title: destination.label,
              ),
          ).toList();

          int selectedIndex = navigationShell.currentIndex;
          if (selectedIndex >= items.length) {
            selectedIndex = items.length-1;
          }


          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomBarDefault(
              items: items,
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.surface,
              colorSelected: Theme.of(context).colorScheme.secondary,
              indexSelected: selectedIndex,
              onTap: (index) {
                navigationShell.goBranch(index);
              },
              countStyle: CountStyle(
                background: Theme.of(context).colorScheme.secondary,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              titleStyle: TextStyle(
                fontSize: 14,
              ),
            ),
          );
        } else {
          // Altrimenti, usa NavigationRail
          return Row(
            children: [
              NavigationRailTheme(
                data: NavigationRailThemeData(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
                  unselectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
                  selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
                  unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
                ),
                child: NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: navigationShell.goBranch,
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations
                      .map((destination) =>
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.icon),
                        label: Text(destination.label),
                      ))
                      .toList(),
                ),
              ),
              Expanded(child: navigationShell),
            ],
          );
        }
      },
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          appBar: constraints.maxWidth < appState.maxWidth ? appState.topBarContent : null,
          body: Stack(
            children: [
              body,
              if (appState.isLoading)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: loadingWidget,
                    ),
                  ),
                ),
              if (appState.showNoConnection)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: noConnectionWidget,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
