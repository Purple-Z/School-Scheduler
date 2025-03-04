import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/pages/resources/resources_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../connection.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var resourcesProvider = context.watch<ResourcesProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources ?
    ResourceFeed():
    Text("access denied!");
  }
}

class ResourceFeed extends StatefulWidget {
  const ResourceFeed({super.key});

  @override
  _ResourceFeedState createState() => _ResourceFeedState();
}

class _ResourceFeedState extends State<ResourceFeed> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> refreshFeed() async {
    var appProvider = context.read<AppProvider>();
    var resourcesProvider = context.read<ResourcesProvider>();

    try {
      List resources_list = await Connection.getResourcesFeed(appProvider);

      Map resources = {};

      for (List resource in resources_list){
        String type = resource[4];
        if (!resources.containsKey(type)){
          resources[type] = [];
        }

        resources[type].add(resource);
      }

      print(resources);

      resourcesProvider.setResources(resources);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    var resourcesProvider = context.watch<ResourcesProvider>();
    var appProvider = context.watch<AppProvider>();
    Map resources = resourcesProvider.resources;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  controller: refreshController,
                  onRefresh: refreshFeed,
                  header: MaterialClassicHeader(),
                  child: ListView(
                    children: resourcesProvider.resources.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Card(
                          color: Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Expanded(child: SizedBox())
                                  ],
                                ),
                                SizedBox(height: 10,),
                                GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  children: [
                                    for (var resource in entry.value)
                                      Card(
                                        child: InkWell(
                                          onTap: () {
                                            context.push(Routes.resources_Resource, extra: {'resourceId': resource[0]});
                                          },
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Expanded(child: SizedBox()),
                                                Expanded(child: Center(child: Text(resource[1].toString()))),
                                                Expanded(child: Column(
                                                  children: [
                                                    Expanded(child: SizedBox()),
                                                    Row(
                                                      children: [
                                                        Expanded(child: SizedBox()),
                                                        if (resource[3] != 1) Text(resource[3].toString()),
                                                        SizedBox(width: 10,)
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,)
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
