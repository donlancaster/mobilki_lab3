import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lab_3/data/entities/playlist.dart';

enum RegisterResponse { usernameUnavailable, unsuccessful, successful }

enum LoginResponse { usernameNotFound, passwordIsWrong, successful }

abstract class RemoteDataSource {
  static final RemoteDataSource _singleton =
  _FirebaseDataSource(FirebaseFirestore.instance, FirebaseStorage.instance);
  late String userId;

  Stream<String> get userImageStream;

  Stream<String> get usernameStream;

  Stream<List<Playlist>> get playlistsStream;

  factory RemoteDataSource() => _singleton;

  Future<RegisterResponse> register({required String username, required String password});

  Future<void> updateUserImage({required String userImage});

  Future<void> updateUsername({required String username});

  Future<LoginResponse> login({required String username, required String password});

  Future<void> createPlaylist({required String name, required String userImage});

  void logout();
}

class _FirebaseDataSource implements RemoteDataSource {
  final FirebaseFirestore _fb;
  final FirebaseStorage _storage;
  StreamController<dynamic> _idStreamController = StreamController<dynamic>.broadcast();
  StreamController<String> _userImageStreamController = StreamController<String>.broadcast();
  StreamController<String> _usernameStreamController = StreamController<String>.broadcast();
  late Stream<Map<String, dynamic>?> _userStream;

  @override
  late Stream<List<Playlist>> playlistsStream;

  @override
  late String userId = '';

  static const String _userCollection = 'users';
  static const String _playlistCollection = 'playlists';
  static const String _usernameField = 'username';
  static const String _passwordField = 'password';
  static const String _imagesFolder = 'images';
  static const String _playlistsFolder = 'playlists';
  static const String _userImageField = 'user_image';
  static const String _playlistCoverImageField = 'cover';
  static const String _playlistUserIdField = 'uid';
  static const String _playlistNameField = 'name';

  _FirebaseDataSource(this._fb, this._storage) {
    _updateUserInfoStreamControllers();
    _initializePlaylistsStream();
  }

  @override
  Stream<String> get userImageStream => _userImageStreamController.stream;

  @override
  Stream<String> get usernameStream => _usernameStreamController.stream;

  Future<void> _updateUserInfoStreamControllers() async {
    await for (var _ in _idStreamController.stream) {
      _initializePlaylistsStream();
      _initializeUserStream();
      _userImageStreamController.sink.addStream(
        _userStream
            .where((json) => json![_userImageField] != null)
            .map((json) => json![_userImageField]),
      );
      _usernameStreamController.sink.addStream(
        _userStream
            .where((json) => json![_usernameField] != null)
            .map((json) => json![_usernameField]),
      );
    }
  }

  void _initializePlaylistsStream() {
    playlistsStream = _fb
        .collection(_playlistCollection)
        .where(_playlistUserIdField, isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => Playlist.fromJson(doc.data()..['id'] = doc.id))
        .toList(growable: false));
  }

  void _initializeUserStream() {
    if (userId.isNotEmpty) {
      _userStream = _fb
          .collection(_userCollection)
          .doc(userId)
          .snapshots()
          .map((snapshot) => snapshot.data());
    }
  }

  @override
  Future<RegisterResponse> register({required String username, required String password}) async {
    final availabilityCheck =
    await _fb.collection(_userCollection).where(_usernameField, isEqualTo: username).get();
    if (availabilityCheck.docs.isNotEmpty) {
      return RegisterResponse.usernameUnavailable;
    }
    final response = await _fb
        .collection(_userCollection)
        .add({_usernameField: username, _passwordField: password});
    userId = response.id;
    _idStreamController.add(response.id);
    return RegisterResponse.successful;
  }

  @override
  Future<LoginResponse> login({required String username, required String password}) async {
    final response =
    await _fb.collection(_userCollection).where(_usernameField, isEqualTo: username).get();
    if (response.docs.isEmpty) {
      return LoginResponse.usernameNotFound;
    }
    if (response.docs.single.data()[_passwordField] != password) {
      return LoginResponse.passwordIsWrong;
    }
    userId = response.docs.single.id;
    _idStreamController.add(response.docs.single.id);
    return LoginResponse.successful;
  }

  @override
  Future<void> updateUserImage({required String userImage}) async {
    final file = File(userImage);
    final path = '$_imagesFolder/$userId-${userImage.substring(userImage.length - 10)}';
    final snapshot = await _storage.ref().child(path).putFile(file);
    final url = await snapshot.ref.getDownloadURL();
    return _fb.collection(_userCollection).doc(userId).set(
      {_userImageField: url},
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> updateUsername({required String username}) {
    return _fb.collection(_userCollection).doc(userId).set(
      {_usernameField: username},
      SetOptions(merge: true),
    );
  }

  @override
  void logout() async {
    _idStreamController = StreamController<dynamic>.broadcast();
    _userImageStreamController = StreamController<String>.broadcast();
    _usernameStreamController = StreamController<String>.broadcast();
    _updateUserInfoStreamControllers();
  }

  @override
  Future<void> createPlaylist({required String name, required String userImage}) async {
    final file = File(userImage);
    final path = '$_playlistsFolder/$userId-${userImage.substring(userImage.length - 10)}';
    final snapshot = await _storage.ref().child(path).putFile(file);
    final url = await snapshot.ref.getDownloadURL();
    _fb.collection(_playlistCollection).add({
      _playlistCoverImageField: url,
      _playlistUserIdField: userId,
      _playlistNameField: name,
    });
  }
}
