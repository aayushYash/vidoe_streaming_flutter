import 'package:flutter/material.dart';
import 'package:video_streaming_proj/screens/profile_screen.dart';
import 'package:video_streaming_proj/screens/feed_screen.dart';
import 'package:video_streaming_proj/screens/watch_party_screen.dart';
import 'package:video_streaming_proj/screens/music_jamming_screen.dart'; // ✅ New Import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Default: Feed
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          ProfileScreen(onSignOut: () {
            Navigator.pushReplacementNamed(context, '/auth');
          }),
          FeedScreen(),
          WatchPartyScreen(),
          MusicJammingScreen(), // ✅ New Tab
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.black,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: "Watch Party"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Jamming"), // ✅ New Icon
        ],
      ),
    );
  }
}
