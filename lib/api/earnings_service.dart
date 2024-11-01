import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class EarningsService {
  Future<List<Map<String, String>>> loadCompanies() async {
    final rawData = await rootBundle.loadString('assets/stock_symbols.csv');
    List<List<dynamic>> csvData =
        const CsvToListConverter().convert(rawData, eol: '\n');
    List<Map<String, String>> companies = [];
    for (var row in csvData) {
      if (row.length >= 2) {
        companies.add({
          'symbol': row[0].toString(),
          'description': row[1].toString(),
        });
      }
    }
    return companies;
  }
  Future<List<Map<String, dynamic>>> fetchEarnings(String symbol) async {
    final apiUrl =
        'https://api.api-ninjas.com/v1/earningscalendar?ticker=$symbol';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'X-Api-Key': 'YOUR_API_KEY'},
    );

    if (response.statusCode == 200) {
      // print(response.body);
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        final estimatedRevenue = (item['estimated_revenue'] ?? 0.0).toDouble();
        final actualRevenue = (item['actual_revenue'] ?? 0.0).toDouble();
        final date = item['pricedate'] ?? 'Unknown Date';

        return {
          'pricedate': date, 
          'estimated': estimatedRevenue,
          'actual': actualRevenue,
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch earnings data');
    }
  }
}
