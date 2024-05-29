import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/screens/home/maps.dart';
import 'package:tripster/presentation/screens/planning_trip/detail_plan_screen.dart';
import 'package:tripster/presentation/screens/planning_trip/widgets/custom_search_widget.dart';
import 'package:tripster/presentation/widgets/buttons/change_theme_button.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanTripScreen extends StatefulWidget {
  final String? token;
  const PlanTripScreen({super.key, this.token});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  late final VacationCubit vacationCubit;
  final VacationRepository _vacationRepository = VacationRepository();
  bool sortByNewest = false;
  String searchQuery = '';
  @override
  void initState() {
    vacationCubit = VacationCubit(_vacationRepository);
    vacationCubit.fetchUserVacations(widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.11,
            floating: true,
            pinned: false,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(
                  left: 0,
                  top: constraints.maxHeight - 70,
                  bottom: 10,
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // !!! to-do: delete
                    ThemeButton(),
                    Text(
                      'My trips',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.bold),
                    ),
                    smallSizedBoxHeight,
                  ],
                ),
                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                  child: Container(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: smallSizedBoxHeight,
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.import_export,
                    size: 30,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    setState(() {
                      sortByNewest = !sortByNewest;
                    });
                  },
                ),
                Expanded(
                  child: CustomSearchTextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: smallerPadding,
            sliver: BlocProvider(
              create: (context) => vacationCubit,
              child: PlanTripListWidget(
                token: widget.token,
                vacationCubit: vacationCubit,
                sortByNewest: sortByNewest,
                searchQuery: searchQuery,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                  Text("Vacations list is empty. Create vacation!",
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
                      child: Text('Open Website',
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
                child: Text("No vacations available",
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

class CardWidget extends StatelessWidget {
  final Vacation vacation;
  const CardWidget({
    super.key,
    required this.vacation,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    return Padding(
      padding: smallerPadding,
      child: Card(
        color: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            alignment: Alignment.topCenter,
            width: 120,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Expanded(
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(8.0),
                //     child: Maps(
                //       latitude: vacation.countryLat!,
                //       longitude: vacation.countryLon!,
                //     ),
                //   ),
                // ),
                smallSizedBoxHeight,
                Text(
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  vacation.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.background,
                      ),
                ),
                smallSizedBoxHeight,
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    smallerSizedBoxWidth,
                    Text(
                      vacation.countryName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                smallSizedBoxHeight,
                Row(
                  children: [
                    Icon(Icons.date_range_outlined,
                        color: Theme.of(context).colorScheme.background),
                    smallerSizedBoxWidth,
                    Text(
                        '${yearFormat.format(vacation.endDate)}, '
                        '${dayMonthFormat.format(vacation.startDate)} - ${dayMonthFormat.format(vacation.endDate)}',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                smallSizedBoxHeight,
                vacation.fullBudget != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.money_outlined, color: Color(0xFF6e191d)),
                          smallerSizedBoxWidth,
                          Text(
                            '${vacation.fullBudget.toString()} Dollars',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Color(0xFF6e191d)),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 1,
                      ),
                smallSizedBoxHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
