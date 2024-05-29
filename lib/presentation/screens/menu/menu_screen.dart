import 'package:flutter/material.dart';
import 'package:tripster/presentation/map_marker/custom_map_marker.dart';
import 'package:tripster/presentation/screens/home/home_screen.dart';
import 'package:tripster/presentation/screens/landmark_recognation/landmark_recognation.dart';
import 'package:tripster/presentation/screens/planning_trip/plan_trip_screen.dart';
import 'package:tripster/presentation/screens/profile/my_profile_screen.dart';

class MenuScreen extends StatefulWidget {
  final String? token;
  MenuScreen({Key? key, this.token}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(addListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(addListener);
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

    tabs = [
      HomeScreen(token: token == null ? widget.token : token),
      PlanTripScreen(token: token == null ? widget.token : token),
      LandmarkRecognition(),
      ProfileScreen(token: token == null ? widget.token : token),
      FullScreenMap(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        selectedItemColor: Theme.of(context).colorScheme.shadow,
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
              Icons.beach_access_outlined,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Fav',
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
              Icons.map,
              color: Theme.of(context).colorScheme.background,
              size: Theme.of(context).iconTheme.size,
            ),
            label: 'Map',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((Widget tab) {
          if (_selectedIndex == tabs.indexOf(tab)) {
            if (_selectedIndex == 0) {
              return HomeScreen(token: token == null ? widget.token : token);
            } else if (_selectedIndex == 1) {
              return PlanTripScreen(
                  token: token == null ? widget.token : token);
            } else if (_selectedIndex == 2) {
              return LandmarkRecognition();
            } else if (_selectedIndex == 3) {
              return ProfileScreen(token: token == null ? widget.token : token);
            } else if (_selectedIndex == 4) {
              return FullScreenMap();
            }
          }
          return Container();
        }).toList(),
      ),
    );
  }
}
