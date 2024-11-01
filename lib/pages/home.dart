import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chart_page.dart';
import '../api/earnings_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _searchController = TextEditingController();
  final _earningsService = EarningsService();
  List<Map<String, String>> companies = [];
  List<Map<String, String>> filteredCompanies = [];
  List<FlSpot> estimatedEarnings = [];
  List<FlSpot> actualEarnings = [];
  List<String> dates = [];
  String companyName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCompanies();
  }

  void loadCompanies() async {
    final companyList = await _earningsService.loadCompanies();
    setState(() {
      companies = companyList;
      filteredCompanies = companyList;
    });
  }

  void searchCompanies(String query) {
    setState(() {
      filteredCompanies = companies
          .where((company) => company['description']!
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void fetchEarningsData(String symbol) async {
    setState(() {
      isLoading = true;
    });

    final data = await _earningsService.fetchEarnings(symbol);

    setState(() {
      estimatedEarnings = [];
      actualEarnings = [];
      dates = [];

      for (int i = 0; i < data.length; i++) {
        final date = data[i]['pricedate'] ?? 'Unknown Date';
        final estimated = (data[i]['estimated'] ?? 0.0).toDouble();
        final actual = (data[i]['actual'] ?? 0.0).toDouble();

        dates.add(date);
        estimatedEarnings.add(FlSpot(i.toDouble(), estimated));
        actualEarnings.add(FlSpot(i.toDouble(), actual));
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChartPage(
            estimatedEarnings: estimatedEarnings,
            actualEarnings: actualEarnings,
            dates: dates,
            name: companyName,
          ),
        ),
      );
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '1787FP Assignment',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(
              child: SpinKitCubeGrid(
                color: Colors.black,
                size: 50.0,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Company',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchCompanies('');
                        },
                      ),
                    ),
                    onChanged: searchCompanies,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = filteredCompanies[index];
                      return ListTile(
                        title: Text(company['description']!),
                        subtitle: Text(company['symbol']!),
                        onTap: () {
                          companyName = company['description']!;
                          fetchEarningsData(company['symbol']!);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
