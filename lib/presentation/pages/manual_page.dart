import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lab_3/presentation/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/image_constants.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          _AppBar(),
          Expanded(child: _Slider()),
          Expanded(child: _Horoscope()),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  static const List<String> _images = [
    'assets/images/slide1.png',
    'assets/images/slide2.png',
    'assets/images/slide3.png',
  ];

  const _Slider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
      ),
      items: _images
          .map((item) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 800,
            width: 350,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                child: Image(
                  image: AssetImage(item),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ))
          .toList(),
    );
  }
}

class _Horoscope extends StatelessWidget {
  const _Horoscope({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: const SizedBox(
        height: 300,
        child: WebView(
          initialUrl: 'https://www.horoscope.com/us/horoscopes/general/index-horoscope-general-daily.aspx',
        ),
      ),
      borderRadius: BorderRadius.circular(20),
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
