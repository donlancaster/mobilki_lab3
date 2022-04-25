import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lab_3/presentation/pages/profile/profile_controller.dart';
import 'package:lab_3/presentation/utils/colors.dart';

import '../../utils/image_constants.dart';
import '../auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _AppBar(controller: controller),
            _ProfilePhoto(
              profilePhoto: controller.userImage,
              onPhotoTap: controller.pickImage,
            ),
            _Username(
              username: controller.username,
              changeUserName: controller.changeUserName,
            ),
            _Playlists(controller: controller),
          ],
        );
      }),
    );
  }
}

class _AppBar extends StatelessWidget {
  final ProfileController controller;

  const _AppBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              ImageConstants.burger,
              color: Colors.white,
              height: 22,
              width: 22,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 3,
            child: SvgPicture.asset(
              ImageConstants.flower,
              color: Colors.white,
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => exit(context),
              child: const Text(
                'exit',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  void exit(BuildContext context) {
    controller.logout();
    controller.dispose();
    _navigateToLoginPage(context);
  }

  void _navigateToLoginPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => const AuthPage(isLoginForm: true));
    Navigator.pushReplacement(context, route);
  }
}

class _ProfilePhoto extends StatelessWidget {
  static const _userImageSize = 150.0;
  final String? profilePhoto;
  final VoidCallback onPhotoTap;

  const _ProfilePhoto({
    Key? key,
    required this.profilePhoto,
    required this.onPhotoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
      ),
      child: GestureDetector(
        onTap: onPhotoTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: _userImageSize,
              width: _userImageSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.buttonPressedColor,
              ),
            ),
            profilePhoto == null
                ? SvgPicture.asset(
              ImageConstants.user,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            )
                : CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 75,
              foregroundImage: NetworkImage(profilePhoto!),
            ),
          ],
        ),
      ),
    );
  }
}

class _Username extends StatefulWidget {
  final String username;
  final void Function(String) changeUserName;

  const _Username({Key? key, required this.username, required this.changeUserName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsernameState();
}

class _UsernameState extends State<_Username> {
  final TextEditingController _textEditingController = TextEditingController();
  static const _minUsernameLength = 6;
  static const _maxUsernameLength = 15;
  late final StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = KeyboardVisibilityController().onChange.listen((isVisible) {
      if (!isVisible) {
        _onEditingComplete();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.username;
    return TextField(
      textAlign: TextAlign.center,
      controller: _textEditingController,
      style: const TextStyle(
        fontSize: 35,
        fontFamily: 'Alegreya',
        color: Colors.white,
        decoration: null,
      ),
      decoration: null,
      onEditingComplete: _onEditingComplete,
    );
  }

  void _onEditingComplete() {
    FocusScope.of(context).requestFocus(FocusNode());
    final newUserName = _textEditingController.text;
    if (newUserName.length >= _minUsernameLength && newUserName.length <= _maxUsernameLength) {
      widget.changeUserName(newUserName);
    } else {
      _textEditingController.text = widget.username;
    }
  }
}

class _Playlists extends StatelessWidget {
  final ProfileController controller;

  const _Playlists({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.playlists.length + 1,
        itemBuilder: (context, index) {
          if (index != controller.playlists.length) {
            final playlist = controller.playlists[index];
            return _playlistCard(
              onTap: () {},
              coverUrl: playlist.coverUrl,
              name: playlist.name,
            );
          } else {
            return _playlistCard(
              onTap: () {},
              coverUrl: null,
              name: '',
            );
          }
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 4 / 3,
        ),
      ),
    );
  }

  Widget _playlistCard({
    required VoidCallback onTap,
    required String name,
    required String? coverUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.green,
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              if (coverUrl != null) ...[
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
              if (coverUrl == null)
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
