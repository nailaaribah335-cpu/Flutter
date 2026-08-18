import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;

  AudioPlayer get player => _player;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;
  bool get hasPrevious => _currentIndex > 0;
  bool get hasNext => _currentIndex < _playlist.length - 1;

  /// Set playlist dan mainkan lagu yang dipilih
  Future<void> playSong(Song song, {List<Song>? playlist}) async {
    // Update playlist jika diberikan
    if (playlist != null) {
      _playlist = playlist;
      _currentIndex = playlist.indexWhere((s) => s.id == song.id);
      if (_currentIndex < 0) _currentIndex = 0;
    }

    // Jika lagu yang sama masih diputar, tidak perlu setUrl ulang
    if (_currentSong?.id == song.id) {
      // Jika lagunya sedang di-pause, kita play lagi
      if (!_player.playing) _player.play();
      return;
    }

    try {
      _currentSong = song;
      await _player.setUrl(song.audioUrl);
      await _player.play();
      
      // Notify setelah URL di-set dan play dipanggil, agar UI update
      notifyListeners(); 
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  Future<void> playNext() async {
    if (!hasNext) return;
    _currentIndex++;
    await playSong(_playlist[_currentIndex]);
  }

  Future<void> playPrevious() async {
    if (!hasPrevious) return;
    _currentIndex--;
    await playSong(_playlist[_currentIndex]);
  }

  void togglePlayPause() {
    _player.playing ? _player.pause() : _player.play();
    // Tidak perlu notifyListeners di sini karena UI DetailPage 
    // sudah menggunakan StreamBuilder untuk playerStateStream
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}