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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


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

    return ResourceFeed();
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
    DateTime now = DateTime.now();

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  controller: refreshController,
                  onRefresh: refreshFeed,
                  header: MaterialClassicHeader(),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints)
                    {
                      if (constraints.maxWidth < appProvider.maxWidth) {
                        return SingleChildScrollView(
                          child: Column(
                            children: buildFeedContent(resourcesProvider, context, now),
                          ),
                        );
                      } else {
                        List<Widget> l = buildFeedContent(resourcesProvider, context, now, oriz: true);

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < l.length; i=i+2)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(child: l[i]),
                                    ((i+1) < l.length) ? Expanded(child: l[i+1]) : Expanded(child: SizedBox())
                                  ],
                                )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  List<Padding> buildFeedContent(ResourcesProvider resourcesProvider, BuildContext context, DateTime now, {bool oriz = false}) {
    return resourcesProvider.resources.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10,05),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ExpansionTile(
                            title: Text(
                              entry.key,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            shape: Border(),
                            iconColor: Theme.of(context).colorScheme.surface,
                            collapsedIconColor: Theme.of(context).colorScheme.surface,
                            initiallyExpanded: resourcesProvider.resources.entries.length==1,
                            children: [
                              if (!oriz) SizedBox(height: 10,),
                              GridView.count(
                                childAspectRatio: oriz ? 1 : 1,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: [
                                  for (var resource in entry.value)
                                    Card(
                                      color: Theme.of(context).colorScheme.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          context.push(Routes.resources_Resource, extra: {
                                            'resourceId': resource[0],
                                            'start': DateTime(now.year, now.month, now.day, 0, 0),
                                            'end': DateTime(now.year, now.month, now.day, 23, 59)
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList();
  }
}
