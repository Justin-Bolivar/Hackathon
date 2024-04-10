import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:panic_application/settings.dart';

class WriteJournalPage extends StatefulWidget {
  @override
  _WriteJournalPageState createState() => _WriteJournalPageState();
}

class _WriteJournalPageState extends State<WriteJournalPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendPostRequest() async {
    String url = 'http://172.29.10.200:8080/panic/create/';
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
          'isPanic': true, // Check if this value is correct
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
        backgroundColor: const Color(0xFFFFFBF0),
        actions: [
          IconButton(
            color: const Color(0xFFFFFBF0),
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
      backgroundColor: const Color(0xFFFFFBF0),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8FA247),
            ),
          ),
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              controller: _controller,
              maxLines: 10,
              expands: false,
              decoration: InputDecoration(
                hintText: 'Start your Journal.',
                hintStyle: const TextStyle(
                  color: Color(0xFFFFFBF0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                filled: true,
                fillColor: const Color(0xFF8FA247),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: const Color(0xFFFFFBF0),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: _sendPostRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF647131),
              foregroundColor: const Color(0xFFFFFBF0),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
