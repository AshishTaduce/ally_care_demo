import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/insets.dart';
import '../../data/appointment_model.dart';
import '../providers/appointment_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsCard extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  const AppointmentDetailsCard({super.key, required this.appointment});

  @override
  ConsumerState<AppointmentDetailsCard> createState() => _AppointmentDetailsCardState();
}

class _AppointmentDetailsCardState extends ConsumerState<AppointmentDetailsCard> {
  bool _isLoading = false;

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    return Stack(
      children: [
        currentUserAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) {
            if (user == null) {
              return const Center(child: Text('User not found'));
            }
            final userId = user.id;
            final userBookingsAsync = ref.watch(userBookingsProvider(userId));
            final availableSlotsAsync = ref.watch(availableSlotsProvider(widget.appointment.id));
            final hasBookingAsync = ref.watch(hasUserBookingProvider((appointmentId: widget.appointment.id, userId: userId)));
            return userBookingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (bookings) {
                // Filter bookings for this appointment (exclude cancelled)
                final appointmentBookings = bookings
                    .where((b) => b['appointmentId'] == widget.appointment.id && b['status'] != 'cancelled')
                    .toList();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(Insets.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                radius: 28,
                            child: widget.appointment.iconSvg.isNotEmpty
                    ? SvgPicture.asset(
                                    widget.appointment.iconSvg,
                        width: 32,
                        height: 32,
                      )
                    : null,
              ),
              SizedBox(width: Insets.md),
              Expanded(
                child: Text(
                              widget.appointment.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: Insets.md),
          Text(
                        widget.appointment.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: Insets.lg),
                      if (appointmentBookings.isNotEmpty) ...[
                        Text('Your Bookings:', style: Theme.of(context).textTheme.titleSmall),
                        ...appointmentBookings.map((booking) => Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text('Slot: ${(() {
                              final slot = booking['selectedSlot'];
                              DateTime? slotTime;
                              print("Slot is $slot");
                              if (slot is DateTime) {
                                slotTime = slot;
                              } else if (slot is String) {
                                slotTime = DateTime.tryParse(slot);
                              } else if (slot is Timestamp) {
                                slotTime = slot.toDate();
                              }
                              final dateFormat = DateFormat('EEE, MMM d, yyyy h:mm a');
                              return slotTime != null ? dateFormat.format(slotTime) : slot.toString();
                            })()}'),
                            subtitle: Text('Status: ${booking['status']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
            children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  tooltip: 'Reschedule',
                                  onPressed: () async {
                                    _showLoading();
                                    try {
                                      final slots = await availableSlotsAsync.maybeWhen(
                                        data: (s) => s,
                                        orElse: () => []);
                                      if (slots.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('No slots available')),
                                        );
                                        return;
                                      }
                                      
                                      // Step 1: Pick a date
                                      final dates = slots.map((dt) => DateTime(dt.year, dt.month, dt.day)).toSet().toList()..sort();
                                      final DateTime? selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: dates.first,
                                        firstDate: dates.first,
                                        lastDate: dates.last,
                                      );
                                      if (selectedDate == null) return;
                                      
                                      // Step 2: Pick a slot for that date
                                      final slotsForDate = slots.where((dt) => dt.year == selectedDate.year && dt.month == selectedDate.month && dt.day == selectedDate.day).toList();
                                      if (slotsForDate.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('No slots available for selected date')),
                                        );
                                        return;
                                      }
                                      final DateFormat timeFormat = DateFormat('h:mm a');
                                      final DateTime? newSlot = await showDialog<DateTime>(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                          title: Text('Select new slot'),
                                          children: slotsForDate.map((slot) => SimpleDialogOption(
                                            child: Text(timeFormat.format(slot)),
                                            onPressed: () => Navigator.pop(context, slot),
                                          )).toList(),
                                        ),
                                      );
                                      if (newSlot != null) {
                                        await ref.read(rescheduleBookingProvider((bookingId: booking['id'], newSlot: newSlot)).future);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Rescheduled!')),
                                        );
                                        ref.invalidate(userBookingsProvider(userId));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    } finally {
                                      _hideLoading();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.cancel),
                                  tooltip: 'Cancel',
                                  onPressed: () async {
                                    _showLoading();
                                    try {
                                      print("Cancelling booking with ID: ${booking['id']}");
                                      print("Booking data: $booking");
                                      await ref.read(cancelBookingProvider(booking['id']).future);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Cancelled!')),
                                      );
                                      ref.invalidate(userBookingsProvider(userId));
                                      ref.invalidate(hasUserBookingProvider((appointmentId: widget.appointment.id, userId: userId)));
                                    } catch (e) {
                                      print("Error cancelling booking: $e");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    } finally {
                                      _hideLoading();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )),
                      ] else ...[
                        Text('No bookings yet for this appointment.'),
                      ],
                      SizedBox(height: Insets.lg),
                      hasBookingAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                        data: (hasBooking) => availableSlotsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Error: $e')),
                          data: (slots) => ElevatedButton(
                            onPressed: (slots.isEmpty || hasBooking) ? null : () async {
                              _showLoading();
                              try {
                                // Step 1: Pick a date
                                final dates = slots.map((dt) => DateTime(dt.year, dt.month, dt.day)).toSet().toList()..sort();
                                final DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: dates.first,
                                  firstDate: dates.first,
                                  lastDate: dates.last,
                                );
                                if (selectedDate == null) return;
                                // Step 2: Pick a slot for that date
                                final slotsForDate = slots.where((dt) => dt.year == selectedDate.year && dt.month == selectedDate.month && dt.day == selectedDate.day).toList();
                                if (slotsForDate.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No slots available for selected date')),
                                  );
                                  return;
                                }
                                final DateFormat timeFormat = DateFormat('h:mm a');
                                final DateTime? selectedSlot = await showDialog<DateTime>(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                    title: Text('Select slot', style: Theme.of(context).textTheme.titleMedium,),
                                    children: slotsForDate.map((slot) => SimpleDialogOption(
                                      child: Text(timeFormat.format(slot)),
                                      onPressed: () => Navigator.pop(context, slot),
                                    )).toList(),
                                  ),
                                );
                                if (selectedSlot != null) {
                                  await ref.read(bookAppointmentProvider((
                                    appointmentId: widget.appointment.id,
                                    userId: userId,
                                    selectedSlot: selectedSlot,
                                    additionalInfo: null,
                                  )).future);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Booked!')),
                                  );
                                  ref.invalidate(userBookingsProvider(userId));
                                  ref.invalidate(hasUserBookingProvider((appointmentId: widget.appointment.id, userId: userId)));
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              } finally {
                                _hideLoading();
                              }
                            },
                            child: Text(hasBooking ? 'Already Booked' : 'Book New Slot'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
