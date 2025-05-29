import 'package:client/app_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/activities/manageActivities_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/pages/manage/bookings/manageBookings_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/pages/manage/requests/manageRequests_page.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../connection.dart';
import '../../graphics/graphics_methods.dart';
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
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var accountProvider = context.watch<ManageProvider>();
    var appProvider = context.watch<AppProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: ListView(
          shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
                  child: Column(
                    children: [

                      //users
                      if (appProvider.view_user) Column(
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
                              MenuAnchor(
                                style: MenuStyle(
                                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
                                ),
                                childFocusNode: _buttonFocusNode,
                                menuChildren: <Widget>[
                                  if (appProvider.create_user) MenuItemButton(
                                      onPressed: () {
                                        context.push(Routes.manage_Users_AddUsers);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.add_circle, color: Theme.of(context).colorScheme.surface),
                                          SizedBox(width: 7,),
                                          Text(
                                            'Add User',
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.surface
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  if (appProvider.create_user) MenuItemButton(
                                      onPressed: () {
                                        context.push(Routes.manage_Users_AddUsersCSV);
                                      },
                                      child: Text(
                                        'Load CSV',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.surface
                                        ),
                                      )
                                  ),
                                  if (appProvider.edit_user) MenuItemButton(
                                      onPressed: () async {
                                        if (!await confirm(context, content: Text("Disconnect All Users?"))){
                                          return;
                                        }
                                        if (await Connection.disconnectUsers(appProvider)){
                                          showTopMessage(context, "All User Disconnected");
                                        }  else {
                                          showTopMessage(context, "Error Occurred", isOK: false);
                                        }
                                      },
                                      child: Text(
                                        'Disconnect all users',
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.surface
                                        ),
                                      )
                                  ),
                                ],
                                builder: (_, MenuController controller, Widget? child) {
                                  return OptionButton(
                                    child: Column(
                                      children: [
                                        Icon(Icons.more_vert, color: Theme.of(context).colorScheme.surface, size: 35,),
                                      ],
                                    ),
                                    focusNode: _buttonFocusNode,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    onTap: () {
                                      if (controller.isOpen) {
                                        controller.close();
                                      } else {
                                        controller.open();
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 30,),
                        ],
                      ),

                      //roles
                      if (appProvider.view_roles) Column(
                        children: [
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
                                    Icon(Icons.add, color: Theme.of(context).colorScheme.surface, size: 35,),
                                  ],
                                ),
                                color: Theme.of(context).colorScheme.onPrimary,
                                onTap: () {
                                  context.push(Routes.manage_Roles_AddRole);
                                },
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
                        ],
                      ),

                      //resources
                      if (appProvider.view_resources) Column(
                        children: [
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
                                    Icon(Icons.add, color: Theme.of(context).colorScheme.surface, size: 35,),
                                  ],
                                ),
                                color: Theme.of(context).colorScheme.onPrimary,
                                onTap: () {
                                  context.push(Routes.manage_ManageResources_AddResource);
                                },
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
                        ],
                      ),

                      if (appProvider.view_booking) Column(
                        children: [
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
  OptionButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.color,
    this.focusNode
  });

  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final FocusNode? focusNode;

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
          focusNode: focusNode,
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