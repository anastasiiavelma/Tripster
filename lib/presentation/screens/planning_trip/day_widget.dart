import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/note_cubit.dart';
import 'package:tripster/presentation/screens/notes/note_screen.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class DayWidget extends StatefulWidget {
  const DayWidget({
    super.key,
    required this.context,
    required this.day,
    required this.dayNumber,
    this.token,
  });

  final BuildContext context;
  final VacationDay day;
  final int dayNumber;
  final String? token;

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  @override
  Widget build(BuildContext context) {
    final noteCubit = NoteCubit(VacationRepository());
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
                '${LocaleKeys.day.tr()} ${widget.dayNumber}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 30),
              ),
              Text(
                '${DateFormat('dd').format(widget.day.date)} ${DateFormat('MMMM').format(widget.day.date)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.budget_day.tr(),
                  style: Theme.of(context).textTheme.headlineMedium),
              widget.day.budget != null
                  ? Text(
                      '${widget.day.budget}\$',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: kErrorColorLight),
                    )
                  : Text(
                      LocaleKeys.edit_create_note_no_limit.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: kErrorColorLight),
                    ),
            ],
          ),
          smallSizedBoxHeight,
          Row(
            children: [
              Icon(Icons.airport_shuttle),
              smallerSizedBoxWidth,
              Text(
                LocaleKeys.places.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 21,
                    ),
              ),
            ],
          ),
          smallerSizedBoxHeight,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.day.places!.isNotEmpty
                ? widget.day.places!
                    .map((place) => Text('• ${place}',
                        style: Theme.of(context).textTheme.headlineMedium))
                    .toList()
                : [
                    Text(
                      LocaleKeys.edit_create_note_no_places_yet.tr(),
                    )
                  ],
          ),
          smallSizedBoxHeight,
          BlocProvider(
            create: (context) => noteCubit
              ..fetchNotesByVacationDayId(
                  widget.day.vacationDayId, widget.token),
            child: BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                if (state is NoteLoading) {
                  return SizedBox(
                      height: 10,
                      width: 10,
                      child: Center(
                          child: getCircularProgressIndicator2(context)));
                }
                if (state is NotesLoaded) {
                  final notes = state.notes;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallSizedBoxHeight,
                      TextAccentButton(
                          height: 35,
                          onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return NoteInTripDaysWidget(
                                  day: widget.day,
                                  notes: notes,
                                  token: widget.token,
                                  noteCubit: noteCubit,
                                );
                              }),
                          child: Text(
                            textAlign: TextAlign.start,
                            LocaleKeys.view_plan.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: kPrimaryColor),
                          )),
                    ],
                  );
                } else if (state is NoteError) {
                  return Text('Failed to load notes: ${state.message}');
                } else {
                  return Container();
                }
              },
            ),
          ),
          smallSizedBoxHeight,
        ],
      ),
    );
  }
}
