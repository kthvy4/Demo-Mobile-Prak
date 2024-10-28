import 'package:demo_mobile/app/modules/webview/article.dart';
import 'package:flutter/material.dart';// Import halaman artikel

void main() {
  runApp(CatCareApp());
}

class CatCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ArticlePage(),
    );
  }
}

class Navigasi extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Navigasi> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Halaman lain seperti Shopping atau Profile
    Center(child: Text('Home Page')),
    ArticlePage(),  // Halaman Artikel
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CatCare'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
