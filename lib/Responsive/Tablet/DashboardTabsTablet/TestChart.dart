import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestChart extends StatefulWidget {
  const TestChart({Key? key}) : super(key: key);

  @override
  _TestChartState createState() => _TestChartState();
}

class _TestChartState extends State<TestChart> {
  List<_SalesData> data = [
    _SalesData('Week 1', 35),
    _SalesData('Week 2', 28),
    _SalesData('Week 3', 34),
    _SalesData('Week 4', 32),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Set a specific height for the chart
      child: Column(
        children: [
          //Initialize the chart widget
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            // Chart title
            title: const ChartTitle(text: 'February'),
            // Enable legend
            legend: const Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<_SalesData, String>>[
              LineSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.week,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.week, this.sales);

  final String week;
  final double sales;
}