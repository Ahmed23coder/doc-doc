import 'package:docdoc/features/appointment/data/repository/appointment_repository.dart';
import 'package:docdoc/features/appointment/logic/appointment_event.dart';
import 'package:docdoc/features/appointment/logic/appointment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentRepository _repository;

  AppointmentsBloc(this._repository) : super(AppointmentsInitial()) {

    // 1. Handle Getting the List
    on<GetAppointmentsEvent>((event, emit) async {
      emit(AppointmentsLoading());
      try {
        final appointments = await _repository.getAppointmentData();
        emit(AppointmentsLoaded(appointments));
      } catch (e) {
        emit(AppointmentsError("Failed to fetch appointments: ${e.toString()}"));
      }
    });

    // 2. Handle Booking an Appointment
    on<BookAppointmentEvent>((event, emit) async {
      emit(AppointmentBookingLoading());
      try {
        await _repository.storeAppointment(
          doctorId: event.doctorId,
          startTime: event.startTime,
          notes: event.notes,
        );
        emit(AppointmentBookingSuccess());

        add(GetAppointmentsEvent());

      } catch (e) {
        emit(AppointmentBookingError(e.toString()));
      }
    });
  }
}