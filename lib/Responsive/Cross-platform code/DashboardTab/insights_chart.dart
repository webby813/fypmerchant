import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class InsightsChart extends StatefulWidget {
  const InsightsChart({Key? key}) : super(key: key);

  @override
  _InsightsChartState createState() => _InsightsChartState();
}

class _InsightsChartState extends State<InsightsChart> {
  List<_SalesData> data = [];
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  final List<String> monthsList = List.generate(12, (index) {
    DateTime date = DateTime(DateTime.now().year, index + 1, 1);
    return DateFormat('MMMM').format(date);
  });

  @override
  void initState() {
    super.initState();
    _fetchMonthlyData(selectedMonth);
  }

  Future<void> _fetchMonthlyData(String month) async {
    DateTime now = DateTime.now();
    int year = now.year;
    int monthIndex = monthsList.indexOf(month) + 1;
    DateTime startTime = DateTime(year, monthIndex, 1);
    DateTime endTime = DateTime(year, monthIndex + 1, 0, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where("order_Status", isEqualTo: "Finished")
        .where("paid_Time", isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
        .where("paid_Time", isLessThanOrEqualTo: Timestamp.fromDate(endTime))
        .get();

    Map<int, int> weeklyOrderCount = {};
    for (var doc in snapshot.docs) {
      DateTime paidTime = (doc['paid_Time'] as Timestamp).toDate();
      int weekNumber = ((paidTime.day - 1) / 7).floor() + 1;

      if (weeklyOrderCount.containsKey(weekNumber)) {
        weeklyOrderCount[weekNumber] = weeklyOrderCount[weekNumber]! + 1;
      } else {
        weeklyOrderCount[weekNumber] = 1;
      }
    }

    List<_SalesData> newData = [];
    for (int i = 1; i <= 4; i++) {
      newData.add(_SalesData('Week $i', weeklyOrderCount[i] ?? 0));
    }

    setState(() {
      data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedMonth,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedMonth = newValue;
                _fetchMonthlyData(selectedMonth);
              });
            }
          },
          items: monthsList.map((String month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(month),
            );
          }).toList(),
        ),
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: NumericAxis(
            title: AxisTitle(
              text: 'Number of Orders',
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: ChartTitle(text: selectedMonth),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_SalesData, String>>[
            LineSeries<_SalesData, String>(
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.week,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Orders',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.week, this.sales);

  final String week;
  final int sales;
}
