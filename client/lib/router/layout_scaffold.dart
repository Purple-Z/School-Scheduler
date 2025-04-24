import 'dart:ui';

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

    LayoutBuilder body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < appState.maxWidth) {
          return Column(
            children: [
              Expanded(child: navigationShell),
              Column(
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
            ],
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
