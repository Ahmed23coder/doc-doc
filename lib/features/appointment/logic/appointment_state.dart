import 'package:docdoc/models/appointment_model.dart';

abstract class AppointmentsState {}

// --- GENERAL STATES ---
class AppointmentsInitial extends AppointmentsState {}

// --- FETCHING LIST STATES ---
class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentData> appointments;
  AppointmentsLoaded(this.appointments);
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}

// --- BOOKING (STORE) STATES ---
class AppointmentBookingLoading extends AppointmentsState {}

class AppointmentBookingSuccess extends AppointmentsState {}

class AppointmentBookingError extends AppointmentsState {
  final String errorMessage;
  AppointmentBookingError(this.errorMessage);
}