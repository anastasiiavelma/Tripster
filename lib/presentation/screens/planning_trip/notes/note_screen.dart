import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/presentation/screens/planning_trip/notes/create_edit_note.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';

class NoteInTripDaysWidget extends StatelessWidget {
  const NoteInTripDaysWidget({
    super.key,
    required this.day,
  });

  final VacationDay day;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.shadow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      height: 700,
      child: Padding(
        padding: smallPadding,
        child: Column(
          children: [
            Center(
              child: Text(
                'My notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
            smallSizedBoxHeight,
            Container(
              height: 550,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: day.notes!.length,
                itemBuilder: (context, index) {
                  final note = day.notes![index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Container(
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
                      child: Padding(
                        padding: midPadding,
                        child: Row(
                          children: [
                            SizedBox(
                                height: 25,
                                width: 25,
                                child: Image.asset('assets/images/pen.png')),
                            smallSizedBoxWidth,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${note.title}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            color: kBackgroundColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${note.description}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: kBackgroundColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            smallSizedBoxHeight,
            smallSizedBoxHeight,
            TextAccentButton(
              color: Theme.of(context).colorScheme.onBackground,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddNoteDialog(day: day);
                  },
                );
              },
              child: Text(
                'Add note',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
