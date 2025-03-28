import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class DataTableWidget extends StatefulWidget {
  final List<String> header;
  final List items;
  final List<bool> itemsColumn;
  final VoidCallback? onRefresh;
  final void Function(List) onItemTap;
  final RefreshController refreshController;
  final bool clickableTies;
  const DataTableWidget({
    Key? key,
    required this.header,
    required this.onRefresh,
    required this.onItemTap,
    required this.items,
    required this.itemsColumn,
    required this.refreshController,
    this.clickableTies = false
  }) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            for (String header_label in widget.header)
            Expanded(child: Center(child: SizedBox(height: 35, child: Text(header_label, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))))),
          ],
        ),
        Expanded( 
          child: SmartRefresher(
            controller: widget.refreshController,
            onRefresh: widget.onRefresh,
            header: MaterialClassicHeader(),
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                List item = widget.items[index] as List;
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
                            if (widget.itemsColumn[i])
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
        ),
      ],
    );
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

