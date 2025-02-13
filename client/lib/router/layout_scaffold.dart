import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/app_provider.dart';
import 'package:client/router/destination.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppProvider>();
    appState.topBarContent = AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("School Scheduler", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        actions: [
          ElevatedButton(
            onPressed: () {
              appState.toggleTheme();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shadowColor: WidgetStateProperty.all(Colors.transparent),

              maximumSize: WidgetStatePropertyAll(Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height)
              ),

            ),
            child: Icon(appState.iconTheme, color: Theme.of(context).colorScheme.onPrimary,),
          ),
        ]
    );

    return Scaffold(
      appBar: appState.topBarContent,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: destinations
            .map((destination) =>
            NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
              selectedIcon: Icon(destination.icon, color: Colors.white),
            ))
            .toList(),
      ),
    );
  }
}