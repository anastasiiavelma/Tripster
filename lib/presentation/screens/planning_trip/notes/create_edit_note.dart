import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/presentation/widgets/custom_textfield.dart';
import 'package:tripster/utils/constants.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key, required this.day});

  final VacationDay day;

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      title: Center(
        child: Text(
          'Add note for trip',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      content: Column(
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
          onPressed: () {
            // final newNote = Note(
            //   title: _titleController.text,
            //   description: _descriptionController.text,
            // );
            // setState(() {
            //   widget.day.notes.add(newNote);
            // });
            // Navigator.of(context).pop();
          },
          child: Text(
            'Add',
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
