import 'package:docdoc/models/appointment_model.dart';

class AppointmentsStore {
  // A global list to hold your appointments in memory
  static final List<AppointmentData> _appointments = [];

  static List<AppointmentData> get appointments => _appointments;

  static void addAppointment(AppointmentData appointment) {
    _appointments.add(appointment);
  }

  // Update an existing appointment (for rescheduling)
  static void updateAppointment(int id, DateTime newDate, String newTime) {
    final index = _appointments.indexWhere((element) => element.id == id);
    if (index != -1) {
      // Create a copy with new time (Assuming you have a way to copy, or we create a new one)
      // Since AppointmentData fields are final, we replace the item
      final old = _appointments[index];
      _appointments[index] = AppointmentData(
        id: old.id,
        doctor: old.doctor,
        appointmentTime: newTime, // Update Time
        appointmentEndTime: old.appointmentEndTime,
        status: old.status,
        appointmentPrice: old.appointmentPrice,
      );
    }
  }
}