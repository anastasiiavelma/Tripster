import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/place_repository.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_state.dart';
import 'package:tripster/presentation/screens/home/detail_place_screen.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/widgets/card/place_card.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

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
                          Text(LocaleKeys.quiz_recommendation.tr(),
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
                              child: Text(LocaleKeys.open_website.tr(),
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
