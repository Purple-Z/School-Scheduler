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
  const DataTableWidget({
    Key? key,
    required this.header,
    required this.onRefresh,
    required this.onItemTap,
    required this.items,
    required this.itemsColumn,
    required this.refreshController,
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
                      onPressed: () => widget.onItemTap(item),
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


class LineChartSample3 extends StatefulWidget {
  LineChartSample3({
    super.key,
    Color? lineColor,
    Color? indicatorLineColor,
    Color? indicatorTouchedLineColor,
    Color? indicatorSpotStrokeColor,
    Color? indicatorTouchedSpotStrokeColor,
    Color? bottomTextColor,
    Color? bottomTouchedTextColor,
    Color? averageLineColor,
    Color? tooltipBgColor,
    Color? tooltipTextColor,
  })  : lineColor = lineColor ?? Colors.red,
        indicatorLineColor = indicatorLineColor ??
            Color.lerp(Colors.yellow, Colors.black, 0.2) ?? Colors.yellow,
        indicatorTouchedLineColor =
            indicatorTouchedLineColor ?? Colors.yellow,
        indicatorSpotStrokeColor = indicatorSpotStrokeColor ??
            Color.lerp(Colors.yellow, Colors.black, 0.5) ?? Colors.yellow,
        indicatorTouchedSpotStrokeColor =
            indicatorTouchedSpotStrokeColor ?? Colors.yellow,
        bottomTextColor = bottomTextColor ??
            Color.lerp(Colors.yellow, Colors.black, 0.2) ?? Colors.yellow,
        bottomTouchedTextColor =
            bottomTouchedTextColor ?? Colors.yellow,
        averageLineColor = averageLineColor ??
            Color.lerp(Colors.green, Colors.black, 0.8) ?? Colors.yellow,
        tooltipBgColor = tooltipBgColor ?? Colors.green,
        tooltipTextColor = tooltipTextColor ?? Colors.black;

  final Color lineColor;
  final Color indicatorLineColor;
  final Color indicatorTouchedLineColor;
  final Color indicatorSpotStrokeColor;
  final Color indicatorTouchedSpotStrokeColor;
  final Color bottomTextColor;
  final Color bottomTouchedTextColor;
  final Color averageLineColor;
  final Color tooltipBgColor;
  final Color tooltipTextColor;

  List<String> get weekDays =>
      const ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  List<double> get yValues => const [1.3, 1, 1.8, 1.5, 2.2, 1.8, 3];

  @override
  State createState() => _LineChartSample3State();
}

class _LineChartSample3State extends State<LineChartSample3> {
  late double touchedValue;

  bool fitInsideBottomTitle = true;
  bool fitInsideLeftTitle = false;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    final style = TextStyle(
      color: Color.lerp(Theme.of(context).colorScheme.primary, Colors.black, 0.2) ?? Theme.of(context).colorScheme.primary,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '';
        break;
      case 1:
        text = '1k calories';
        break;
      case 2:
        text = '2k calories';
        break;
      case 3:
        text = '3k calories';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      space: 6,
      fitInside: fitInsideLeftTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta)
          : SideTitleFitInsideData.disable(),
      axisSide: AxisSide.left,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final isTouched = value == touchedValue;
    final style = TextStyle(
      color: isTouched ? widget.bottomTouchedTextColor : widget.bottomTextColor,
      fontWeight: FontWeight.bold,
    );

    if (value % 1 != 0) {
      return Container();
    }
    return SideTitleWidget(
      space: 4,
      fitInside: fitInsideBottomTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0)
          : SideTitleFitInsideData.disable(),
      axisSide: AxisSide.right,
      child: Text(
        widget.weekDays[value.toInt()],
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Average Line',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              ' and ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Indicators',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 12),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final spot = barData.spots[spotIndex];
                      if (spot.x == 0 || spot.x == 6) {
                        return null;
                      }
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: widget.indicatorTouchedLineColor,
                          strokeWidth: 4,
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            if (index.isEven) {
                              return FlDotCirclePainter(
                                radius: 8,
                                color: Colors.white,
                                strokeWidth: 5,
                                strokeColor:
                                widget.indicatorTouchedSpotStrokeColor,
                              );
                            } else {
                              return FlDotSquarePainter(
                                size: 16,
                                color: Colors.white,
                                strokeWidth: 5,
                                strokeColor:
                                widget.indicatorTouchedSpotStrokeColor,
                              );
                            }
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        if (flSpot.x == 0 || flSpot.x == 6) {
                          return null;
                        }

                        TextAlign textAlign;
                        switch (flSpot.x.toInt()) {
                          case 1:
                            textAlign = TextAlign.left;
                            break;
                          case 5:
                            textAlign = TextAlign.right;
                            break;
                          default:
                            textAlign = TextAlign.center;
                        }

                        return LineTooltipItem(
                          '${widget.weekDays[flSpot.x.toInt()]} \n',
                          TextStyle(
                            color: widget.tooltipTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: flSpot.y.toString(),
                              style: TextStyle(
                                color: widget.tooltipTextColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const TextSpan(
                              text: ' k ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const TextSpan(
                              text: 'calories',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                          textAlign: textAlign,
                        );
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? lineTouch) {
                    if (!event.isInterestedForInteractions ||
                        lineTouch == null ||
                        lineTouch.lineBarSpots == null) {
                      setState(() {
                        touchedValue = -1;
                      });
                      return;
                    }
                    final value = lineTouch.lineBarSpots![0].x;

                    if (value == 0 || value == 6) {
                      setState(() {
                        touchedValue = -1;
                      });
                      return;
                    }

                    setState(() {
                      touchedValue = value;
                    });
                  },
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 1.8,
                      color: widget.averageLineColor,
                      strokeWidth: 3,
                      dashArray: [20, 10],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    isStepLineChart: true,
                    spots: widget.yValues.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: false,
                    barWidth: 4,
                    color: widget.lineColor,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.onPrimary
                        ],
                        stops: const [0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      spotsLine: BarAreaSpotsLine(
                        show: true,
                        flLineStyle: FlLine(
                          color: widget.indicatorLineColor,
                          strokeWidth: 2,
                        ),
                        checkToShowSpotLine: (spot) {
                          if (spot.x == 0 || spot.x == 6) {
                            return false;
                          }

                          return true;
                        },
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (index.isEven) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: widget.indicatorSpotStrokeColor,
                          );
                        } else {
                          return FlDotSquarePainter(
                            size: 12,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: widget.indicatorSpotStrokeColor,
                          );
                        }
                      },
                      checkToShowDot: (spot, barData) {
                        return spot.x != 0 && spot.x != 6;
                      },
                    ),
                  ),
                ],
                minY: 0,
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  checkToShowHorizontalLine: (value) => value % 1 == 0,
                  checkToShowVerticalLine: (value) => value % 1 == 0,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0) {
                      return FlLine(
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 2,
                      );
                    } else {
                      return FlLine(
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 0.5,
                      );
                    }
                  },
                  getDrawingVerticalLine: (value) {
                    if (value == 0) {
                      return const FlLine(
                        color: Colors.redAccent,
                        strokeWidth: 10,
                      );
                    } else {
                      return  FlLine(
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 0.5,
                      );
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      getTitlesWidget: leftTitleWidgets,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            const Text('Fit Inside Title Option'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Left Title'),
                Switch(
                  value: fitInsideLeftTitle,
                  onChanged: (value) => setState(() {
                    fitInsideLeftTitle = value;
                  }),
                ),
                const Text('Bottom Title'),
                Switch(
                  value: fitInsideBottomTitle,
                  onChanged: (value) => setState(() {
                    fitInsideBottomTitle = value;
                  }),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class AvailabilitySlot {
  final Duration startTime;
  final Duration endTime;
  final int availability;

  AvailabilitySlot({
    required this.startTime,
    required this.endTime,
    required this.availability,
  });
}

List<FlSpot> convertAvailabilityToSpots(List<AvailabilitySlot> data) {
  List<FlSpot> spots = [];
  for (var slot in data) {
    spots.add(FlSpot(slot.startTime.inHours.toDouble(), slot.availability.toDouble()));
    spots.add(FlSpot(slot.endTime.inHours.toDouble(), slot.availability.toDouble()));
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
  String _selectedValue = '';

  double interpolateY(double x, List<FlSpot> spots) {
    if (spots.isEmpty) return 0;

    for (int i = 0; i < spots.length - 1; i++) {
      if (x >= spots[i].x && x <= spots[i + 1].x) {
        double x0 = spots[i].x;
        double y0 = spots[i].y;
        double x1 = spots[i + 1].x;
        double y1 = spots[i + 1].y;

        return y0 + (y1 - y0) * (x - x0) / (x1 - x0);
      }
    }

    if (x <= spots.first.x) return spots.first.y;
    return spots.last.y;
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = convertAvailabilityToSpots(widget.availabilityData);

    return Column(
      children: [
        if (_selectedValue.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Valore selezionato: $_selectedValue',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        SizedBox(
          height: 100,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.x.toStringAsFixed(2)}, ${spot.y.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
                touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  if (touchResponse != null && touchResponse.lineBarSpots != null) {
                    final spot = touchResponse.lineBarSpots!.first;
                    setState(() {
                      _selectedValue = 'X: ${spot.x.toStringAsFixed(1)}, Y: ${spot.y.toStringAsFixed(1)}';
                    });
                  }
                },
                handleBuiltInTouches: true,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        Colors.blue.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              gridData: FlGridData(show: true, horizontalInterval: 5, verticalInterval: 2),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // Utilizziamo titleTextFormatter invece di getTitles
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}:00');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // Utilizziamo titleTextFormatter invece di getTitles
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString());
                    },
                  ),
                ),
              ),
              minX: 0,
              maxX: 24,
              minY: 0,
              maxY: widget.availabilityData.map((slot) => slot.availability).reduce((a, b) => a > b ? a : b).toDouble() + 5,
            ),
          ),
        ),
      ],
    );
  }
}