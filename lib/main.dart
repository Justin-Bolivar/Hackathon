import 'package:flutter/material.dart';
import 'package:panic_application/homepage.dart';
import 'package:panic_application/writepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    WriteJournalPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFEEE29E),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Write',
            ),
          ],
          currentIndex: _selectedIndex,
          elevation: 0,
          backgroundColor: const Color(0xFFFFFBF0),
          selectedItemColor: const Color(0xFF8FA247),
          unselectedItemColor: const Color(0xFF647131),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
