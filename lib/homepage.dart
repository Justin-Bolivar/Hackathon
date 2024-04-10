import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:panic_application/journalpage.dart';
import 'globals.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDates();
    _initAnimation();
    _startBPMUpdate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDates() async {
    String url = 'http://172.29.10.200:8080/panic/getListOfJournals/';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        dates = data.map((item) => item['date'] as String).toList();
        ids = data.map((item) => item['id'] as int).toList();
        topEmotions = data.map((item) {
          var topEmotion = item['emotions'][0][0];
          var percentage = (topEmotion['score'] * 100).round().toString();
          return '${topEmotion['label']} ($percentage%)';
        }).toList();
      } else {
        // Handle API error
        print('Failed to load dates: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other exceptions
      print('Error fetching dates: $e');
    } finally {
      _isLoading = false;
    }
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startBPMUpdate() {
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
        toolbarHeight: 100.0,
        backgroundColor: const Color(0xFFFFFBF0),
        title: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: _buildBPMDisplay(),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 400,
                    child: Column(
                      children: List.generate(dates.length, _buildJournalCard),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF8FA247)),
            ),
        ],
      ),
    );
  }

  Widget _buildBPMDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _animation.value,
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 50.0,
              ),
            );
          },
        ),
        const SizedBox(width: 10.0),
        Text(
          '$bpm',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 50.0,
          ),
        ),
        const SizedBox(width: 5.0),
        const Text(
          'bpm',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildJournalCard(int index) {
    final dateParts = dates[index].split(' ');
    String month = "Month";
    String day = "Day";

    if (dateParts.length >= 2) {
      month = dateParts[0];
      day = dateParts[1];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalPage(
                  selectedDate: dates[index], selectedID: ids[index]),
            ),
          );
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF8FA247),
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 20.0),
                _buildDateColumn(month, day),
                const SizedBox(width: 20.0),
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
  }

  Widget _buildDateColumn(String month, String day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          month,
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFBF0),
          ),
        ),
        Text(
          day,
          style: const TextStyle(
            fontSize: 40.0,
            color: Color(0xFFFFFBF0),
          ),
        ),
      ],
    );
  }
}
