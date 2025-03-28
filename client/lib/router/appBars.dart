import 'package:client/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar standardAppBar(BuildContext context) {
  AppProvider appState = Provider.of<AppProvider>(context, listen: false);

  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.surface,
    title: Text("School Scheduler", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20), // Imposta il raggio di curvatura desiderato
      ),
    ),
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
}