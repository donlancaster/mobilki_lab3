import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lab_3/presentation/utils/colors.dart';

import '../utils/image_constants.dart';

class DevelopersPage extends StatelessWidget {
  const DevelopersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const _AppBar(),
          const Center(
            child: Text(
              'Лабораторная номер 3',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Alegreya',
                color: Colors.white70,
                decoration: null,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Шевченко Даниил',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Alegreya',
              color: Colors.white,
              decoration: null,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              child: const Image(
                image: AssetImage('assets/images/profile.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'группа 951005',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Alegreya',
              color: Colors.white70,
              decoration: null,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => _navigateBack(context),
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
            child: Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }

  void _navigateBack(BuildContext context) => Navigator.of(context).pop();
}
