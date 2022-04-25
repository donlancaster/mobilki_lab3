import 'package:lab_3/data/datasources/remote_datasource.dart';

import '../entities/playlist.dart';

abstract class PlaylistRepository {
  static final PlaylistRepository _singleton = _PlaylistRepositoryImpl(RemoteDataSource());

  factory PlaylistRepository() => _singleton;

  Stream<List<Playlist>> get playlistsStream;

  Future<void> addPlaylist({required String name, required String userImage});
}

class _PlaylistRepositoryImpl implements PlaylistRepository {
  final RemoteDataSource _datasource;

  _PlaylistRepositoryImpl(this._datasource);

  @override
  Stream<List<Playlist>> get playlistsStream => _datasource.playlistsStream;

  @override
  Future<void> addPlaylist({required String name, required String userImage}) =>
      _datasource.createPlaylist(name: name, userImage: userImage);
}
