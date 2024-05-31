import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/domain/models/note_model.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/note_cubit.dart';
import 'package:tripster/presentation/screens/planning_trip/notes/create_edit_note.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class NoteInTripDaysWidget extends StatefulWidget {
  const NoteInTripDaysWidget({
    super.key,
    required this.day,
    required this.notes,
    required this.noteCubit,
    required this.token,
  });

  final VacationDay day;
  final List<Note> notes;
  final String? token;
  final NoteCubit noteCubit;

  @override
  State<NoteInTripDaysWidget> createState() => _NoteInTripDaysWidgetState();
}

class _NoteInTripDaysWidgetState extends State<NoteInTripDaysWidget> {
  @override
  void initState() {
    super.initState();
    widget.noteCubit
        .fetchNotesByVacationDayId(widget.day.vacationDayId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteState>(
      bloc: widget.noteCubit,
      listener: (context, state) {
        if (state is NoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        List<Note> notes = [];
        bool isLoading = false;

        if (state is NoteLoading) {
          isLoading = true;
        } else if (state is NotesLoaded) {
          notes = state.notes;
        }

        return _buildNotesList(notes, isLoading);
      },
    );
  }

  Widget _buildNotesList(List<Note> notes, bool isLoading) {
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
              child: Text(LocaleKeys.plan_day.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            if (isLoading)
              SizedBox(
                height: 550,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: getCircularProgressIndicator(context),
                    ),
                  ],
                ),
              ),
            smallSizedBoxHeight,
            if (!isLoading)
              Container(
                height: 550,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          Builder(builder: (sContext) {
                            return Expanded(
                                child: GestureDetector(
                              onTap: () => deleteNote(context, note),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 1),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 20 * 4,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              ),
                            ));
                          }),
                          Builder(builder: (sContext) {
                            return Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 1),
                              child: GestureDetector(
                                onTap: () => {
                                  updateNote(context, note),
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 20 * 4,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Icon(
                                      Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    )),
                              ),
                            ));
                          }),
                        ],
                      ),
                      key: UniqueKey(),
                      direction: Axis.horizontal,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 3),
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
                                    child:
                                        Image.asset('assets/images/pen.png')),
                                smallSizedBoxWidth,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${note.title}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      smallerSizedBoxHeight,
                                      Text('${note.description}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
              onTap: () async {
                await showDialog<Note>(
                  context: context,
                  builder: (BuildContext context) {
                    return AddNoteDialog(
                      isEdit: false,
                      day: widget.day,
                      vacationDayId: widget.day.vacationDayId,
                      token: widget.token,
                      noteCubit: widget.noteCubit,
                    );
                  },
                );
              },
              child: Text(
                LocaleKeys.add_note_to_plane.tr(),
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

  void deleteNote(BuildContext context, Note note) {
    widget.noteCubit.deleteNote(
      noteId: note.noteId,
      vacationDayId: widget.day.vacationDayId,
      token: widget.token,
    );
  }

  void updateNote(BuildContext context, Note note) async {
    await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return AddNoteDialog(
          isEdit: true,
          day: widget.day,
          note: note,
          vacationDayId: widget.day.vacationDayId,
          token: widget.token,
          noteCubit: widget.noteCubit,
        );
      },
    );
  }
}
