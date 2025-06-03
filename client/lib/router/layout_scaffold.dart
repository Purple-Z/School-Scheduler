import 'dart:ui';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:client/app_provider.dart';
import 'package:client/router/destination.dart';
import 'package:go_router/go_router.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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

    List destinations = [
      Destination(label: 'account', icon: Icons.account_circle_outlined),
      Destination(label: 'resources', icon: Icons.account_balance_rounded),
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
      ) Destination(label: 'manage', icon: Icons.account_tree_rounded),
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
                      color: Colors.black.withOpacity(0.3), // Sfondo semi-trasparente
                      child: loadingWidget,
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
