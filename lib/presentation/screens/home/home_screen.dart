import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tripster/presentation/widgets/headers/place_header_widget.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

import 'place_list_widget.dart';
import 'recommended_place_widget.dart';

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
                LocaleKeys.places_for_your_travel.tr(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 23,
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
                      LocaleKeys.all.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 18,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        LocaleKeys.recommendation.tr(),
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
