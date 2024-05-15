import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/intl.dart';

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
                height: 200,
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
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(45),
      ),
      height: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Text(
              'Travel days',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 24.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredVacationDays.length,
              itemBuilder: (context, index) {
                print(filteredVacationDays.length);
                return _buildDayCard(context, filteredVacationDays[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, VacationDay day) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${day.vacationDayId}',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 25),
            ),
            smallSizedBoxHeight,
            Text(
              'Date:  ${DateFormat('dd').format(day.createdAt)} ${DateFormat('MMMM').format(day.createdAt)}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            smallSizedBoxHeight,
            Text(
              'Places to Visit:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            smallSizedBoxHeight,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: day.place!.map((place) => Text('• $place')).toList(),
            ),
            smallSizedBoxHeight,
            smallSizedBoxHeight,
            smallSizedBoxHeight,
            Text(
              'Budget for the day: \$${day.budget.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            smallSizedBoxHeight,
            Text(
              'Notes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            smallSizedBoxHeight,
            TextField(
              decoration: InputDecoration(
                labelText: '  Add Note',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                ),
              ),
            ),
            smallSizedBoxHeight,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: day.notes
                  .map((note) => Text('• ${note.title}: ${note.description}'))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class InformationAboutTripWidget extends StatelessWidget {
  final Vacation vacation;
  const InformationAboutTripWidget({super.key, required this.vacation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: smallPadding,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.center,
                vacation.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 24.0),
              ),
              smallSizedBoxHeight,
              Text('Location',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 15)),
              smallSizedBoxHeight,
              Row(
                children: [
                  Icon(Icons.location_on,
                      color: Theme.of(context).colorScheme.onBackground),
                  Text(
                    vacation.location,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              smallSizedBoxHeight,
              Text('Information about trip',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 15,
                      )),
              smallSizedBoxHeight,
              Row(
                children: [
                  Icon(Icons.date_range_outlined,
                      color: Theme.of(context).colorScheme.onBackground),
                  smallerSizedBoxWidth,
                  Text(
                    vacation.dateStart.toString().substring(0, 10),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ' — ',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    vacation.dateEnd.toString().substring(0, 10),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              smallSizedBoxHeight,
              Text('Budget in this trip',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 15,
                      )),
              smallSizedBoxHeight,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.money_outlined,
                      color: Theme.of(context).colorScheme.onError),
                  smallerSizedBoxWidth,
                  Text(
                    '${vacation.fullBudget.toString()} Dollars',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onError),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
