import 'package:client/app_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../account/account_page.dart';



class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var accountProvider = context.watch<ManageProvider>();
    var appProvider = context.watch<AppProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Users",
                            style: TextStyle(fontSize: 35,),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OptionButton(
                              child: Text(
                                "Users",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                              onTap: () {
                                context.push(Routes.manage_Users);
                              },
                            ),
                          ),
                          OptionButton(
                            child: Column(
                              children: [
                                Icon(Icons.more_vert, color: Theme.of(context).colorScheme.surface, size: 35,),
                              ],
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onTap: () {
                              context.push(Routes.account_Profile);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Roles",
                            style: TextStyle(fontSize: 35,),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OptionButton(
                            child: Column(
                              children: [
                                Icon(Icons.more_vert, color: Theme.of(context).colorScheme.surface, size: 35,),
                              ],
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onTap: () {},
                          ),
                          Expanded(
                            child: OptionButton(
                              child: Text(
                                "Roles",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              color: Theme.of(context).colorScheme.tertiary,
                              onTap: () {
                                context.push(Routes.manage_Roles);
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30,),

                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Resources",
                            style: TextStyle(fontSize: 35,),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OptionButton(
                              child: Text(
                                "Resources",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                context.push(Routes.manage_ManageResources);
                              },
                            ),
                          ),
                          OptionButton(
                            child: Column(
                              children: [
                                Icon(Icons.more_vert, color: Theme.of(context).colorScheme.surface, size: 35,),
                              ],
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onTap: () {},
                          ),
                        ],
                      ),
                      OptionButton(
                        child: Text(
                          "Types",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        color: Theme.of(context).colorScheme.onPrimary,
                        onTap: () {
                          context.push(Routes.manage_Types);
                        },
                      ),
                      OptionButton(
                        child: Text(
                          "Places",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        color: Theme.of(context).colorScheme.onPrimary,
                        onTap: () {
                          context.push(Routes.manage_Places);
                        },
                      ),
                      OptionButton(
                        child: Text(
                          "Activities",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        color: Theme.of(context).colorScheme.onPrimary,
                        onTap: () {
                          context.push(Routes.manage_Activities);
                        },
                      ),

                      SizedBox(height: 30,),

                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Bookings",
                            style: TextStyle(fontSize: 35,),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OptionButton(
                              child: Text(
                                "Bookings",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                context.push(Routes.manage_Bookings);
                              },
                            ),
                          ),
                          OptionButton(
                            child: Column(
                              children: [
                                Icon(Icons.more_vert, color: Theme.of(context).colorScheme.surface, size: 35,),
                              ],
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onTap: () {},
                          ),
                        ],
                      ),
                      OptionButton(
                        child: Text(
                          "Requests",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        color: Theme.of(context).colorScheme.onPrimary,
                        onTap: () {
                          context.push(Routes.manage_Requests);
                        },
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,)
            ]
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.color
  });

  final Widget child;
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
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}