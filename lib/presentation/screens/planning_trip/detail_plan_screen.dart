import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/screens/planning_trip/trip_days_card.dart';
import 'package:tripster/presentation/screens/planning_trip/widgets/info_trip_widget.dart';
import 'package:tripster/utils/constants.dart';
import 'package:timelines/timelines.dart';

class DetailPlanTripScreen extends StatelessWidget {
  final Vacation vacation;
  const DetailPlanTripScreen({super.key, required this.vacation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            backgroundColor: Colors.transparent,
            expandedHeight: 200.0,
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: Image.network(
                height: 250,
                'https://images.unsplash.com/photo-1569622296640-38737c1d82de?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InformationAboutTripWidget(
              vacation: vacation,
            ),
          ),
          SliverToBoxAdapter(
            child: VacationDaysWidget(vacationId: vacation.vacationId),
          ),
        ],
      ),
    );
  }
}

class VacationDaysWidget extends StatefulWidget {
  final String vacationId;

  const VacationDaysWidget({
    Key? key,
    required this.vacationId,
  }) : super(key: key);

  @override
  State<VacationDaysWidget> createState() => _VacationDaysWidgetState();
}

class _VacationDaysWidgetState extends State<VacationDaysWidget> {
  @override
  Widget build(BuildContext context) {
    List<VacationDay> filteredVacationDays = vacationDays
        .where((day) => day.vacationId == widget.vacationId)
        .toList();
    print(vacationDays.length);
    print(filteredVacationDays.length);
    return Container(
      decoration: BoxDecoration(
        color: kAccentColor,
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
                  .displayLarge
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
                    child: PlanDayWidget(
                        context: context,
                        day: filteredVacationDays[index],
                        dayNumber: index + 1),
                  ),
                  contentsBuilder: (context, index) => const SizedBox.shrink(),
                  itemCount: filteredVacationDays.length,
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
