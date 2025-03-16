import 'package:client/app_provider.dart';
import 'package:client/pages/manage/manage_provider.dart';
import 'package:client/pages/manage/types/manageTypes_provider.dart';
import 'package:client/pages/manage/users/manageUsers_provider.dart';
import 'package:client/pages/manage/resources/manageResources_provider.dart';
import 'package:client/pages/resources/resource/resource_provider.dart';
import 'package:client/pages/resources/resources_provider.dart';
import 'package:client/router/layout_scaffold.dart';
import 'package:client/router/routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../connection.dart';
import '../../../graphics/graphics_methods.dart';
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

class _ResourceDetailsState extends State<ResourceDetails> {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final TextEditingController quantityController = TextEditingController();
  int maxAvailabilityValue = 0;
  bool maxAvailabilityShow = false;

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

  getItem(List items) {
    print(items.toString());
    List newItems = [];
    for (AvailabilitySlot item in items) {
      if (item.availability == 0) {
        continue;
      }

      List newItem = [item.startTime, item.endTime, item.availability];

      for (int i in [0, 1]) {
        DateTime dateTime = newItem[i];
        newItem[i] = '${dateTime.year}/${dateTime.month}/${dateTime.day}\n';
        newItem[i] += getTimePrintable(dateTime);
      }

      newItems.add(newItem);
    }
    return newItems;
  }

  @override
  Widget build(BuildContext context) {
    var resourceProvider = context.watch<ResourceProvider>();
    var appProvider = context.watch<AppProvider>();
    List resource = resourceProvider.resource;
    List listItems = getItem(resourceProvider.shifts);
    const double fontSize1 = 15;
    const double rowSpacing1 = 5;

    const double fontSize2 = 20;
    const double rowSpacing2 = 10;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
          child: Column(children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.book_from),
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
                    '${resourceProvider.start.year}/${resourceProvider.start.month}/${resourceProvider.start.day}',
                    style: TextStyle(fontSize: fontSize1),
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
                    style: TextStyle(fontSize: fontSize1),
                  ),
                ),
                SizedBox(
                  width: rowSpacing1,
                ),
                Text(AppLocalizations.of(context)!.book_to),
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
                    '${resourceProvider.end.year}/${resourceProvider.end.month}/${resourceProvider.end.day}',
                    style: TextStyle(fontSize: fontSize1),
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
                    style: TextStyle(fontSize: fontSize1),
                  ),
                ),
                Expanded(child: SizedBox()),
                SizedBox(
                  height: 37,
                  width: 37,
                  child: IconButton(
                      onPressed: () async {
                        await showSimpleLoadingDialog(
                          context: context,
                          future: () async {
                            await resourceProvider.loadResourcePage(context);
                            return;
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                      ),
                      iconSize: 17,
                      icon: Icon(
                        Icons.search,
                      )),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            if ((listItems.length != 0))
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: AvailabilityChart(
                      availabilityData: resourceProvider.shifts)),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: (listItems.length == 0)
                  ? Center(
                      child:
                          Text(AppLocalizations.of(context)!.book_no_quantity))
                  : DataTableWidget(
                      header: [
                        AppLocalizations.of(context)!.book_start,
                        AppLocalizations.of(context)!.book_end,
                        AppLocalizations.of(context)!.book_quantity
                      ],
                      onRefresh: refreshShifts,
                      onItemTap: (List item) {},
                      clickableTies: false,
                      items: listItems,
                      itemsColumn: [
                        true, //0
                        true, //1
                        true, //2
                      ],
                      refreshController: refreshController),
            ),
            if ((listItems.length != 0))
              ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height*0.8,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: rowSpacing2,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.book_from,
                                      style: TextStyle(fontSize: fontSize2),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                        await selectDate(context,
                                            resourceProvider.start_booking);

                                        if (pickedDate != null) {
                                          setState(() {
                                            resourceProvider.start_booking =
                                                pickedDate;
                                          });
                                        }
                                      },
                                      child: Text(
                                        '${resourceProvider.start_booking.year}/${resourceProvider.start_booking.month}/${resourceProvider.start_booking.day}',
                                        style: TextStyle(
                                            fontSize: fontSize2,
                                            color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: rowSpacing2,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent),
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                        await selectTime(context,
                                            resourceProvider.start_booking);

                                        if (pickedDate != null) {
                                          setState(() {
                                            resourceProvider.start_booking =
                                                pickedDate;
                                          });
                                        }
                                      },
                                      child: Text(
                                        getTimePrintable(
                                            resourceProvider.start_booking),
                                        style: TextStyle(
                                            fontSize: fontSize2,
                                            color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: rowSpacing2,
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: rowSpacing2,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.book_To,
                                      style: TextStyle(fontSize: fontSize2),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent),
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                        await selectDate(context,
                                            resourceProvider.end_booking);

                                        if (pickedDate != null) {
                                          setState(() {
                                            resourceProvider.end_booking = pickedDate;
                                          });
                                        }
                                      },
                                      child: Text(
                                        '${resourceProvider.end_booking.year}/${resourceProvider.end_booking.month}/${resourceProvider.end_booking.day}',
                                        style: TextStyle(
                                            fontSize: fontSize2,
                                            color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: rowSpacing2,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent),
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                        await selectTime(context,
                                            resourceProvider.end_booking);

                                        if (pickedDate != null) {
                                          setState(() {
                                            resourceProvider.end_booking = pickedDate;
                                          });
                                        }
                                      },
                                      child: Text(
                                        getTimePrintable(
                                            resourceProvider.end_booking),
                                        style: TextStyle(
                                            fontSize: fontSize2,
                                            color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: rowSpacing2,
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                if (maxAvailabilityShow) Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                                  child: Row(
                                    children: [
                                      SizedBox(width: rowSpacing2,),
                                      Text(
                                        AppLocalizations.of(context)!.book_max_availability + ', ' + maxAvailabilityValue.toString(),
                                        style: TextStyle(color: Theme.of(context).colorScheme.surface),
                                      ),
                                      Expanded(child: SizedBox())
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15,),
                                TextField(
                                  controller: quantityController,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  cursorColor:
                                  Theme.of(context).colorScheme.surface,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.surface,
                                      fontSize: fontSize1
                                  ),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                      label: Text(AppLocalizations.of(context)!.book_quantity),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      )
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    ElevatedButton(
                                        onPressed: ()  async {
                                          int quantity = await showSimpleLoadingDialog<int>(
                                            context: context,
                                            future: () async {
                                              int quantity = await Connection.checkBookingQuantity(appProvider,
                                                  resource_id: resourceProvider.resource[0],
                                                  start: resourceProvider.start_booking,
                                                  end: resourceProvider.end_booking
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
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            shadowColor: Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                          child: Text(
                                            AppLocalizations.of(context)!.book_check_availability,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.surface
                                            ),
                                          ),
                                        )
                                    ),
                                    Expanded(child: SizedBox()),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await showSimpleLoadingDialog(
                                            context: context,
                                            future: () async {
                                              if (await Connection.addBooking(
                                                  start: resourceProvider.start_booking,
                                                  end: resourceProvider.end_booking,
                                                  quantity: int.tryParse(quantityController.text) ?? 0,
                                                  resource_id: resourceProvider.resource[0],
                                                  appProvider: appProvider
                                              )){
                                                showTopMessage(context, AppLocalizations.of(context)!.book_book_success);
                                              } else {
                                                showTopMessage(context, AppLocalizations.of(context)!.book_error_occurred);
                                              }

                                              refreshShifts();
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            shadowColor: Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(17, 8, 17, 8),
                                          child: Text(
                                            AppLocalizations.of(context)!.book_book,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                        )
                                    ),
                                    Expanded(child: SizedBox()),
                                  ],
                                ),
                                Expanded(child: SizedBox())
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.book_book),
              ),
          ])),
    );
  }
}
