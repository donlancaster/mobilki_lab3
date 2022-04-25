import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lab_3/presentation/utils/colors.dart';

import '../pages/home/home_controller.dart';
import '../utils/image_constants.dart';

class BottomBar extends StatefulWidget {
  final HomeController homeController;

  const BottomBar({Key? key, required this.homeController}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late final HomeController _homeController;

  @override
  void initState() {
    _homeController = widget.homeController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: CustomColors.defaultBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _MenuButton(
                index: 0,
                iconPath: ImageConstants.flower,
                isCurrentTab: _homeController.isCurrentTab,
                onTap: _homeController.updateCurrentTab,
              ),
              _MenuButton(
                index: 1,
                iconPath: ImageConstants.sound,
                isCurrentTab: _homeController.isCurrentTab,
                onTap: _homeController.updateCurrentTab,
              ),
              _MenuButton(
                index: 2,
                iconPath: ImageConstants.user,
                isCurrentTab: _homeController.isCurrentTab,
                onTap: _homeController.updateCurrentTab,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String iconPath;
  final int index;
  final bool Function(int) isCurrentTab;
  final void Function(int) onTap;

  const _MenuButton({
    Key? key,
    required this.iconPath,
    required this.index,
    required this.isCurrentTab,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 60,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => onTap(index),
          child: Obx(
                () => Column(
              children: [
                const SizedBox(height: 14),
                SizedBox(
                  height: isCurrentTab(index) ? 30 : 25,
                  width: isCurrentTab(index) ? 30 : 25,
                  child: SvgPicture.asset(
                    iconPath,
                    color: isCurrentTab(index) ? Colors.white : CustomColors.darkText,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
