import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/note_model.dart';
import 'package:uuid/uuid.dart';
part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final VacationRepository vacationRepository;
  final Uuid uuid = Uuid();
  NoteCubit(this.vacationRepository) : super(NoteInitial());

  Future<void> fetchNoteById(String noteId, String? token) async {
    try {
      emit(NoteLoading());
      final note = await vacationRepository.getNoteById(noteId, token);
      emit(NoteLoaded(note!));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> fetchNotesByVacationDayId(
      String vacationDayId, String? token) async {
    try {
      if (!this.isClosed) {
        emit(NoteLoading());
        final notes = await vacationRepository.getNotesByVacationDayId(
            vacationDayId, token);

        if (!this.isClosed) {
          emit(NotesLoaded(notes));
        }
      }
    } catch (e) {
      if (!this.isClosed) {
        emit(NoteError(e.toString()));
      }
    }
  }

  Future<void> createNote({
    required String title,
    required String description,
    required String vacationDayId,
    required String? token,
  }) async {
    try {
      final note = await vacationRepository.createNote(
        title: title,
        description: description,
        vacationDayId: vacationDayId,
        token: token,
      );
      emit(NoteLoading());
      // emit(NoteCreated(note));
      if (!this.isClosed) {
        final updatedNotes = await vacationRepository.getNotesByVacationDayId(
            vacationDayId, token);
        emit(NotesLoaded(updatedNotes));
      }
    } catch (e) {
      if (!isClosed) {
        emit(NoteError(e.toString()));
      }
    }
  }

  Future<void> updateNote({
    required String title,
    required String description,
    required String vacationDayId,
    required String? token,
    required String noteId,
  }) async {
    try {
      await vacationRepository.updateNote(
        title: title,
        description: description,
        vacationDayId: vacationDayId,
        token: token,
        noteId: noteId,
      );
      emit(NoteLoading());
      if (!this.isClosed) {
        final updatedNotes = await vacationRepository.getNotesByVacationDayId(
            vacationDayId, token);
        emit(NotesLoaded(updatedNotes));
      }
    } catch (e) {
      if (!isClosed) {
        emit(NoteError(e.toString()));
      }
    }
  }

  Future<void> deleteNote({
    required String noteId,
    required String vacationDayId,
    required String? token,
  }) async {
    try {
      await vacationRepository.deleteNote(
        noteId: noteId,
        vacationDayId: vacationDayId,
        token: token,
      );

      emit(NoteLoading());
      if (!this.isClosed) {
        final updatedNotes = await vacationRepository.getNotesByVacationDayId(
            vacationDayId, token);
        emit(NotesLoaded(updatedNotes));
      }
    } catch (e) {
      emit(NoteError('Something went wrong'));
    }
  }
}
