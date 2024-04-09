import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JournalPage extends StatefulWidget {
  final String selectedDate;
  final int selectedID;

  JournalPage({Key? key, required this.selectedDate, required this.selectedID})
      : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String emotions = 'Loading...';
  String thoughts = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String apiUrl =
        'http://172.29.10.200:8080/panic/getListOfJournals/';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        emotions = data['emotions'];
        thoughts = data['thoughts'];
      });
    } else {
      setState(() {
        emotions = 'Failed to load data';
        thoughts = 'Failed to load data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Page for ${widget.selectedDate}'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            widget.selectedDate,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Text(
            'Emotions: $emotions',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10.0),
          Text(
            'Thoughts: $thoughts',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
