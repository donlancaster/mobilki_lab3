import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lab_3/presentation/pages/developers_page.dart';
import 'package:lab_3/presentation/pages/home/home_controller.dart';
import 'package:lab_3/presentation/utils/colors.dart';
import '../../utils/image_constants.dart';
import '../manual_page.dart';
import 'main_page_controller.dart';

class MainPage extends StatefulWidget {
  final void Function(Mood?) setMood;
  final Mood? mood;

  const MainPage({Key? key, required this.mood, required this.setMood}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainPageController controller = MainPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: Obx(() {
        return Column(
          children: [
            _AppBar(controller: controller),
            _welcomeSign(),
            const SizedBox(height: 15),
            _Playlists(
              mood: widget.mood,
              setMood: widget.setMood,
            ),
            _section(
              title: 'Руководство',
              description: 'Руководство по использованию',
              onMoreButtonClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManualPage(),
                  ),
                );
              },
              imagePath: ImageConstants.section1,
            ),
            _section(
              title: 'О разработчике',
              description: 'Его идеи будут \nактуальны всегда',
              onMoreButtonClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DevelopersPage(),
                  ),
                );
              },
              imagePath: ImageConstants.section2,
            ),
          ],
        );
      }),
    );
  }

  Widget _welcomeSign() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'С возвращением, ${controller.username}!',
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Alegreya',
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            'Каким ты себя ощущаешь сегодня?',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'AlegreyaSans',
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String description,
    required VoidCallback onMoreButtonClicked,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Center(
        child: Container(
          height: 170,
          width: 340,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    height: 100,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 180,
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Alegreya Sans',
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      width: 140,
                      child: ElevatedButton(
                        child: const Text('Подробнее'),
                        onPressed: onMoreButtonClicked,
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            CustomColors.defaultBackgroundColor,
                          ),
                          elevation: MaterialStateProperty.all(0.0),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Playlists extends StatelessWidget {
  final Mood? mood;
  final void Function(Mood?) setMood;

  const _Playlists({
    Key? key,
    required this.mood,
    required this.setMood,
  }) : super(key: key);

  static const List<MapEntry<String, String>> playlists = [
    MapEntry(ImageConstants.calm, 'Спокойным'),
    MapEntry(ImageConstants.anxious, 'Взволнованным'),
    MapEntry(ImageConstants.relax, 'Расслабленным'),
    MapEntry(ImageConstants.focus, 'Сосредоточенным'),
  ];

  static final Map<MapEntry<String, String>, Mood?> _moods = {
    playlists[0]: Mood.calm,
    playlists[1]: Mood.anxious,
    playlists[2]: Mood.relax,
    playlists[3]: Mood.focus,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        itemBuilder: (context, index) => _playlistCard(playlists[index]),
      ),
    );
  }

  Widget _playlistCard(MapEntry<String, String> playlist) {
    final hasBorder = _moods[playlist] == mood;
    return Padding(
      padding: const EdgeInsets.all(12.5),
      child: GestureDetector(
        onTap: () {
          if (hasBorder) {
            setMood(null);
          } else {
            setMood(_moods[playlist]);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: hasBorder
                    ? Border.all(
                  color: Colors.orange,
                  width: 3,
                )
                    : null,
              ),
              alignment: Alignment.center,
              child: SizedBox(
                height: 40,
                width: 40,
                child: SvgPicture.asset(
                  playlist.key,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 70,
              child: Text(
                playlist.value,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final MainPageController controller;

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
            child: _profileImage(),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Obx(() {
      return GestureDetector(
        onTap: _navigateToLoginProfilePage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.buttonPressedColor,
              ),
            ),
            controller.userImage == null
                ? SvgPicture.asset(
              ImageConstants.user,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            )
                : CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 17.5,
              foregroundImage: NetworkImage(controller.userImage!),
            ),
          ],
        ),
      );
    });
  }

  void _navigateToLoginProfilePage() {
    HomeController().updateCurrentTab(2);
  }
}
