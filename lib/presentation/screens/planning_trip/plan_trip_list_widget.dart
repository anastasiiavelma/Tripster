import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/screens/planning_trip/card_widget.dart';
import 'package:tripster/presentation/screens/planning_trip/detail_plan_screen.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanTripListWidget extends StatefulWidget {
  final String? token;
  final bool sortByNewest;
  final String searchQuery;
  final VacationCubit vacationCubit;
  const PlanTripListWidget({
    super.key,
    this.token,
    required this.vacationCubit,
    required this.sortByNewest,
    required this.searchQuery,
  });

  @override
  State<PlanTripListWidget> createState() => _PlanTripListWidgetState();
}

class _PlanTripListWidgetState extends State<PlanTripListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VacationCubit, VacationState>(
      builder: (context, state) {
        if (state is VacationLoading) {
          return SliverToBoxAdapter(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
            )),
          );
        } else if (state is VacationsLoaded) {
          final vacations = state.vacations;
          if (widget.sortByNewest) {
            vacations.sort((a, b) => b.startDate.compareTo(a.startDate));
          } else {
            vacations.sort((a, b) => a.startDate.compareTo(b.startDate));
          }
          final filteredVacations = vacations
              .where((vacation) => vacation.countryName
                  .toLowerCase()
                  .contains(widget.searchQuery.toLowerCase()))
              .toList();
          if (filteredVacations.isEmpty) {
            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(LocaleKeys.edit_create_note_vacations_list_empty.tr(),
                      style: Theme.of(context).textTheme.bodyMedium),
                  smallSizedBoxHeight,
                  smallSizedBoxHeight,
                  SizedBox(
                    width: 150,
                    child: TextAccentButton(
                      height: 40,
                      onTap: () {
                        Uri uri = Uri.parse('https://tripster-web.vercel.app');
                        _launchInBrowser(uri);
                      },
                      child: Text(LocaleKeys.open_website.tr(),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                ],
              ),
            );
          }
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (filteredVacations.isNotEmpty &&
                    index < filteredVacations.length) {
                  final vacation = filteredVacations[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                                value: widget.vacationCubit,
                                child: DetailPlanTripScreen(
                                  vacation: vacation,
                                  token: widget.token,
                                  vacationCubit: widget.vacationCubit,
                                ),
                              )));
                      widget.vacationCubit.fetchUserVacations(widget.token);
                    },
                    child: FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: CardWidget(vacation: vacation)),
                  );
                }
                return null;
              },
              childCount: vacations.length,
            ),
          );
        } else if (state is VacationError) {
          return SliverToBoxAdapter(
            child: Center(
                child: Text("Error: ${state.message}, ",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: kAccentColor))),
          );
        } else {
          return SliverToBoxAdapter(
            child: Center(
                child: Text(LocaleKeys.collection_photo_no_vacations_found.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: kAccentColor))),
          );
        }
      },
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
