import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JournalPage extends StatefulWidget {
  final String selectedDate;
  final int selectedID;

  JournalPage({required this.selectedDate, required this.selectedID});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late String date;
  late String time;
  late String thoughts;
  late String emotions;

  @override
  void initState() {
    super.initState();
    fetchJournalEntry();
  }

  Future<void> fetchJournalEntry() async {
    final String url =
        'http://172.29.10.200:8080/panic/getJournalEntry/${widget.selectedID}/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> data = jsonDecode(response.body);
        date = data['date'];
        time = data['time'];
        thoughts = data['thoughts'];
        emotions = data['emotions'];
      });
    } else {
      throw Exception('Failed to load journal entry');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Thoughts: $thoughts'),
            Text('Emotions: $emotions'),
          ],
        ),
      ),
    );
  }
}
