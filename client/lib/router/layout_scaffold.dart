import 'dart:ui';

import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: appState.topBarContent,
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WaveWidget(
            config: CustomConfig(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              durations: [
                70000,
                50000,
                30000
              ],
              heightPercentages: [
                -0.5,
                -0.5,
                -0.5,
              ],
            ),
            backgroundColor: Colors.transparent,
            size: Size(double.infinity, 10),
            waveAmplitude: 0,
          ),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Theme.of(context).colorScheme.primary,
              indicatorColor: Theme.of(context).colorScheme.secondary,

              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? TextStyle(color: Theme.of(context).colorScheme.surface)
                  : TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),

            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: destinations
                  .map((destination) =>
                  NavigationDestination(
                    icon: Icon(destination.icon, color: Theme.of(context).colorScheme.surface,),
                    label: destination.label,
                    selectedIcon: Icon(destination.icon, color: Theme.of(context).colorScheme.surface),
                  ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}