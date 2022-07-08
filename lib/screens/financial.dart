// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_this, prefer_collection_literals, unnecessary_new, unused_element, prefer_is_empty

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialScreen extends StatefulWidget {
  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  bool loadChart = true;

  List<FlSpot> listFinancial;
  List financialValues;
  List financialDates;
  List financialStatus;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  fetchChart() async {
    final response = await http.get(
        Uri.parse('https://www.econdb.com/api/series/GBALID/?format=json'));
    List<FlSpot> accList = [];
    List financialVal = [];
    List financialDate = [];
    List financialStat = [];
    var data = jsonDecode(response.body)['data'];
    for (int i = 0; i <= 30; i++) {
      String s = data['status'][i];
      int xInt = data['values'][i];
      double x = xInt.toDouble();
      double xSub = x / 1000;
      var yInt = data['dates'][i];
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(yInt);
      var newDate = DateFormat("yyyy").format(tempDate);
      double y = double.parse(newDate);
      accList.add(FlSpot(y, xSub));

      var formatter = NumberFormat('#,###,000');
      var xFormatter = formatter.format(x);

      String prettify(double d) =>
          d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
      String prettyY = prettify(y);
      financialVal.add(xFormatter);
      financialDate.add(prettyY);
      financialStat.add(s);
    }

    setState(() {
      financialDates = financialDate;
      financialValues = financialVal;
      financialStatus = financialStat;
      listFinancial = accList;
      loadChart = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Financial"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: (loadChart)
          ? SizedBox(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Indonesia - Government Balance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7.5, left: 30),
                    child: Text(
                      "Units: Trillion IDR",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  (loadChart)
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                // color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 0.0, left: 0.0, top: 22, bottom: 15),
                                child: LineChart(
                                  mainData(),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 30),
                    child: Text(
                      "History",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  (loadChart)
                      ? SizedBox()
                      : SizedBox(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: financialDates.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 7),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          financialDates[index],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              financialValues[index],
                                              style: TextStyle(
                                                color: (financialValues[index]
                                                        .toString()
                                                        .contains("-"))
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Text(
                                              ",000,000,000",
                                              style: TextStyle(
                                                color: (financialValues[index]
                                                        .toString()
                                                        .contains("-"))
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    (index == 30) ? SizedBox() : Divider(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 15),
                ],
              ),
            ),
    );
  }

  Widget _listFinancial(
      String book_title, String name, String image, List subjects) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 7),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: (Radius.circular(15)),
                    bottomLeft: (Radius.circular(15))),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7),
                  Text(
                    book_title,
                    maxLines: 2,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.5),
                  Text(
                    "Author",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  SizedBox(height: 3.5),
                  Text(
                    "Subjects",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subjects[0] ?? "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    (subjects.length > 1) ? subjects[1] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    // subjects.length.toString(),
                    (subjects.length > 2) ? subjects[2] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    (subjects.length > 3) ? subjects[3] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    // subjects.length.toString(),
                    (subjects.length > 4) ? subjects[4] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 200,
        verticalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black54,
            strokeWidth: 0.1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).scaffoldBackgroundColor,
            strokeWidth: 0.1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            getTitlesWidget: chartWidget,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 35,
            interval: 500,
            getTitlesWidget: chartWidget,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor, width: 0.1)),
      minX: 1990,
      maxX: 2020,
      minY: -1000,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: listFinancial,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  Widget chartWidget(double value, TitleMeta meta) {
    String prettify(double d) =>
        d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
    String pretty = prettify(value);
    var style = TextStyle(
      color:
          (pretty == "1990" || pretty == "2020") ? Colors.white : Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(
        pretty,
        style: style,
      ),
    );
  }
}
