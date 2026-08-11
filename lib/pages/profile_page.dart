import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/song_model.dart';
import 'package:flutter_application_1/pages/favorite_page.dart';
import 'package:flutter_application_1/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final List<Song> allSongs;

  const ProfilePage({
    super.key,
    required this.allSongs,
  });

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();
    final likeCount = favProvider.favoriteIds.length;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF6366F1),
              child: const CircleAvatar(
                radius: 46,
                backgroundImage: AssetImage('image/Aku.jpeg'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Naila Aribah Zahra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Music Enthusiast',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 30, 12, 113),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('$likeCount', 'Liked'),
                  Container(width: 1, height: 24, color: Colors.white10),
                  _buildStatItem('24th', 'Streamed'),
                  Container(width: 1, height: 24, color: Colors.white10),
                  _buildStatItem('5', 'Playlist'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(Icons.favorite_rounded, "Favorite Songs", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(
                    allSongs: allSongs,
                  ),
                ),
              );
            }),
            _buildMenuItem(Icons.history_rounded, "Recently Played"),
            _buildMenuItem(Icons.store_rounded, "Clear Cache Data"),
            _buildMenuItem(Icons.settings_rounded, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6366F1), size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
