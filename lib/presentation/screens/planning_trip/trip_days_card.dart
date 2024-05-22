import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/presentation/screens/planning_trip/notes/note_screen.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/intl.dart';

class PlanDayWidget extends StatelessWidget {
  const PlanDayWidget({
    super.key,
    required this.context,
    required this.day,
    required this.dayNumber,
  });

  final BuildContext context;
  final VacationDay day;
  final int dayNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day $dayNumber',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: kBackgroundColor),
              ),
              Text(
                '${DateFormat('dd').format(day.createdAt)} ${DateFormat('MMMM').format(day.createdAt)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: kBackgroundColor),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget day:',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: kBackgroundColor),
              ),
              Text(
                '${day.budget.toStringAsFixed(0)}\$',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: kErrorColorLight),
              ),
            ],
          ),
          smallSizedBoxHeight,
          Text(
            'Places:',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: kBackgroundColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: day.place!
                .map((place) => Text(
                      '• ${place.name}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: kBackgroundColor),
                    ))
                .toList(),
          ),
          smallSizedBoxHeight,
          Text(
            'Notes:',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: kBackgroundColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: day.notes
                .take(2)
                .map((note) => Text(
                      maxLines: 2,
                      '• ${note.title}: \n    ${note.description}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: kBackgroundColor),
                    ))
                .toList(),
          ),
          smallSizedBoxHeight,
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 27.0),
              ),
              onPressed: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return NoteInTripDaysWidget(
                      day: day,
                    );
                  }),
              child: Text(
                'Edit notes',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: kPrimaryColor),
              )),
        ],
      ),
    );
  }
}
