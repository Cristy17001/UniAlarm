import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:uni_alarm/Services/notification_service.dart';

import 'LoginPage.dart';
import 'ProfilePage.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'AlarmsPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      );
    },
    home: const SignIn(),
      debugShowCheckedModeBanner: false,
  )
  );
}

class currentPage extends StatefulWidget {
  const currentPage({Key? key}) : super(key: key);

  @override
  State<currentPage> createState() => _currentPageState();
}

class _currentPageState extends State<currentPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    colorNotifier.addListener(_onColorChange);
  }

  @override
  void dispose() {
    super.dispose();
    colorNotifier.removeListener(_onColorChange);
  }

  void _onColorChange() {
    setState(() {});
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: colorNotifier,
        builder: (BuildContext context, bool value, Widget? child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,

              children: const [
                KeyedSubtree(
                  key: ValueKey('home_page'),
                  child: Home(),
                ),
                KeyedSubtree(
                  key: ValueKey('alarms_page'),
                  child: Alarms(),
                ),
                KeyedSubtree(
                  key: ValueKey('profile_page'),
                  child: Profile(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentPageIndex,
              onTap: (index) {
                setState(() {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                });
              },
              backgroundColor: isDark ? darkNavBar : lightMainCards,
              unselectedItemColor: Colors.red,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              iconSize: 30,
              items: [
                BottomNavigationBarItem(
                  icon: Image(image: themeImage("home.png"), width: 30),
                  label: "Home",
                  activeIcon: ColorFiltered(
                    colorFilter: ColorFilter.mode(isDark?darkHighlights:lightText, BlendMode.srcIn),
                    child: Image(image: themeImage("home.png"), width: 30),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image(image: themeImage("alarms.png"), width: 30),
                  label: "Alarms",
                  activeIcon: ColorFiltered(
                    colorFilter: ColorFilter.mode(isDark?darkHighlights:lightText, BlendMode.srcIn),
                    child: Image(image: themeImage("alarms.png"), width: 30),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image(image: themeImage("profile.png"), width: 30),
                  label: "Profile",
                  activeIcon: ColorFiltered(
                    colorFilter: ColorFilter.mode(isDark?darkHighlights:lightText, BlendMode.srcIn),
                    child: Image(image: themeImage("profile.png"), width: 30),
                  ),
                )
              ],
            ),
          );
        });
  }}
