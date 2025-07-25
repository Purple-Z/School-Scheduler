import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/pages/resources/resource/resource_provider.dart';
import 'package:client/pages/resources/resources_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../connection.dart';
import '../../../graphics/graphics_methods.dart';
import '../../../router/appBars.dart';
import '../../../style/svgMappers.dart';
import '../../functions.dart';
import '../../manage/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResourcePage extends StatefulWidget {
  const ResourcePage({super.key});

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var resourceProvider = context.watch<ResourceProvider>();
    var appProvider = context.watch<AppProvider>();

    return appProvider.view_resources
        ? ResourceDetails()
        : Text(AppLocalizations.of(context)!.access_denied);
  }
}

class ResourceDetails extends StatefulWidget {
  const ResourceDetails({super.key});

  @override
  _ResourceDetailsState createState() => _ResourceDetailsState();
}

class _ResourceDetailsState extends State<ResourceDetails> with TickerProviderStateMixin {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final TextEditingController quantityController = TextEditingController();
  late TabController _tabController3tab;
  late TabController _tabController2tab;
  int maxAvailabilityValue = 0;
  bool maxAvailabilityShow = false;

  @override
  void initState() {
    super.initState();
    _tabController3tab = TabController(vsync: this, length: 3, initialIndex: 1);
    _tabController2tab = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  Future<void> refreshShifts() async {
    var appProvider = context.read<AppProvider>();
    var resourceProvider = context.read<ResourceProvider>();

    try {
      await resourceProvider.loadResourcePage(context);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }



  @override
  Widget build(BuildContext context) {
    var resourceProvider = context.watch<ResourceProvider>();
    var appProvider = context.watch<AppProvider>();
    List resource = resourceProvider.resource;
    List listItems = resourceProvider.getItem(context);
    const double fontSizeTab1 = 25;

    const double fontSize1 = 15;
    const double rowSpacing1 = 5;

    const double fontSize2 = 20;
    const double rowSpacing2 = 10;


    print('controller length: ' + resourceProvider.numTab.toString());


    return listItems.length != 0 ? Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottom: TabBar(
          controller: _tabController3tab,
          tabs: [
            Tab(icon: Icon(Icons.date_range), text: AppLocalizations.of(context)!.select,),
            Tab(icon: Icon(Icons.calendar_month_sharp), text: AppLocalizations.of(context)!.view,),
            Tab(icon: Icon(Icons.edit_calendar), text: AppLocalizations.of(context)!.book,),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController3tab,
        children: [
          buildSelectPage(context, fontSizeTab1, rowSpacing1, resourceProvider, rowSpacing2, _tabController3tab),
          buildViewPage(listItems, context, resourceProvider, _tabController3tab),
          buildBookPage(listItems, resourceProvider, context, fontSize2, rowSpacing2, fontSize1, appProvider),
        ],
      ),
    ):

    Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottom: TabBar(
          controller: _tabController2tab,
          tabs: [
            Tab(icon: Icon(Icons.date_range), text: AppLocalizations.of(context)!.select,),
            Tab(icon: Icon(Icons.calendar_month_sharp), text: AppLocalizations.of(context)!.view,),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController2tab,
        children: [
          buildSelectPage(context, fontSizeTab1, rowSpacing1, resourceProvider, rowSpacing2, _tabController2tab),
          buildViewPage(listItems, context, resourceProvider, _tabController2tab),
        ],
      ),
    );
  }

  Center buildSelectPage(BuildContext context, double fontSizeTab1, double rowSpacing1, ResourceProvider resourceProvider, double rowSpacing2, TabController currTabController) {
    return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    AppLocalizations.of(context)!.book_from,
                    style: TextStyle(fontSize: fontSizeTab1),
                  ),
                  SizedBox(
                    width: rowSpacing1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      DateTime? pickedDate =
                      await selectDate(context, resourceProvider.start);

                      if (pickedDate != null) {
                        setState(() {
                          resourceProvider.start = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      getDatePrintable(resourceProvider.start, context),
                      style: TextStyle(fontSize: fontSizeTab1),
                    ),
                  ),
                  SizedBox(
                    width: rowSpacing1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      DateTime? pickedDate =
                      await selectTime(context, resourceProvider.start);

                      if (pickedDate != null) {
                        setState(() {
                          resourceProvider.start = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      getTimePrintable(resourceProvider.start),
                      style: TextStyle(fontSize: fontSizeTab1),
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
              SizedBox(height: rowSpacing1,),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    AppLocalizations.of(context)!.book_To,
                    style: TextStyle(fontSize: fontSizeTab1),
                  ),
                  SizedBox(
                    width: rowSpacing1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      DateTime? pickedDate =
                      await selectDate(context, resourceProvider.end);

                      if (pickedDate != null) {
                        setState(() {
                          resourceProvider.end = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      getDatePrintable(resourceProvider.end, context),
                      style: TextStyle(fontSize: fontSizeTab1),
                    ),
                  ),
                  SizedBox(
                    width: rowSpacing1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      DateTime? pickedDate =
                      await selectTime(context, resourceProvider.end);

                      if (pickedDate != null) {
                        setState(() {
                          resourceProvider.end = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      getTimePrintable(resourceProvider.end),
                      style: TextStyle(fontSize: fontSizeTab1),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
              SizedBox(height: rowSpacing2,),
              ElevatedButton(
                  onPressed: () async {
                    await showSimpleLoadingDialog(
                      context: context,
                      future: () async {
                        await resourceProvider.loadResourcePage(context);
                        currTabController.animateTo(1);
                        return;
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.search,
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.surface
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.surface,
                        size: 35,
                        weight: 5000,
                      )
                    ],
                  ),
              ),
            ],
          ),
        );
  }

  Padding buildViewPage(List<dynamic> listItems, BuildContext context, ResourceProvider resourceProvider, TabController currTabController) {
    return Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
            child: Column(children: [
              SizedBox(
                height: 15,
              ),
              if ((listItems.length != 0))
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          barrierColor: Colors.black54,
                          transitionDuration: const Duration(milliseconds: 100),
                          pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
                            return Center(
                              child: DescriptionDialog(),
                            );
                          },
                          transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                            return ScaleTransition(
                              scale: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                              child: child,
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.question_mark,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shadowColor: Colors.transparent),
                    ),
                    SizedBox(width: 2,),
                    OutlinedButton(
                      onPressed: () {
                        resourceProvider.setShowPredictionGraph(!resourceProvider.show_prediction_graph);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.prediction_graph,
                        style: TextStyle(color: resourceProvider.show_prediction_graph ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 2.0,
                          color: resourceProvider.show_prediction_graph ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              if ((listItems.length != 0))
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: AvailabilityChart(
                      availabilityData: resourceProvider.shifts,
                      predictionData: resourceProvider.predict_shifts,
                      show_prediction_graph: resourceProvider.show_prediction_graph,
                    )
                ),
              SizedBox(
                height: 15,
              ),
              resourceProvider.slot_logic ?
              Expanded(
                child: Container(
                  child: (listItems.length == 0)
                      ? Center(
                      child:
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/undraw_empty_4zx0.svg',
                              width: 150,
                              height: 150,
                              colorMapper: CustomColorMapper(context),
                            ),
                            SizedBox(height: 25,),
                            Center(
                              child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                                  child: Text(
                                    AppLocalizations.of(context)!.book_no_quantity,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  )
                              ),
                            ),
                            SizedBox(height: 25,),
                            ElevatedButton(
                              onPressed: () {
                                currTabController.animateTo(0);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.tertiary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).colorScheme.surface,
                                    size: 23,
                                    weight: 5000,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.select_another_period,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).colorScheme.surface
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 25,),
                          ],
                        ),
                      ))
                      : ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Center(child: Text(AppLocalizations.of(context)!.start))),
                          Expanded(child: Center(child: Text(AppLocalizations.of(context)!.end))),
                          Expanded(child: Center(child: Text(AppLocalizations.of(context)!.quantity)))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      for (List item in listItems)
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  resourceProvider.setStartBooking(item[3]);
                                  resourceProvider.setEndBooking(item[4]);
                                });
                                currTabController.animateTo(2);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(item[0].toString()))),
                                  Expanded(
                                      child: Center(
                                          child: Text(item[1].toString()))),
                                  Expanded(
                                      child: Center(
                                          child: Text(item[2].toString())))
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ) :
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: (listItems.length == 0)
                      ? Center(
                      child:
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/undraw_empty_4zx0.svg',
                              width: 150,
                              height: 150,
                              colorMapper: CustomColorMapper(context),
                            ),
                            SizedBox(height: 25,),
                            Center(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                                child: Text(
                                  AppLocalizations.of(context)!.book_no_quantity,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                )
                              ),
                            ),
                            SizedBox(height: 25,),
                            ElevatedButton(
                              onPressed: () {
                                currTabController.animateTo(0);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.tertiary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).colorScheme.surface,
                                    size: 23,
                                    weight: 5000,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.select_another_period,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).colorScheme.surface
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 25,),
                          ],
                        ),
                      ))
                      : ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Center(child: Text(AppLocalizations.of(context)!.start))),
                          Expanded(child: Center(child: Text(AppLocalizations.of(context)!.end))),
                          Expanded(child: Center(child: Text(AppLocalizations.of(context)!.quantity)))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      for (List item in listItems)
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(item[0].toString()))),
                                Expanded(
                                    child: Center(
                                        child: Text(item[1].toString()))),
                                Expanded(
                                    child: Center(
                                        child: Text(item[2].toString())))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ]
          )

        );
  }

  Padding buildBookPage(List<dynamic> listItems, ResourceProvider resourceProvider, BuildContext context, double fontSize2, double rowSpacing2, double fontSize1, AppProvider appProvider) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
          child: ((listItems.length != 0)) ? SingleChildScrollView(
            child: Column(
              children: [
                if (!resourceProvider.resource[8]) Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.this_reservation_needs_to_be_accepted,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),


                SizedBox(
                  height: 20,
                ),



                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.book_from,
                              style: TextStyle(fontSize: fontSize2),
                            ),
                  
                  
                            Row(
                              children: [
                                Expanded(child: SizedBox()),
                  
                  
                                resourceProvider.slot_logic ? Text(
                                  getDatePrintable(resourceProvider.start_booking, context),
                                  style: TextStyle(
                                      fontSize: fontSize2,
                                      color: Theme.of(context).colorScheme.onPrimary),
                                ) : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () async {
                                    DateTime? pickedDate = await selectDate(
                                        context, resourceProvider.start_booking);
                  
                                    if (pickedDate != null) {
                                      setState(() {
                                        resourceProvider.start_booking = pickedDate;
                                      });
                                    }
                  
                                    resourceProvider.notify();
                                  },
                                  child: Text(
                                    getDatePrintable(resourceProvider.start_booking, context),
                                    style: TextStyle(
                                        fontSize: fontSize2,
                                        color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                  
                  
                                SizedBox(
                                  width: rowSpacing2,
                                ),
                  
                  
                                resourceProvider.slot_logic ? Text(
                                  getTimePrintable(resourceProvider.start_booking),
                                  style: TextStyle(
                                      fontSize: fontSize2,
                                      color: Theme.of(context).colorScheme.onPrimary),
                                ) : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent),
                                  onPressed: () async {
                                    DateTime? pickedDate = await selectTime(
                                        context, resourceProvider.start_booking);
                  
                                    if (pickedDate != null) {
                                      setState(() {
                                        resourceProvider.start_booking = pickedDate;
                                      });
                                    }
                  
                                    resourceProvider.notify();
                                  },
                                  child: Text(
                                    getTimePrintable(resourceProvider.start_booking),
                                    style: TextStyle(
                                        fontSize: fontSize2,
                                        color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                  
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: VerticalDivider(),
                      ),
                  
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.book_To,
                              style: TextStyle(fontSize: fontSize2),
                            ),
                  
                            Row(
                              children: [
                                Expanded(child: SizedBox()),
                  
                  
                                resourceProvider.slot_logic ? Text(
                                  getDatePrintable(resourceProvider.end_booking, context),
                                  style: TextStyle(
                                      fontSize: fontSize2,
                                      color: Theme.of(context).colorScheme.onPrimary),
                                ) : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent),
                                  onPressed: () async {
                                    DateTime? pickedDate = await selectDate(
                                        context, resourceProvider.end_booking);
                  
                                    if (pickedDate != null) {
                                      setState(() {
                                        resourceProvider.end_booking = pickedDate;
                                      });
                                    }
                  
                                    resourceProvider.notify();
                                  },
                                  child: Text(
                                    getDatePrintable(resourceProvider.end_booking, context),
                                    style: TextStyle(
                                        fontSize: fontSize2,
                                        color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                  
                  
                  
                                SizedBox(
                                  width: rowSpacing2,
                                ),
                  
                  
                                resourceProvider.slot_logic ?Text(
                                  getTimePrintable(resourceProvider.end_booking),
                                  style: TextStyle(
                                      fontSize: fontSize2,
                                      color: Theme.of(context).colorScheme.onPrimary),
                                ) : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent),
                                  onPressed: () async {
                                    DateTime? pickedDate = await selectTime(
                                        context, resourceProvider.end_booking);
                  
                                    if (pickedDate != null) {
                                      setState(() {
                                        resourceProvider.end_booking = pickedDate;
                                      });
                                    }
                  
                                    resourceProvider.notify();
                                  },
                                  child: Text(
                                    getTimePrintable(resourceProvider.end_booking),
                                    style: TextStyle(
                                        fontSize: fontSize2,
                                        color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                  
                  
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 50,),


                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(AppLocalizations.of(context)!.resource_place, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            
                                            
                            resourceProvider.can_edit_place ? ElevatedButton(
                              onPressed: () async {
                                List<SelectedListItem<String>> selections = [];
                                for (var data in resourceProvider.places){
                                  selections.add(SelectedListItem<String>(data: data[0]));
                                }
                                DropDownState<String>(
                                  dropDown: DropDown<String>(
                                    data: selections,
                                    onSelected: (selectedItems) {
                                      List<String> list = [];
                                      for (var item in selectedItems) {
                                        list.add(item.data);
                                      }
                                            
                                      resourceProvider.changePlaceValue(list.first);
                                    },
                                  ),
                                ).showModal(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  resourceProvider.place,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shadowColor: Colors.transparent),
                            ) : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                resourceProvider.place,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: VerticalDivider(),
                      ),
                      
                      Expanded(
                        child: Column(
                          children: [
                            Text(AppLocalizations.of(context)!.resource_activity, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            
                                            
                            resourceProvider.can_edit_activity ? ElevatedButton(
                              onPressed: () async {
                                List<SelectedListItem<String>> selections = [];
                                for (var data in resourceProvider.activities){
                                  selections.add(SelectedListItem<String>(data: data[0]));
                                }
                                DropDownState<String>(
                                  dropDown: DropDown<String>(
                                    data: selections,
                                    onSelected: (selectedItems) {
                                      List<String> list = [];
                                      for (var item in selectedItems) {
                                        list.add(item.data);
                                      }
                                            
                                      resourceProvider.changeActivityValue(list.first);
                                    },
                                  ),
                                ).showModal(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  resourceProvider.activity,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shadowColor: Colors.transparent),
                            ) : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                resourceProvider.activity,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40,),


                if (maxAvailabilityShow)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                    child: Row(
                      children: [
                        SizedBox(
                          width: rowSpacing2,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .book_max_availability +
                              ', ' +
                              maxAvailabilityValue.toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Expanded(child: SizedBox())
                      ],
                    ),
                  ),

                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9
                  ),
                  child: TextField(
                    controller: quantityController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    cursorColor: Theme.of(context).colorScheme.onPrimary,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: fontSize1,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      label: Text(AppLocalizations.of(context)!.book_quantity),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    int quantity = await showSimpleLoadingDialog<int>(
                      context: context,
                      future: () async {
                        int quantity = await Connection.checkBookingQuantity(
                          appProvider,
                          resource_id: resourceProvider.resource[0],
                          start: resourceProvider.start_booking,
                          end: resourceProvider.end_booking,
                        );
                        return quantity;
                      },
                    );

                    setState(() {
                      maxAvailabilityValue = quantity;
                      maxAvailabilityShow = true;
                    });
                    print(quantity);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 40),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shadowColor: Colors.transparent,
                    // Rimuovi l'area di "tocco" extra sopra il bottone
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        // Assicurati che gli angoli superiori siano squadrati per combaciare
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.book_check_availability,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 17
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                ElevatedButton(
                    onPressed: () async {
                      await showSimpleLoadingDialog(
                        context: context,
                        future: () async {
                          if (
                          await Connection.addBooking(
                              start: resourceProvider.start_booking,
                              end: resourceProvider.end_booking,
                              quantity:
                              int.tryParse(quantityController.text) ?? 0,
                              resource_id: resourceProvider.resource[0],
                              appProvider: appProvider,
                              place: resourceProvider.place,
                              activity: resourceProvider.activity
                          )
                          ) {
                            showTopMessage(
                                context,
                                AppLocalizations.of(context)!
                                    .book_book_success);
                          } else {
                            showTopMessage(
                                context,
                                AppLocalizations.of(context)!
                                    .book_error_occurred);
                          }

                          refreshShifts();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(MediaQuery.of(context).size.width*0.9, 60),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 8, 17, 8),
                      child: Text(
                        AppLocalizations.of(context)!.book_book,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                )
              ],
            ),
          ) : Center(
              child: Text(AppLocalizations.of(context)!.no_availability),
            )
        );
  }
}

class DescriptionDialog extends StatelessWidget {
  const DescriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;

    TextStyle text1 = TextStyle(
      fontSize: 17,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    TextStyle text2 = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.tertiary,
      fontWeight: FontWeight.bold,
    );

    TextStyle text3 = TextStyle(
      fontSize: 25,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      child: Scaffold(
        body: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: OverflowTextAnimated(
                          key: const ValueKey('Bookings Page Instructions'),
                          text: app.bookingInstructions,
                          style: const TextStyle(fontSize: 25),
                          curve: Curves.easeInOut,
                          animation: OverFlowTextAnimations.scrollOpposite,
                          animateDuration: const Duration(milliseconds: 2000),
                          delay: const Duration(milliseconds: 500),
                          loopSpace: 10,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 40, weight: 17),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 30),
                        Text(app.appSectionsInfo, style: text1),
                        const SizedBox(height: 10),

                        // Pagina Cerca
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: _buildAnimatedTitle(app.searchPageTitle, text3),
                          controlAffinity: ListTileControlAffinity.leading,
                          children: [
                            Text(app.searchPageText1, style: text1),
                            const SizedBox(height: 10),
                            Text(app.searchPageText2, style: text1),
                            const SizedBox(height: 10),
                            Text(app.searchPageText3, style: text1),
                            const SizedBox(height: 30),
                          ],
                        ),

                        // Pagina Visualizza
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: _buildAnimatedTitle(app.viewPageTitle, text3),
                          controlAffinity: ListTileControlAffinity.leading,
                          children: [
                            Text(app.viewPageText1, style: text1),
                            const SizedBox(height: 15),
                            Text(app.readGraphTitle, style: text2),
                            Text(app.readGraphText1, style: text1),
                            const SizedBox(height: 10),
                            Text(app.readGraphText2, style: text1),
                            const SizedBox(height: 10),
                            Text(app.readGraphText3, style: text1),
                            const SizedBox(height: 10),
                            Text(app.predictionGraphText, style: text1),
                            Center(child: Icon(Icons.warning, color: Theme.of(context).colorScheme.secondary, size: 45)),
                            Text(app.predictionWarning, style: text1.copyWith(color: Theme.of(context).colorScheme.secondary)),
                            const SizedBox(height: 15),
                            Text(app.readIntervalsTitle, style: text2),
                            Text(app.readIntervalsText1, style: text1),
                            const SizedBox(height: 10),
                            Text(app.readIntervalsText2, style: text1),
                            const SizedBox(height: 30),
                          ],
                        ),

                        // Pagina Prenota
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: _buildAnimatedTitle(app.bookPageTitle, text3),
                          controlAffinity: ListTileControlAffinity.leading,
                          children: [
                            Text(app.bookPageText1, style: text1),
                            const SizedBox(height: 15),
                            Text(app.whatCanModifyTitle, style: text2),
                            Text(app.whatCanModifyText, style: text1),
                            const SizedBox(height: 15),
                            Text(app.howToBookTitle, style: text2),
                            Text(app.howToBookText1, style: text1),
                            const SizedBox(height: 10),
                            Text(app.howToBookText2, style: text1),
                            const SizedBox(height: 30),
                          ],
                        ),

                        Text(app.finalNote, style: text1),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(String text, TextStyle style) {
    return Row(
      children: [
        Expanded(
          child: OverflowTextAnimated(
            key: ValueKey(text),
            text: text,
            style: style,
            curve: Curves.easeInOut,
            animation: OverFlowTextAnimations.scrollOpposite,
            animateDuration: const Duration(milliseconds: 2000),
            delay: const Duration(milliseconds: 500),
            loopSpace: 10,
          ),
        ),
      ],
    );
  }
}

