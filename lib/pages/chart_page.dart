import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/earnings_chart.dart';

class ChartPage extends StatefulWidget {
  final List<FlSpot> estimatedEarnings;
  final List<FlSpot> actualEarnings;
  final List<String> dates;
  final String name;

  const ChartPage({
    super.key,
    required this.estimatedEarnings,
    required this.actualEarnings,
    required this.dates,
    required this.name,
  });

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    bool hasData =
        widget.estimatedEarnings.isNotEmpty && widget.actualEarnings.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hasData
            ? EarningsChart(
                estimatedEarnings: widget.estimatedEarnings,
                actualEarnings: widget.actualEarnings,
                dates: widget.dates,
              )
            : Center(
                child: Text(
                  "Sorry, the API doesn't have any data regarding this company.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
