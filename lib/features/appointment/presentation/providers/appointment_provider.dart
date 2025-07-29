import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/appointment_service.dart';
import '../../data/appointment_model.dart';

// Appointment service provider
final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService();
});

// Recent appointments provider (for home page)
final recentAppointmentsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getRecentAppointments();

  return result.fold(
        (failure) => throw Exception(failure.message),
        (appointments) => appointments,
  );
});

// All appointments provider (for appointment list page)
final appointmentsProvider = FutureProvider.family<List<AppointmentModel>, String?>((ref, category) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getAppointments(category: category);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (appointments) => appointments,
  );
});

// Appointment by ID provider
final appointmentByIdProvider = FutureProvider.family<AppointmentModel, String>((ref, id) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getAppointmentById(id);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (appointment) => appointment,
  );
});

// User bookings provider
final userBookingsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getUserBookings(userId);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (bookings) => bookings,
  );
});

// Book appointment provider
final bookAppointmentProvider = FutureProvider.family.autoDispose<
  void,
  ({
    String appointmentId,
    String userId,
    DateTime selectedSlot,
    Map<String, dynamic>? additionalInfo,
  })
>((ref, params) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.bookAppointment(
    appointmentId: params.appointmentId,
    userId: params.userId,
    selectedSlot: params.selectedSlot,
    additionalInfo: params.additionalInfo,
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (_) => null,
  );
});

// Cancel booking provider
final cancelBookingProvider = FutureProvider.family.autoDispose<void, String>((ref, bookingId) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.cancelBooking(bookingId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (_) => null,
  );
});

// Reschedule booking provider
final rescheduleBookingProvider = FutureProvider.family.autoDispose<
  void,
  ({
    String bookingId,
    DateTime newSlot,
  })
>((ref, params) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.rescheduleBooking(
    bookingId: params.bookingId,
    newSlot: params.newSlot,
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (_) => null,
  );
});

// Get available slots for an appointment
final availableSlotsProvider = FutureProvider.family<List<DateTime>, String>((ref, appointmentId) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getAvailableSlots(appointmentId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (slots) => slots,
  );
});

// Check if user has booking for appointment
final hasUserBookingProvider = FutureProvider.family<bool, ({String appointmentId, String userId})>((ref, params) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.hasUserBooking(params.appointmentId, params.userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hasBooking) => hasBooking,
  );
});