import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/place_repository.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_state.dart';
import 'package:tripster/presentation/screens/home/detail_place_screen.dart';
import 'package:tripster/presentation/widgets/card/place_card.dart';
import 'package:tripster/utils/constants.dart';

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
