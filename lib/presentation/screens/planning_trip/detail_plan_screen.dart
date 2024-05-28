import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines/timelines.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/screens/home/maps.dart';
import 'package:tripster/presentation/screens/planning_trip/day_widget.dart';
import 'package:tripster/presentation/screens/planning_trip/widgets/info_trip_widget.dart';
import 'package:tripster/utils/constants.dart';

class DetailPlanTripScreen extends StatefulWidget {
  final Vacation vacation;
  final VacationCubit vacationCubit;
  final String? token;
  const DetailPlanTripScreen(
      {super.key,
      required this.vacation,
      required this.vacationCubit,
      this.token});

  @override
  State<DetailPlanTripScreen> createState() => _DetailPlanTripScreenState();
}

class _DetailPlanTripScreenState extends State<DetailPlanTripScreen> {
  @override
  void initState() {
    widget.vacationCubit
        .fetchVacation(widget.vacation.vacationId, widget.token);
    // widget.vacationCubit
    //     .fetchUserVacationDays(widget.vacation.vacationId, widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.vacation.vacationId);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            backgroundColor: Colors.transparent,
            expandedHeight: 330.0,
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: SizedBox(
                height: 350,
                // child: Maps(
                //   latitude: widget.vacation.countryLat!,
                //   longitude: widget.vacation.countryLon!,
                // ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InformationAboutTripWidget(
              vacation: widget.vacation,
              vacationCubit: widget.vacationCubit,
              token: widget.token,
            ),
          ),
          SliverToBoxAdapter(
            child: VacationDaysWidget(
              vacationId: widget.vacation.vacationId,
              vacation: widget.vacation,
              vacationCubit: widget.vacationCubit,
              token: widget.token,
            ),
          ),
        ],
      ),
    );
  }
}

class VacationDaysWidget extends StatefulWidget {
  final Vacation vacation;
  final String vacationId;
  final VacationCubit vacationCubit;
  final String? token;
  const VacationDaysWidget(
      {super.key,
      required this.vacation,
      required this.vacationCubit,
      required this.token,
      required this.vacationId});
  @override
  State<VacationDaysWidget> createState() => _VacationDaysWidgetState();
}

class _VacationDaysWidgetState extends State<VacationDaysWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VacationCubit(VacationRepository())
        ..fetchUserVacationDays(widget.vacationId, widget.token),
      child: BlocBuilder<VacationCubit, VacationState>(
        builder: (context, state) {
          if (state is VacationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is VacationDaysLoaded) {
            final vacationDays = state.vacationDays;

            return _buildVacationDays(context, vacationDays);
          } else if (state is VacationError) {
            print("Error: ${state.message}");
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return Center(child: Text("No vacation days available"));
          }
        },
      ),
    );
  }

  Widget _buildVacationDays(
      BuildContext context, List<VacationDay> vacationDays) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.shadow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      height: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Text(
              'Travel days',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: smallPadding,
              child: Timeline.tileBuilder(
                padding: EdgeInsets.zero,
                theme: TimelineThemeData(
                  nodePosition: 0.0,
                  connectorTheme: ConnectorThemeData(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  indicatorTheme: IndicatorThemeData(
                    size: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                builder: TimelineTileBuilder.fromStyle(
                  contentsAlign: ContentsAlign.reverse,
                  oppositeContentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: DayWidget(
                        token: widget.token,
                        context: context,
                        day: vacationDays[index],
                        dayNumber: index + 1),
                  ),
                  contentsBuilder: (context, index) => const SizedBox.shrink(),
                  itemCount: vacationDays.length,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
