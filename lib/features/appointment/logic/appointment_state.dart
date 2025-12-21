import 'package:docdoc/models/appointment_model.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentData> appointments;
  AppointmentsLoaded(this.appointments);
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}

class AppointmentBookingLoading extends AppointmentsState {}

class AppointmentBookingSuccess extends AppointmentsState {}

class AppointmentBookingError extends AppointmentsState {
  final String errorMessage;
  AppointmentBookingError(this.errorMessage);
}

