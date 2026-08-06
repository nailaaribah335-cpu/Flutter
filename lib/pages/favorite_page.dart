import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../widgets/song_card.dart';

class FavoritePage extends StatefulWidget {
  final List<Song> favoriteSongs;
  final void Function(Song)? onFavoriteToggle;

  const FavoritePage({
    super.key,
    required this.favoriteSongs,
    this.onFavoriteToggle,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Song> favoriteSongs;

  @override
  void initState() {
    super.initState();
    favoriteSongs = List.from(widget.favoriteSongs);
  }

  void removeFavorite(Song song) {
    widget.onFavoriteToggle?.call(song);

    setState(() {
      favoriteSongs.remove(song);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Favorite Songs (${favoriteSongs.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: favoriteSongs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada lagu favorit',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SongCard(
                    song: song,
                    isFavorite: true,
                    onFavoriteToggle: () => removeFavorite(song),
                  ),
                );
              },
            ),
    );
  }
}
