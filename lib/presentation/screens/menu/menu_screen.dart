import 'package:flutter/material.dart';
import 'package:tripster/presentation/screens/home/home_screen.dart';
import 'package:tripster/presentation/screens/landmark_recognation/landmark_recognation.dart';
import 'package:tripster/presentation/screens/planning_trip/plan_trip_screen.dart';
import 'package:tripster/presentation/screens/profile/my_profile_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late final String? token;

  static List<Widget> tabs = [
    PlanTripScreen(),
    HomeScreen(),
    LandmarkRecognition(),
    ProfileScreen(
      token: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(addListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addListener() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _tabController.animateTo(index);
          });
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Fav',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((Widget tab) {
          if (_selectedIndex == tabs.indexOf(tab)) {
            if (_selectedIndex == 0) {
              return PlanTripScreen(token: token);
            } else if (_selectedIndex == 1) {
              return HomeScreen();
            } else if (_selectedIndex == 2) {
              return LandmarkRecognition();
            } else if (_selectedIndex == 3) {
              return ProfileScreen(token: token);
            }
          }
          return Container();
        }).toList(),
      ),
    );
  }
}
