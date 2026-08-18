import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/audioplayer_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';

class DetailPage extends StatefulWidget {
  final Song song;
  final List<Song> playlist;
  const DetailPage({super.key, required this.song, this.playlist = const []});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioPlayerProvider>().playSong(
        widget.song,
        playlist: widget.playlist.isNotEmpty ? widget.playlist : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioPlayerProvider>();
    final player = audioProvider.player;
    final song = audioProvider.currentSong ?? widget.song;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        song.coverUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      song.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      song.artist,
                      style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),

            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                // Pastikan duration minimal 1.0 jika belum ter-load (0)
                final durationSec =
                    (player.duration?.inSeconds.toDouble() ?? 0.0);
                final maxDuration = durationSec > 0 ? durationSec : 1.0;

                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble().clamp(
                        0.0,
                        maxDuration,
                      ),
                      max: maxDuration,
                      activeColor: const Color(0xFF6366F1),
                      inactiveColor: Colors.white10,
                      onChanged: (v) =>
                          audioProvider.seek(Duration(seconds: v.toInt())),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            position.toString().split('.').first,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            (player.duration ?? Duration.zero)
                                .toString()
                                .split('.')
                                .first,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),

            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous button
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        size: 40,
                        color: audioProvider.hasPrevious
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                      onPressed: audioProvider.hasPrevious
                          ? audioProvider.playPrevious
                          : null,
                    ),
                    const SizedBox(width: 16),
                    // Play/Pause button
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF6366F1),
                      child: IconButton(
                        icon: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 34,
                          color: Colors.white,
                        ),
                        onPressed: audioProvider.togglePlayPause,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Next button
                    IconButton(
                      icon: Icon(
                        Icons.skip_next_rounded,
                        size: 40,
                        color: audioProvider.hasNext
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                      onPressed: audioProvider.hasNext
                          ? audioProvider.playNext
                          : null,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

