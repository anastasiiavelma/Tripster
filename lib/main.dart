import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/place_repository.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/providers/theme_providers.dart';
import 'package:tripster/presentation/screens/auth/sign_in_screen.dart';
import 'package:tripster/presentation/screens/auth/sign_up_screen.dart';
import 'package:tripster/presentation/screens/home/home_screen.dart';
import 'package:tripster/presentation/screens/landmark_recognation/landmark_recognation.dart';
import 'package:tripster/presentation/screens/menu/menu_screen.dart';
import 'package:tripster/presentation/screens/profile/my_profile_screen.dart';
import 'package:tripster/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print('user token in main $token');
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
    print('token in main build ${widget.token}');
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => VacationCubit(VacationRepository()),
        ),
        BlocProvider(
          create: (context) => PlaceCubit(PlaceRepository()),
        ),
        ChangeNotifierProvider(create: (context) => themeChangeProvider),
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: basicTheme(themeChangeProvider.darkTheme, context),
          title: 'Tripster',
          initialRoute: widget.token == null ? '/signIn' : '/menu',
          routes: {
            '/profile': (context) => ProfileScreen(
                  token: widget.token,
                ),
            '/menu': (context) => MenuScreen(
                  token: widget.token,
                ),
            '/home': (context) => const HomeScreen(),
            '/landmark-recognition': (context) => LandmarkRecognition(),
            '/signIn': (context) => const SignInScreen(),
            '/signUp': (context) => const SignUpScreen(),
          },
        );
      }),
    );
  }
}
