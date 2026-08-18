class Song {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String tag;
  final String audioUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.tag,
    required this.audioUrl,
  });

  @override
 bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        artist.hashCode ^
        coverUrl.hashCode ^
        tag.hashCode ^
        audioUrl.hashCode;
  }
}

final List<Song> sampleSongs = [
  Song(
    id: '1',
    title: '2002',
    artist: 'Anne-Marie',
    coverUrl: 'https://picsum.photos/id/145/800/600',
    tag: 'Pop',
    audioUrl: 'audio/Anne-Marie - 2002 (Lyrics).mp3',
  ),
  Song(
    id: '2',
    title: 'When I Was Your Man',
    artist: 'Bruno Mars',
    coverUrl: 'https://picsum.photos/id/1067/800/600',
    tag: 'R&B / Soul',
    audioUrl: 'audio/Bruno Mars - When I Was Your Man.mp3',
  ),
  Song(
    id: '3',
    title: 'Story of My Life',
    artist: 'One Direction',
    coverUrl: 'https://picsum.photos/id/225/800/600',
    tag: 'Pop / Rock',
    audioUrl: 'audio/One Direction - Story of My Life.mp3',
  ),
];