import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ally_care_demo/features/appointment/data/appointment_model.dart';
import 'package:ally_care_demo/features/appointment/presentation/providers/appointment_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  ConsumerState<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends ConsumerState<AppointmentDetailScreen> {
  DateTime? _selectedSlot;
  bool _booking = false;
  String? _confirmation;
  String? _bookingId;
  bool _hasBooking = false;

  Future<void> _checkExistingBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final bookingsResult = await ref.read(appointmentServiceProvider).getUserBookings(user.uid);
    bookingsResult.fold((_) {}, (bookings) {
      final booking = bookings.firstWhereOrNull(
        (b) => b['appointmentId'] == widget.appointment.id && b['status'] != 'cancelled',
      );
      if (booking != null) {
        setState(() {
          _hasBooking = true;
          _bookingId = booking['id'];
          _selectedSlot = (booking['selectedSlot'] as Timestamp).toDate();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkExistingBooking();
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment;
    return Scaffold(
      appBar: AppBar(title: Text(appt.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appt.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text('Doctor: ${appt.doctorName} (${appt.doctorSpecialty})'),
            if (appt.doctorImage != null) ...[
              const SizedBox(height: 8),
              CircleAvatar(backgroundImage: NetworkImage(appt.doctorImage!), radius: 32),
            ],
            const SizedBox(height: 16),
            Text('Available Slots:', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: appt.availableSlots.map((slot) => ChoiceChip(
                label: Text('${slot.day}/${slot.month} ${slot.hour}:${slot.minute.toString().padLeft(2, '0')}'),
                selected: _selectedSlot == slot,
                onSelected: (selected) {
                  setState(() => _selectedSlot = slot);
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            if (_confirmation != null)
              Text(_confirmation!, style: const TextStyle(color: Colors.green)),
            if (_hasBooking && _bookingId != null) ...[
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _booking
                        ? null
                        : () async {
                            setState(() => _booking = true);
                            final result = await ref.read(appointmentServiceProvider).cancelBooking(_bookingId!);
                            setState(() {
                              _booking = false;
                              _hasBooking = false;
                              _confirmation = result.isRight() ? 'Booking cancelled.' : 'Cancel failed: ${result.fold((f) => f.message, (_) => '')}';
                            });
                          },
                    child: const Text('Cancel Appointment'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _booking
                        ? null
                        : () async {
                            // Show dialog to pick new slot
                            final newSlot = await showDialog<DateTime>(
                              context: context,
                              builder: (context) => _RescheduleDialog(
                                availableSlots: widget.appointment.availableSlots.where((slot) => slot != _selectedSlot).toList(),
                              ),
                            );
                            if (newSlot != null) {
                              // Check for conflicts
                              final user = FirebaseAuth.instance.currentUser;
                              final bookingsResult = await ref.read(appointmentServiceProvider).getUserBookings(user!.uid);
                              final hasConflict = bookingsResult.fold((_) => false, (bookings) =>
                                bookings.any((b) => b['selectedSlot'] == newSlot && b['status'] != 'cancelled')
                              );
                              if (hasConflict) {
                                setState(() => _confirmation = 'Selected slot conflicts with another booking.');
                                return;
                              }
                              setState(() => _booking = true);
                              final result = await ref.read(appointmentServiceProvider).rescheduleBooking(
                                bookingId: _bookingId!,
                                newSlot: newSlot,
                              );
                              setState(() {
                                _booking = false;
                                _confirmation = result.isRight() ? 'Booking rescheduled!' : 'Reschedule failed: ${result.fold((f) => f.message, (_) => '')}';
                              });
                            }
                          },
                    child: const Text('Reschedule'),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: _booking || _selectedSlot == null ? null : () async {
                setState(() { _booking = true; _confirmation = null; });
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  setState(() { _booking = false; _confirmation = 'You must be logged in.'; });
                  return;
                }
                final result = await ref.read(appointmentServiceProvider).bookAppointment(
                  appointmentId: appt.id,
                  userId: user.uid,
                  selectedSlot: _selectedSlot!,
                );
                setState(() {
                  _booking = false;
                  _confirmation = result.fold(
                    (failure) => 'Booking failed: ${failure.message}',
                    (_) => 'Appointment booked!'
                  );
                });
              },
              child: _booking ? const CircularProgressIndicator() : const Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RescheduleDialog extends StatefulWidget {
  final List<DateTime> availableSlots;
  const _RescheduleDialog({super.key, required this.availableSlots});
  @override
  State<_RescheduleDialog> createState() => _RescheduleDialogState();
}
class _RescheduleDialogState extends State<_RescheduleDialog> {
  DateTime? _selected;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select New Slot'),
      content: Wrap(
        spacing: 8,
        children: widget.availableSlots.map((slot) => ChoiceChip(
          label: Text('${slot.day}/${slot.month} ${slot.hour}:${slot.minute.toString().padLeft(2, '0')}'),
          selected: _selected == slot,
          onSelected: (selected) => setState(() => _selected = slot),
        )).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selected == null ? null : () => Navigator.pop(context, _selected),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
} 