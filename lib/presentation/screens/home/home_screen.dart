import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/place_repository.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_state.dart';
import 'package:tripster/presentation/screens/home/detail_place_screen.dart';
import 'package:tripster/presentation/widgets/card/place_card.dart';
import 'package:tripster/presentation/widgets/headers/place_header_widget.dart';
import 'package:tripster/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                'Recommended places',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
            PlaceListWidget(),
          ],
        ),
      ),
    );
  }
}

class PlaceListWidget extends StatelessWidget {
  final PlaceRepository _placeRepository = PlaceRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceCubit(_placeRepository)..getPlaces(),
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
