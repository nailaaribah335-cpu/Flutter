import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/song_model.dart';
import 'feed_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class MainNavigation extends StatefulWidget {
  final List<Song> favoriteSongs;
  final void Function(Song)? onFavoriteToggle;

  const MainNavigation({
    super.key,
    required this.favoriteSongs,
    this.onFavoriteToggle,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late List<Song> favoriteSongs;

  @override
  void initState() {
    super.initState();
    favoriteSongs = List.from(widget.favoriteSongs);
  }

  void toggleFavorite(Song song) {
    setState(() {
      if (favoriteSongs.contains(song)) {
        favoriteSongs.remove(song);
      } else {
        favoriteSongs.add(song);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FeedPage(favoriteSongs: favoriteSongs, onFavoriteToggle: toggleFavorite),
      SearchPage(favoriteSongs: favoriteSongs, onFavoriteToggle: toggleFavorite),
      ProfilePage(favoriteSongs: favoriteSongs, onFavoriteToggle: toggleFavorite),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF151922),
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
