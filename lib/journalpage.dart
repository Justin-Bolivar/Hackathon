import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'dart:convert';

import 'globals.dart';

class JournalPage extends StatefulWidget {
  final String selectedDate;
  final int selectedID;

  JournalPage({required this.selectedDate, required this.selectedID});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  Future<Map<String, dynamic>> fetchJournalEntry() async {
    String url =
        'http://172.29.10.200:8080//panic/${widget.selectedID}/deleteUpdateEntry/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load journal entry');
    }
  }

  Map<String, int> calculateEmotionPercentages(List<dynamic> emotions) {
    Map<String, int> percentages = {};
    emotions.forEach((emotion) {
      String label = emotion['label'];
      double score = emotion['score'];
      int percentage = (score * 100).round();
      if (percentage > 0) {
        percentages[label] = percentage;
      }
    });
    return percentages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchJournalEntry(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF8FA247)));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, int> emotionPercentages =
                calculateEmotionPercentages(snapshot.data!['emotions'][0]);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '${snapshot.data!['date']}',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8FA247)),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${snapshot.data!['time']}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FA247),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('${snapshot.data!['thoughts']}',
                            style: const TextStyle(color: Color(0xFFFFFBF0))),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    PieChart(
                      dataMap: emotionPercentages
                          .map((key, value) => MapEntry(key, value.toDouble())),
                      chartType: ChartType.ring,
                      chartRadius: MediaQuery.of(context).size.width / 3,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
