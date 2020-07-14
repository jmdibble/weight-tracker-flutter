import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:weighttrackertwo/bloc/height/height_bloc.dart';
import 'package:weighttrackertwo/bloc/height/height_event.dart';
import 'package:weighttrackertwo/bloc/height/height_state.dart';
import 'package:weighttrackertwo/bloc/weight/weight_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_event.dart';
import 'package:weighttrackertwo/bloc/weight/weight_state.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tuple/tuple.dart';
import 'package:weighttrackertwo/ui/theme/colors.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/summary_card.dart';
import 'package:weighttrackertwo/ui/widgets/summary_card_widget.dart';
import 'package:weighttrackertwo/ui/widgets/wt_animation.dart';

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WeightBloc weightBloc = BlocProvider.of<WeightBloc>(context)
      ..add(LoadWeightEvent());
    HeightBloc heightBloc = BlocProvider.of<HeightBloc>(context)
      ..add(GetHeightEvent());
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Summary",
        implyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<WeightBloc, WeightState>(
                    builder: (ctx, state) {
                      if (state is WeightInitialState) {
                        return Center(child: WtAnimation());
                      } else if (state is WeightChangedState) {
                        var lastGain;
                        var totalGain;
                        var currentWeight;
                        var firstMeasurement;
                        if (state.weight.length == 0) {
                          return Text(
                            "Add some weights to see your stats",
                            style: TextStyle(color: Colors.grey),
                          );
                        } else {
                          currentWeight =
                              "${state.weight[0].weightSt}st ${state.weight[0].weightLb}lb";
                          firstMeasurement =
                              "${state.weight.last.weightSt}st ${state.weight.last.weightLb}lb";
                          state.weight.length == 1
                              ? lastGain = 0
                              : lastGain = ((state.weight[0].weightSt) * 14) +
                                  (state.weight[0].weightLb) -
                                  ((state.weight[1].weightSt) * 14) -
                                  (state.weight[1].weightLb);
                          totalGain = ((state.weight[0].weightSt) * 14) +
                              (state.weight[0].weightLb) -
                              ((state.weight.last.weightSt) * 14) -
                              (state.weight.last.weightLb);

                          return Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Your last 3 months",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                child: _buildLineChart(context, state),
                              ),
                              SizedBox(height: 25),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Your stats",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SummaryCard(
                                      title: "Recent weight",
                                      subtitle: currentWeight,
                                      subtitleColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 10),
                                    SummaryCard(
                                      title: "Last gain/loss",
                                      subtitle: "$lastGain lb",
                                      subtitleColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SummaryCard(
                                      title: "First measurement",
                                      subtitle: firstMeasurement,
                                      subtitleColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 10),
                                    SummaryCard(
                                        title: "Total gain/loss",
                                        subtitle: "$totalGain lb",
                                        subtitleColor:
                                            Theme.of(context).primaryColor),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              BlocBuilder<HeightBloc, HeightState>(
                                  builder: (ctx, state) {
                                if (state is HeightAddedState) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        height: 158,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SummaryCardWidget(
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      state.bmi != null
                                                          ? "BMI: ${state.bmi.roundToDouble()}"
                                                          : "BMI: Add height in profile to show BMI",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                          flex: 350,
                                                          child: Container()),
                                                      Text(
                                                        "18.5",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Expanded(
                                                          flex: 650,
                                                          child: Container()),
                                                      Text(
                                                        "25",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Expanded(
                                                          flex: 500,
                                                          child: Container()),
                                                      Text(
                                                        "30",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Expanded(
                                                          flex: 500,
                                                          child: Text("",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)),
                                                    ],
                                                  ),
                                                  _bmiGraph(state.bmi),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                          flex: 350,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Under",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 650,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Healthy",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 500,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Over",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 500,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Obese",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                            ],
                          );
                        }
                      } else {
                        return Text(
                          "You haven't added any measurements yet",
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bmiGraph(double bmi) {
    return CustomPaint(
      painter: bmiPainter(bmi: bmi),
      child: SizedBox(height: 50, child: Container()),
    );
  }

  _buildCoords(BuildContext context, dynamic state) {
    List<FlSpot> spots = [];

    // renderList currently gives all readings within the last 3 months
    var renderList = state.weight.where(
      (x) =>
          x.date.toDate().isBefore(DateTime.now()) &&
          x.date.toDate().isAfter(
                Jiffy(DateTime.now()).subtract(months: 3),
              ),
    );

    for (var item in renderList) {
      spots.add(
        FlSpot(
          Jiffy(item.date.toDate()).dayOfYear + 0.0,
          (item.weightSt + (item.weightLb / 14)),
        ),
      );
    }
    return spots;
  }

  _buildLineChart(BuildContext context, state) {
    var renderList = state.weight.where(
      (x) =>
          x.date.toDate().isBefore(DateTime.now()) &&
          x.date.toDate().isAfter(
                Jiffy(DateTime.now()).subtract(months: 3),
              ),
    );

    var biggestWeight = 0;
    var smallestWeight = 20;

    for (var item in renderList) {
      if (item.weightSt > biggestWeight) {
        biggestWeight = item.weightSt;
      }
      if (item.weightSt < smallestWeight) {
        smallestWeight = item.weightSt;
      }
    }

    var minx =
        (Jiffy(state.weight[renderList.length - 1].date.toDate()).dayOfYear)
            .toDouble();
    var maxx = (Jiffy(state.weight[0].date.toDate()).dayOfYear).toDouble();

    var miny = smallestWeight - 1.0;
    var maxy = biggestWeight + 1.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            margin: 5,
            showTitles: true,
            reservedSize: 20,
            textStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return "Jan";
                case 32:
                  return "Feb";
                case 60:
                  return "Mar";
                case 91:
                  return "Apr";
                case 121:
                  return "May";
                case 152:
                  return "Jun";
                case 182:
                  return "Jul";
                case 213:
                  return "Aug";
                case 244:
                  return "Sep";
                case 274:
                  return "Oct";
                case 305:
                  return "Nov";
                case 335:
                  return "Dec";
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '0 st';
                case 1:
                  return '1 st';
                case 2:
                  return '2 st';
                case 3:
                  return '3 st';
                case 5:
                  return '5 st';
                case 7:
                  return '7 st';
                case 8:
                  return '8 st';
                case 9:
                  return '9 st';
                case 10:
                  return '10 st';
                case 11:
                  return '11 st';
                case 13:
                  return '13 st';
                case 15:
                  return '15 st';
                case 17:
                  return '17 st';
                case 19:
                  return '19 st';
                case 21:
                  return '21 st';
                case 23:
                  return '23 st';
                case 25:
                  return '25 st';
                case 27:
                  return '27 st';
              }
              return '';
            },
            reservedSize: 25,
            margin: 10,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: minx,
        maxX: maxx,
        minY: miny,
        maxY: maxy,
        lineTouchData: LineTouchData(
          touchSpotThreshold: 20,
          touchTooltipData: (LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  if (flSpot.x == 0 || flSpot.x == 6) {
                    return null;
                  }

                  return LineTooltipItem(
                    ' ${flSpot.y.toInt()}st ${((flSpot.y - flSpot.y.toInt()) * 14).toStringAsFixed(0)}lb',
                    const TextStyle(color: Colors.white, fontSize: 12.0),
                  );
                }).toList();
              },
              tooltipBgColor: WTColors.darkGrey,
              tooltipRoundedRadius: 15,
              fitInsideHorizontally: true)),
        ),
        lineBarsData: [
          LineChartBarData(
            curveSmoothness: 0.0,
            spots: _buildCoords(context, state),
            isCurved: true,
            colors: [Theme.of(context).primaryColor],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              gradientColorStops: [0.5, 1.0],
              gradientFrom: const Offset(0, 0),
              gradientTo: const Offset(0, 1),
              show: true,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.3),
                Theme.of(context).primaryColor.withOpacity(0.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class bmiPainter extends CustomPainter {
  double bmi;

  bmiPainter({this.bmi});

  @override
  void paint(Canvas canvas, Size size) {
    var backgroundPaint = Paint()
      ..color = WTColors.backgroundGrey
      ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.orange,
            WTColors.limeGreen,
            WTColors.limeGreen,
            Colors.red
          ],
          stops: [
            0,
            0.25,
            0.4,
            0.9
          ]).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 50
      ..strokeCap = StrokeCap.butt;

    var linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    var guideLinePaint = Paint()
      ..color = WTColors.darkGrey.withOpacity(0.5)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Background
    canvas.drawLine(Offset(0, 25), Offset(size.width, 25), backgroundPaint);

    // White line
    if (bmi == null) {
    } else if (bmi <= 35 && bmi >= 15) {
      canvas.drawLine(Offset(((bmi - 15) / 20) * size.width, 0),
          Offset(((bmi - 15) / 20) * size.width, 50), linePaint);
    } else if (bmi < 15) {
      canvas.drawLine(Offset(0, 0), Offset(0, 50), linePaint);
    } else if (bmi > 35) {
      canvas.drawLine(Offset(((35 - 15) / 20) * size.width, 0),
          Offset(((35 - 15) / 20) * size.width, 50), linePaint);
    }

    // Indicator lines
    canvas.drawLine(Offset(size.width * 0.175, 0),
        Offset(size.width * 0.175, 50), guideLinePaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, 50),
        guideLinePaint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.75, 50),
        guideLinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
