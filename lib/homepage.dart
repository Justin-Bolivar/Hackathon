import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panic_application/journalpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> dates = [];

  @override
  void initState() {
    super.initState();
    fetchDates();
  }

  Future<void> fetchDates() async {
    final String url =
        'http://172.30.1.190:8080/panic/getListOfJournals/'; // Replace with your API URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        // Assuming the API returns a list of objects, each with a 'date' field
        List<dynamic> data = jsonDecode(response.body);
        dates = data.map((item) => item['date'] as String).toList();
      });
    } else {
      throw Exception('Failed to load dates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 50.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '80',
                      style: TextStyle(color: Colors.red, fontSize: 50.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      'bpm',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: Column(
                  children: List.generate(dates.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JournalPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dates[index],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
