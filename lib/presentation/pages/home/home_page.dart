import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab_3/presentation/pages/home/home_controller.dart';
import 'package:lab_3/presentation/pages/main/main_page.dart';
import 'package:lab_3/presentation/pages/profile/profile_page.dart';

import '../../utils/colors.dart';
import '../../widgets/bottom_bar.dart';
import '../listening_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: controller.currentTab.value,
                children: [
                  MainPage(
                    mood: controller.mood,
                    setMood: (mood) => controller.mood = mood,
                  ),
                  ListeningPage(mood: controller.mood),
                  const ProfilePage(),
                ],
              ),
            ),
            BottomBar(homeController: controller),
          ],
        ),
      );
    });
  }
}
