part of 'vacation_cubit.dart';

abstract class VacationState {}

class VacationInitial extends VacationState {}

class VacationLoading extends VacationState {}

class VacationsLoaded extends VacationState {
  final List<Vacation> vacations;

  VacationsLoaded(this.vacations);
}

class VacationLoaded extends VacationState {
  final Vacation vacation;

  VacationLoaded(this.vacation);
}

class VacationDaysLoaded extends VacationState {
  final List<VacationDay> vacationDays;

  VacationDaysLoaded(this.vacationDays);
}

class VacationDayLoaded extends VacationState {
  final VacationDay vacationDay;

  VacationDayLoaded(this.vacationDay);
}

class NoteCreated extends VacationState {
  final Note note;

  NoteCreated(this.note);
}

class NoteDeleted extends VacationState {}

class VacationError extends VacationState {
  final String message;

  VacationError(this.message);
}
