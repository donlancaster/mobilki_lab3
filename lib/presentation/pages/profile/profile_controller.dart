import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab_3/data/entities/playlist.dart';
import 'package:lab_3/data/repos/auth_repository.dart';
import 'package:lab_3/data/repos/playlist_repository.dart';
import 'package:lab_3/data/repos/user_repository.dart';

class ProfileController {
  final Rx<String?> _userImage = Rx<String?>(null);

  final Rx<String> _username = Rx<String>('User');

  final Rx<List<Playlist>> _playlists = Rx<List<Playlist>>([]);

  final UserRepository _repository = UserRepository();
  final AuthRepository _authRepository = AuthRepository();
  final PlaylistRepository _playlistRepository = PlaylistRepository();

  final List<StreamSubscription> _subscriptions = [];

  ProfileController() {
    _subscriptions.add(_repository.userImageStream.listen((image) => _userImage.value = image));
    _subscriptions.add(_repository.usernameStream.listen((username) => _username.value = username));
    _subscriptions.add(
        _playlistRepository.playlistsStream.listen((playlists) => _playlists.value = playlists));
  }

  String? get userImage => _userImage.value;

  String get username => _username.value;

  List<Playlist> get playlists => _playlists.value;

  void pickImage() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _repository.updateUserImage(userImage: image.path);
    }
  }

  void changeUserName(String text) => _repository.updateUsername(username: text);

  void logout() {
    _authRepository.logout();
    _userImage.value = null;
    _username.value = '';
  }

  void dispose() {}
}
