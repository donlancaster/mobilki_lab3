import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum Mood { focus, relax, anxious, calm }

class HomeController {
  final Rx<Mood?> _mood = Rx<Mood?>(null);

  static final HomeController _singleton = HomeController._();

  HomeController._();

  factory HomeController() => _singleton;

  RxInt currentTab = 0.obs;

  Mood? get mood => _mood.value;

  set mood(Mood? value) =>
      _mood.value = value;


  bool isCurrentTab(int index) => currentTab.value == index;

  // ignore: use_setters_to_change_properties
  void updateCurrentTab(int index) => currentTab.value = index;
}
