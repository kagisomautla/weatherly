import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/colors.dart';
import 'package:weatherly/models/Navigator.dart';
import 'package:weatherly/screens/favourites_screen.dart';
import 'package:weatherly/screens/home_screen.dart';
import 'package:weatherly/screens/google_map.dart';
import 'package:weatherly/services/internet_service.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/snackbar.dart';

class NavigatorScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorScreen({Key? key, required this.navigatorKey}) : super(key: key);
  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  List<NavigatorModel> pages = [];
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  bool hasOnboarded = false;
  InternetService internetService = InternetService.instance;

  @override
  initState() {
    internetService.initialConnection(context: context);
    pages = [
    NavigatorModel(
      label: 'Home',
      icon: FontAwesomeIcons.house,
      page: HomeScreen(),
    ),
    NavigatorModel(
      label: 'Map',
      icon: FontAwesomeIcons.map,
        page: GoogleMapScreen(navigatorKey: widget.navigatorKey),
    ),
    NavigatorModel(
      label: 'Favourites',
      icon: FontAwesomeIcons.solidHeart,
      page: FavouritesScreen(),
    ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    internetService.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold();
    final themeVM = Provider.of<ThemeViewModel>(context);
    WeatherViewModel weatherViewModel = Provider.of<WeatherViewModel>(context);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: pages.map((p) => p.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        backgroundColor: themeVM.color,
        elevation: 2,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        selectedIconTheme: IconThemeData(
          color: kSunnyBackgroundColor,
          fill: 1,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.white,
          fill: 1,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
        items: pages.map((p) {
          return BottomNavigationBarItem(
            icon: Icon(p.icon, size: 20),
            label: p.label,
            activeIcon: Container(
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              padding: EdgeInsets.all(12),
              child: Center(
                child: Icon(
                  p.icon,
                  size: 18,
                  color: themeVM.color,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
