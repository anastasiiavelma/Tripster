import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:tripster/data/cubits/auth_cubit/auth_cubit.dart';
import 'package:tripster/data/cubits/auth_cubit/auth_state.dart';
import 'package:tripster/data/providers/theme_providers.dart';
import 'package:tripster/presentation/screens/auth/sign_in_screen.dart';
import 'package:tripster/presentation/screens/auth/sign_up_screen.dart';
import 'package:tripster/presentation/screens/home/home_screen.dart';
import 'package:tripster/presentation/screens/landmark_recognation/landmark_recognation.dart';
import 'package:tripster/presentation/screens/menu/menu_screen.dart';
import 'package:tripster/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(
    MyApp(token: token),
  );
}

class MyApp extends StatefulWidget {
  final String? token;
  MyApp({Key? key, this.token});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeChangeProvider),
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return MaterialApp(
          theme: basicTheme(themeChangeProvider.darkTheme, context),
          title: 'Tripster',
          initialRoute: widget.token == null ? '/signIn' : '/menu',
          routes: {
            '/': (context) => const MenuScreen(),
            '/menu': (context) => const MenuScreen(),
            '/home': (context) => const HomeScreen(),
            '/landmark-recognition': (context) => const LandmarkRecognition(),
            '/signIn': (context) => const SignInScreen(),
            '/signUp': (context) => const SignUpScreen(),
          },
        );
      }),
    );
  }
}
