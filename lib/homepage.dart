import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:panic_application/journalpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<String> dates = [];
  List<int> ids = [];
  List<String> topEmotions = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  int bpm = 80;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchDates();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    startBPMUpdate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel(); // Cancel the timer if it is not null
    super.dispose();
  }

  Future<void> fetchDates() async {
    const String url = 'http://172.29.10.200:8080/panic/getListOfJournals/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> data = jsonDecode(response.body);
        dates = data.map((item) => item['date'] as String).toList();
        ids = data.map((item) => item['id'] as int).toList();
        topEmotions = data.map((item) {
          var topEmotion = item['emotions'][0][0];
          return '${topEmotion['label']} (${(topEmotion['score'] * 100).toStringAsFixed(2)}%)';
        }).toList();
      });
    } else {
      throw Exception('Failed to load dates');
    }
  }

  void startBPMUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        bpm = Random().nextInt(21) + 70;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF0),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Transform.scale(
                        scale: _animation.value,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '$bpm',
                          style: const TextStyle(
                              color: Colors.red, fontSize: 50.0),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          'bpm',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  );
                },
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
                              builder: (context) => JournalPage(
                                  selectedDate: dates[index],
                                  selectedID: ids[index]),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF8FA247),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dates[index],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Color(0xFFFFFBF0),
                                  ),
                                ),
                                Text(
                                  topEmotions[index],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Color(0xFFFFFBF0),
                                  ),
                                ),
                              ],
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
