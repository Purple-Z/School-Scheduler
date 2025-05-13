import 'dart:convert';

import 'package:client/pages/manage/widgetsStates_provider.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../router/routes.dart';

class DataTableWidget extends StatefulWidget {
  final List<String> header;
  final List items;
  final List itemsColumn;
  final List itemCategories;
  final VoidCallback? onRefresh;
  final void Function(List) onItemTap;
  final RefreshController refreshController;
  final bool clickableTies;
  final String id;
  DataTableWidget({
    Key? key,
    required this.header,
    required this.onRefresh,
    required this.onItemTap,
    required this.items,
    required this.itemsColumn,
    required this.refreshController,
    required this.itemCategories,
    this.clickableTies = false,
    this.id = 'default',
  }) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {

  getItems(WidgetStatesProvider widgetProvider){
    List f = widgetProvider.states[widget.id]??[];

    if (f.isEmpty){
      return widget.items;
    }

    if (widget.items.isEmpty){
      return [];
    }

    List firts_item = widget.items.first;
    List curr_items = widget.items;
    for (int i = 0; i < firts_item.length; i++){
      List new_items = [];
      for (int j = 0; j < curr_items.length; j++){
        List item = curr_items[j];


        //checking the filters...
        if (widget.itemCategories[i] == 'text'){

          if (f.length >= i){
            for (List element in f[i]){
              if (element[0] == item[i] && element[1]){
                new_items.add(item);
              }
            }
          } else {
            new_items.add(item);
          }
        } else if (widget.itemCategories[i] == 'number') {
          if (f.length >= i){
            if (f[i][0] <= item[i] && f[i][1] >= item[i]){
              new_items.add(item);
            }
          } else {
            new_items.add(item);
          }
        } else {
          new_items.add(item);
        }
      }

      curr_items = new_items;
    }



    return curr_items;
  }

  resetFilters(WidgetStatesProvider widgetProvider){
    List f = [];

    for (int i = 0; i < widget.itemCategories.length; i++){
      if (widget.itemCategories[i] == 'text'){
        List items = [];

        for (int j = 0; j < widget.items.length; j++){
          if (!items.contains(widget.items[j][i])){
            items.add(widget.items[j][i]);
          }
        }

        for (int j = 0; j < items.length; j ++){
          items[j] = [items[j], true];
        }

        f.add(items);
      } else if (widget.itemCategories[i] == 'number'){
        f.add([categoryGetMinMax(widgetProvider, i)[0], categoryGetMinMax(widgetProvider, i)[1]]);
      } else {
        f.add(null);
      }
    }

    widgetProvider.setState(widget.id, f);
    return f;
  }

  bool categoryHasFilters(WidgetStatesProvider widgetProvider, i){
    List f = widgetProvider.states[widget.id]??[];

    if (widget.itemCategories[i] == 'text'){
      if (f.length <= i){
        return false;
      }
      for (List item in f[i]){
        if (!item[1]){
          return true;
        }
      }
      return false;
    } else if (widget.itemCategories[i] == 'number'){
      if (f.length <= i){
        return false;
      }
      if ((f[i][0] == categoryGetMinMax(widgetProvider, i)[0]) && (f[i][1] == categoryGetMinMax(widgetProvider, i)[1])){
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool hasFilters(WidgetStatesProvider widgetProvider){
    List f = widgetProvider.states[widget.id]??[];

    for (int i = 0; i < widget.itemCategories.length; i++){
      if (categoryHasFilters(widgetProvider, i)){
        return true;
      }
    }
    return false;
  }

  List<int> categoryGetMinMax(WidgetStatesProvider widgetProvider, i){
    List f = widgetProvider.states[widget.id]??[];

    if (widget.itemCategories[i] == 'number'){

      int min = widget.items[0][i];
      int max = widget.items[0][i];

      for (List item in widget.items){
        if (item[i] > max){
          max = item[i];
        } else if (item[i] < min){
          min = item[i];
        }
      }
      print([min, max]);
      return [min, max];
    } else {
      return [0, 0];
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgetProvider = context.watch<WidgetStatesProvider>();

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < widget.itemsColumn.length; i++)
              if (widget.itemsColumn[i] != null)
                Expanded(
                    child: Center(
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            List f = widgetProvider.states[widget.id]??[];

                            print(f);
                            if (f.isEmpty){
                              f = resetFilters(widgetProvider);
                            }
                            print(f);

                            if (widget.itemCategories[i] == 'text'){
                              List<SelectedListItem<ListItem>> selections = [];
                              for (List categoryItem in f[i]){
                                selections.add(SelectedListItem<ListItem>(
                                    data: ListItem(
                                      display: (categoryItem[0]),
                                      value: categoryItem[0],
                                    ),
                                    isSelected: categoryItem.last
                                ));
                              }
                              DropDownState<ListItem>(
                                dropDown: DropDown<ListItem>(
                                  enableMultipleSelection: true,
                                  data: selections,
                                  onSelected: (selectedItems) {
                                    List<String> list = [];
                                    for (var item in selectedItems) {
                                      list.add(item.data.value);
                                    }

                                    print('selectedItems');
                                    for (SelectedListItem<ListItem> item in selectedItems){
                                      print(item.data);
                                    }
                                    for (List itemContent in f[i]){
                                      String content = itemContent[0];
                                      if (list.contains(content)){
                                        itemContent[itemContent.length-1] = true;
                                      } else {
                                        itemContent[itemContent.length-1] = false;
                                      }
                                    }

                                    print(f);

                                    widgetProvider.setState(widget.id, f);
                                  },
                                ),
                              ).showModal(context);


                              widgetProvider.setState(widget.id, f);

                            } else if (widget.itemCategories[i] == 'number'){
                              print('ecco il filtro usato');
                              print(f[i]);
                              print(f[i][0]);
                              print(f[i][1]);
                              showModalBottomSheet<List<int>>(
                                context: context,
                                builder: (BuildContext context) {
                                  var modalSheetWidgetProvider = context.watch<WidgetStatesProvider>();
                                  List f = modalSheetWidgetProvider.states[widget.id]??[];

                                  print(f);
                                  if (f.isEmpty){
                                    f = resetFilters(modalSheetWidgetProvider);
                                  }

                                  return SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text('Modal BottomSheet'),
                                          SfRangeSlider(
                                            min: categoryGetMinMax(modalSheetWidgetProvider, i)[0],
                                            max: categoryGetMinMax(modalSheetWidgetProvider, i)[1],
                                            values: SfRangeValues(f[i][0], f[i][1]),
                                            interval: 5,
                                            showTicks: false,
                                            showLabels: true,
                                            enableTooltip: true,
                                            minorTicksPerInterval: 5,
                                            stepSize: 1,
                                            inactiveColor: Theme.of(context).colorScheme.secondary,
                                            onChanged: (SfRangeValues values){
                                              setState(() {
                                                f[i][0] = values.start.toInt();
                                                f[i][1] = values.end.toInt();
                                                f = f.toList();
                                                modalSheetWidgetProvider.setState(widget.id, f);
                                              });
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text('Close BottomSheet'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: badges.Badge(
                                showBadge: categoryHasFilters(widgetProvider, i),
                                child: SizedBox(
                                    height: 25,
                                    child: Text(
                                        widget.itemsColumn[i],
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                    )
                ),
          ],
        ),
        if (hasFilters(widgetProvider)) ElevatedButton(
            onPressed: (){
              resetFilters(widgetProvider);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Clear All Filters',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            )
        ),
        Expanded( 
          child: SmartRefresher(
            controller: widget.refreshController,
            onRefresh: widget.onRefresh,
            header: MaterialClassicHeader(),
            child: ListView.builder(
              itemCount: getItems(widgetProvider).length,
              itemBuilder: (context, index) {
                List item = getItems(widgetProvider)[index] as List;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Divider(),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                      onPressed: () => widget.clickableTies ? null :widget.onItemTap(item),
                      child: Row(
                        children: [
                          for (int i = 0; i < item.length; i++)
                            if (widget.itemsColumn[i] != null)
                              Expanded(
                                child: Center(
                                  child: Text("${item[i]}"),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class ListItem {
  final String display;
  final dynamic value;

  ListItem({required this.display, required this.value});
  @override
  String toString() {
    // TODO: implement toString
    return display;
  }
}

class AvailabilitySlot {
  final DateTime startTime;
  final DateTime endTime;
  final int availability;

  AvailabilitySlot({
    required this.startTime,
    required this.endTime,
    required this.availability,
  });
}

List<FlSpot> convertAvailabilityToSpots(List<AvailabilitySlot> data) {
  List<FlSpot> spots = [];
  if (data.isEmpty) return spots;

  final DateTime startOfDay = DateTime(data.first.startTime.year, data.first.startTime.month, data.first.startTime.day);

  for (int i = 0; i < data.length; i++) {
    var slot = data[i];

    for (int t = slot.startTime.difference(startOfDay).inMinutes.toInt(); t < slot.endTime.difference(startOfDay).inMinutes.toInt(); t++){
      spots.add(
          FlSpot(
            t.toDouble(),
            slot.availability.toDouble(),
          )
      );
    }
  }
  return spots;
}

class AvailabilityChart extends StatefulWidget {
  final List<AvailabilitySlot> availabilityData;

  AvailabilityChart({required this.availabilityData});

  @override
  _AvailabilityChartState createState() => _AvailabilityChartState();
}

class _AvailabilityChartState extends State<AvailabilityChart> {
  double? touchedValue;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = convertAvailabilityToSpots(widget.availabilityData);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              if (touchedSpots.isEmpty || widget.availabilityData.isEmpty) return [];

              final DateTime startOfDay = DateTime(widget.availabilityData.first.startTime.year, widget.availabilityData.first.startTime.month, widget.availabilityData.first.startTime.day);

              return touchedSpots.map((spot) {
                final DateTime touchedTime = startOfDay.add(Duration(minutes: spot.x.toInt()));
                final String formattedTime = "${touchedTime.hour.toString().padLeft(2, '0')}:${touchedTime.minute.toString().padLeft(2, '0')}";

                return LineTooltipItem(
                  '$formattedTime\nQt: ${spot.y.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            barWidth: 2,
            color: Theme.of(context).colorScheme.primary,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        maxY: widget.availabilityData.map((slot) => slot.availability).reduce((a, b) => a > b ? a : b).toDouble() * 1.3,
        minY: widget.availabilityData.map((slot) => slot.availability).reduce((a, b) => a > b ? a : b).toDouble() * -0.3,
      ),
    );
  }
}

