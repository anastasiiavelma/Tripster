import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/note_model.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
part 'vacation_state.dart';

class VacationCubit extends Cubit<VacationState> {
  final VacationRepository vacationRepository;

  VacationCubit(this.vacationRepository) : super(VacationInitial());

  Future<void> fetchUserVacations(String? token) async {
    try {
      emit(VacationLoading());
      final vacations = await vacationRepository.getUserVacations(token);
      if (!isClosed) {
        if (vacations != null) {
          emit(VacationsLoaded(vacations));
        } else {
          emit(VacationError("Unauthorized access"));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(VacationError(e.toString()));
      }
    }
  }

  Future<void> fetchVacation(String vacationId, String? token) async {
    try {
      emit(VacationLoading());
      final vacation = await vacationRepository.getVacation(vacationId, token);
      emit(VacationLoaded(vacation!));
    } catch (e) {
      emit(VacationError(e.toString()));
    }
  }

  Future<void> fetchUserVacationDays(String vacationId, String? token) async {
    try {
      emit(VacationLoading());
      final vacationDays =
          await vacationRepository.getUserVacationDays(vacationId, token);
      if (vacationDays != null) {
        emit(VacationDaysLoaded(vacationDays));
      } else {
        emit(VacationError("Unauthorized access"));
      }
    } catch (e) {
      emit(VacationError(e.toString()));
    }
  }

  Future<void> fetchVacationDay(String vacationDayId, String? token) async {
    try {
      emit(VacationLoading());
      final vacationDay =
          await vacationRepository.getVacationDay(vacationDayId, token);
      emit(VacationDayLoaded(vacationDay!));
    } catch (e) {
      emit(VacationError(e.toString()));
    }
  }
}
