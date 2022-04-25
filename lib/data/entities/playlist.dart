class Playlist {
  final String id;
  final String name;
  final String coverUrl;

  Playlist({required this.id, required this.coverUrl, required this.name});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      coverUrl: json['cover'],
      name: json['name'],
    );
  }
}
