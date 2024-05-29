import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/place_repository.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_state.dart';
import 'package:tripster/presentation/screens/home/detail_place_screen.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/widgets/card/place_card.dart';
import 'package:tripster/presentation/widgets/headers/place_header_widget.dart';
import 'package:tripster/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String? token;
  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showRecommended = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderDecorationWidget(),
            Padding(
              padding: leftBottomPadding,
              child: Text(
                'Places for your travel!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ToggleButtons(
                  isSelected: [!showRecommended, showRecommended],
                  onPressed: (int index) {
                    setState(() {
                      showRecommended = index == 1;
                    });
                  },
                  borderWidth: 0.0,
                  borderRadius: BorderRadius.circular(20),
                  selectedBorderColor: Colors.transparent,
                  selectedColor: Colors.transparent,
                  fillColor: Colors.transparent,
                  color: Colors.transparent,
                  children: <Widget>[
                    Text(
                      'All',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 18,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Recommended',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (showRecommended)
              RecommendedPlaceWidget(token: widget.token)
            else
              PlaceListWidget(token: widget.token),
          ],
        ),
      ),
    );
  }
}

class RecommendedPlaceWidget extends StatelessWidget {
  final String? token;
  RecommendedPlaceWidget({Key? key, this.token});

  final PlaceRepository _placeRepository = PlaceRepository();
  @override
  Widget build(BuildContext context) {
    print('token in home');
    print(token);
    return BlocProvider(
      create: (context) =>
          PlaceCubit(_placeRepository)..getRecommendedPlaces(token),
      child: BlocBuilder<PlaceCubit, PlaceState>(
        builder: (context, state) {
          if (state is PlaceLoaded) {
            final places = state.places;
            return places.isNotEmpty
                ? Column(
                    children: [
                      for (final place in state.places.reversed.toList())
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPlaceScreen(
                                  place: place,
                                ),
                              ),
                            );
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 800),
                            child: PlaceCardWidget(place: place),
                          ),
                        ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text('Please, take quiz for recommendation',
                              style: Theme.of(context).textTheme.bodyMedium),
                          smallSizedBoxHeight,
                          smallSizedBoxHeight,
                          SizedBox(
                            width: 170,
                            child: TextAccentButton(
                              onTap: () {
                                Uri uri = Uri.parse(
                                    'https://tripster-web.vercel.app');
                                _launchInBrowser(uri);
                              },
                              child: Text('Open Website',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          } else if (state is PlaceError) {
            print(state.error);
            return Center(child: Text(state.error));
          } else {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
            ));
          }
        },
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

// !! to-do implement to this page
class PlaceListWidget extends StatelessWidget {
  final String? token;
  PlaceListWidget({Key? key, this.token});

  final PlaceRepository _placeRepository = PlaceRepository();
  @override
  Widget build(BuildContext context) {
    print('token in home');
    print(token);
    return BlocProvider(
      create: (context) => PlaceCubit(_placeRepository)..getPlaces(token),
      child: BlocBuilder<PlaceCubit, PlaceState>(
        builder: (context, state) {
          if (state is PlaceLoaded) {
            return Column(
              children: [
                for (final place in state.places.reversed.toList())
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPlaceScreen(
                            place: place,
                          ),
                        ),
                      );
                    },
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: PlaceCardWidget(place: place),
                    ),
                  ),
              ],
            );
          } else if (state is PlaceError) {
            print(state.error);
            return Center(child: Text(state.error));
          } else {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
            ));
          }
        },
      ),
    );
  }
}
