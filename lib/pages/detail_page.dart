import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class DetailPage extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;

  const DetailPage({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  Song get _currentSong => widget.songs[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.value = 1.0;

    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setUrl(_currentSong.audioUrl);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  Future<void> _changeSong(int newIndex) async {
    if (newIndex < 0 || newIndex >= widget.songs.length) return;

    // Animate out
    await _animController.reverse();

    setState(() {
      _currentIndex = newIndex;
    });

    // Reset & load new audio
    await _audioPlayer.stop();
    try {
      await _audioPlayer.setUrl(_currentSong.audioUrl);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }

    // Animate in
    _animController.forward();
  }

  void _playNext() => _changeSong(_currentIndex + 1);
  void _playPrev() => _changeSong(_currentIndex - 1);

  bool get _hasNext => _currentIndex < widget.songs.length - 1;
  bool get _hasPrev => _currentIndex > 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: GestureDetector(
        // Swipe kiri = next, swipe kanan = previous
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! < -300) {
            // swipe kiri → next
            if (_hasNext) _playNext();
          } else if (details.primaryVelocity! > 300) {
            // swipe kanan → prev
            if (_hasPrev) _playPrev();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 4),

              // Cover Art dengan fade animation saat ganti lagu
              FadeTransition(
                opacity: _fadeAnim,
                child: Hero(
                  tag: 'cover_${_currentSong.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        _currentSong.coverUrl,
                        height: 255,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Judul & artist dengan fade
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text(
                      _currentSong.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentSong.artist,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Indikator posisi lagu (dots)
              if (widget.songs.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.songs.length, (i) {
                      final isActive = i == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF6366F1)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),

              // Slider posisi audio
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = _audioPlayer.duration ?? Duration.zero;

                  return Column(
                    children: [
                      Slider(
                        value: position.inSeconds.toDouble().clamp(
                          0.0,
                          duration.inSeconds.toDouble() > 0
                              ? duration.inSeconds.toDouble()
                              : 1.0,
                        ),
                        max: duration.inSeconds.toDouble() > 0
                            ? duration.inSeconds.toDouble()
                            : 1.0,
                        activeColor: const Color(0xFF6366F1),
                        inactiveColor: Colors.white10,
                        onChanged: (v) {
                          _audioPlayer.seek(Duration(seconds: v.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
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

              // Kontrol: Prev, Play/Pause, Next
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Previous
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 36,
                      color: _hasPrev ? Colors.white : Colors.white24,
                    ),
                    onPressed: _hasPrev ? _playPrev : null,
                  ),
                  const SizedBox(width: 20),

                  // Tombol Play/Pause
                  StreamBuilder<PlayerState>(
                    stream: _audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;

                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF6366F1),
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (playing != true) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF6366F1),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              size: 34,
                              color: Colors.white,
                            ),
                            onPressed: _audioPlayer.play,
                          ),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF6366F1),
                          child: IconButton(
                            icon: const Icon(
                              Icons.pause_rounded,
                              size: 34,
                              color: Colors.white,
                            ),
                            onPressed: _audioPlayer.pause,
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(width: 20),

                  // Tombol Next
                  IconButton(
                    icon: Icon(
                      Icons.skip_next_rounded,
                      size: 36,
                      color: _hasNext ? Colors.white : Colors.white24,
                    ),
                    onPressed: _hasNext ? _playNext : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}