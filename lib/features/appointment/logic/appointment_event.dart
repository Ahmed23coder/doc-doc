abstract class AppointmentsEvent {}

class GetAppointmentsEvent extends AppointmentsEvent {}


class BookAppointmentEvent extends AppointmentsEvent {
  final int doctorId;
  final String startTime;
  final String? notes;

  BookAppointmentEvent({
    required this.doctorId,
    required this.startTime,
    this.notes,
  });
}
