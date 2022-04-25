import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab_3/data/repos/auth_repository.dart';
import 'package:lab_3/data/repos/user_repository.dart';

class MainPageController {
  final Rx<String?> _userImage = Rx<String?>(null);
  final Rx<String> _username = Rx<String>('User');
  final UserRepository _repository = UserRepository();
  final AuthRepository _authRepository = AuthRepository();

  final List<StreamSubscription> _subscriptions = [];


  MainPageController() {
    _subscriptions.add(_repository.userImageStream.listen((image) => _userImage.value = image));
    _subscriptions.add(_repository.usernameStream.listen((username) => _username.value = username));
  }

  String? get userImage => _userImage.value;

  String get username => _username.value;
}
