import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:panic_application/globals.dart';

import 'package:panic_application/settings.dart';

class WriteJournalPage extends StatefulWidget {
  @override
  _WriteJournalPageState createState() => _WriteJournalPageState();
}

class _WriteJournalPageState extends State<WriteJournalPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendPostRequest() async {
    const String url = 'http://172.30.1.190:8080/panic/create/';
    final String text = _controller.text;

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('MMMM d').format(now);
    final String formattedTime = DateFormat('h:mm a').format(now);

    final String dateString = '$formattedDate';
    final String timeString = ' $formattedTime';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'date': dateString,
          'time': timeString,
          'isPanic': true,
          'thoughts': text,
        },
      ),
    );
    if (response.statusCode == 201) {
      print('POST request successful');
    } else {
      throw Exception('Failed to send POST request');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('MMMM d').format(now);
    final String formattedTime = DateFormat('h:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Journal Page'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Text(
            formattedDate,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            formattedTime,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              maxLines: 10,
              expands: false,
              decoration: InputDecoration(
                hintText: 'Start your Journal.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: _sendPostRequest,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
