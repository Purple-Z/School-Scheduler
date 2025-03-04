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
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../connection.dart';
import '../../manage/widgets.dart';

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

    return appProvider.view_resources ?
    ResourceDetails():
    Text("access denied!");
  }
}

class ResourceDetails extends StatefulWidget {
  const ResourceDetails({super.key});

  @override
  _ResourceDetailsState createState() => _ResourceDetailsState();
}

class _ResourceDetailsState extends State<ResourceDetails> {
  get chartData => null;




  @override
  Widget build(BuildContext context) {
    var resourceProvider = context.watch<ResourceProvider>();
    var appProvider = context.watch<AppProvider>();
    Map resources = resourceProvider.resources;

    final List<FlSpot> data = [
      FlSpot(0, 10),
      FlSpot(1, 10),
      FlSpot(1, 15),
      FlSpot(2, 15),
      FlSpot(2, 8),
      FlSpot(3, 8),
      FlSpot(3, 12),
      FlSpot(4, 12),
    ];

    List<AvailabilitySlot> availabilityData = [
      AvailabilitySlot(startTime: Duration(hours: 8), endTime: Duration(hours: 10), availability: 10),
      AvailabilitySlot(startTime: Duration(hours: 10), endTime: Duration(hours: 12), availability: 15),
      AvailabilitySlot(startTime: Duration(hours: 12), endTime: Duration(hours: 14), availability: 8),
      AvailabilitySlot(startTime: Duration(hours: 14), endTime: Duration(hours: 17), availability: 20),
      AvailabilitySlot(startTime: Duration(hours: 17), endTime: Duration(hours: 19), availability: 5),
    ];

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width,
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
                              color: Theme.of(context).colorScheme.primary,
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
                                    Theme.of(context).colorScheme.primary,
                                  );
                                } else {
                                  return FlDotSquarePainter(
                                    size: 16,
                                    color: Colors.white,
                                    strokeWidth: 5,
                                    strokeColor:
                                    Theme.of(context).colorScheme.primary,
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
                              'info \n',
                              TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: flSpot.y.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
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
                          });
                          return;
                        }
                        final value = lineTouch.lineBarSpots![0].x;

                        if (value == 0 || value == 6) {
                          setState(() {
                          });
                          return;
                        }

                        setState(() {
                        });
                      },
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data,
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
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true, // Rimuovi tutti i titoli
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Rimuovi solo i titoli a sinistra
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Rimuovi solo i titoli a sinistra
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Rimuovi solo i titoli in alto
                    ),
                    // ... altre configurazioni
                  ),
                )
              ),
              SizedBox(height: 30,),
              SizedBox(height: 150, child: AvailabilityChart(availabilityData: availabilityData)),
              SizedBox(height: 30,),
              LineChartSample3(),
            ],
          )
      ),
    );
  }
}

