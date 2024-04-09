import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        'http://${Globals.ipAddress}/panic/${widget.selectedID}/deleteUpdateEntry/';
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
            return Center(child: CircularProgressIndicator());
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
                    Text('Date: ${snapshot.data!['date']}'),
                    Text('Time: ${snapshot.data!['time']}'),
                    Text('Thoughts: ${snapshot.data!['thoughts']}'),
                    Text('Emotions:'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: emotionPercentages.entries
                          .map((entry) => Text('${entry.key}: ${entry.value}%'))
                          .toList(),
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
