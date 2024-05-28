part of 'note_cubit.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final Note note;

  NoteLoaded(this.note);
}

class NotesLoaded extends NoteState {
  final List<Note> notes;

  NotesLoaded(this.notes);
}

class NoteCreated extends NoteState {
  final Note note;

  NoteCreated(this.note);
}

class NoteDeleted extends NoteState {}

class NoteError extends NoteState {
  final String message;

  NoteError(this.message);
}
