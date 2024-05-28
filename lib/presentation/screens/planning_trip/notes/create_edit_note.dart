import 'package:flutter/material.dart';
import 'package:tripster/domain/models/note_model.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/note_cubit.dart';
import 'package:tripster/presentation/widgets/custom_textfield.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog(
      {super.key,
      required this.day,
      this.notes,
      this.token,
      this.note,
      this.onNoteCreated,
      required this.noteCubit,
      required this.vacationDayId,
      required this.isEdit});

  final VacationDay day;
  final List<Note>? notes;
  final bool isEdit;
  final Note? note;
  final String? token;
  final NoteCubit noteCubit;
  final String vacationDayId;
  final Function()? onNoteCreated;
  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Center(
        child: Text(
          widget.isEdit ? 'Edit note for trip' : 'Add note for trip',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _titleController,
              text: 'Title',
            ),
            CustomTextField(
              maxLines: 3,
              controller: _descriptionController,
              text: 'Description',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            if (widget.isEdit) {
              await widget.noteCubit.updateNote(
                title: _titleController.text,
                description: _descriptionController.text,
                vacationDayId: widget.day.vacationDayId,
                token: widget.token,
                noteId: widget.note!.noteId,
              );
              print(widget.note!.noteId);
            } else {
              await widget.noteCubit.createNote(
                title: _titleController.text,
                description: _descriptionController.text,
                vacationDayId: widget.day.vacationDayId,
                token: widget.token,
              );
            }
          },
          child: Text(
            widget.isEdit ? 'Edit' : 'Add',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
