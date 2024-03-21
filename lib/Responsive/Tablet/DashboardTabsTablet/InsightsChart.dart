import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsChart extends StatefulWidget {
  const InsightsChart({Key? key}) : super(key: key);

  @override
  _InsightsChartState createState() => _InsightsChartState();
}

class _InsightsChartState extends State<InsightsChart> {
  List<_SalesData> data = [
    _SalesData('Week 1', 35),
    _SalesData('Week 2', 28),
    _SalesData('Week 3', 34),
    _SalesData('Week 4', 32),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: const ChartTitle(text: 'February'),
            legend: const Legend(isVisible: true),
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