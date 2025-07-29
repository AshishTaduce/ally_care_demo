import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import 'appointment_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore;

  AppointmentService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    // Enable offline persistence
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: AppConstants.maxCacheSize,
    );
  }

  // Get appointments with offline support
  Future<Either<Failure, List<AppointmentModel>>> getAppointments({
    int limit = AppConstants.defaultPageSize,
    String? category,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection(AppConstants.appointmentsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true);

      // Filter by category if provided
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      // Add pagination
      query = query.limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get(const GetOptions(
        source: Source.cache, // Try cache first
      )).catchError((_) async {
        // If cache fails, try server
        return await query.get(const GetOptions(
          source: Source.server,
        ));
      });

      final appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();

      return Right(appointments);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch appointments'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Get recent appointments for home page (limit 2)
  Future<Either<Failure, List<AppointmentModel>>> getRecentAppointments() async {
    return getAppointments();
  }

  // Get appointment by ID
  Future<Either<Failure, AppointmentModel>> getAppointmentById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.appointmentsCollection)
          .doc(id)
          .get(const GetOptions(source: Source.cache))
          .catchError((_) async {
        return await _firestore
            .collection(AppConstants.appointmentsCollection)
            .doc(id)
            .get(const GetOptions(source: Source.server));
      });

      if (!doc.exists) {
        return Left(FirestoreFailure('Appointment not found'));
      }

      final appointment = AppointmentModel.fromFirestore(doc);
      return Right(appointment);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch appointment'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Check if user already has a booking for this appointment
  Future<Either<Failure, bool>> hasUserBooking(String appointmentId, String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('appointmentId', isEqualTo: appointmentId)
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      return Right(querySnapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to check booking'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Book appointment
  Future<Either<Failure, void>> bookAppointment({
    required String appointmentId,
    required String userId,
    required DateTime selectedSlot,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      // Check if user already has a booking for this appointment
      final hasBooking = await hasUserBooking(appointmentId, userId);
      return hasBooking.fold(
        (failure) => Left(failure),
        (hasExistingBooking) async {
          if (hasExistingBooking) {
            return Left(FirestoreFailure('You already have a booking for this appointment'));
          }
          
          await _firestore.collection('bookings').add({
            'appointmentId': appointmentId,
            'userId': userId,
            'selectedSlot': Timestamp.fromDate(selectedSlot),
            'status': 'pending',
            'bookedAt': Timestamp.now(),
            'additionalInfo': additionalInfo,
          });

          return const Right(null);
        },
      );
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to book appointment'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Get user's booked appointments
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserBookings(
      String userId,
      ) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .get(const GetOptions(source: Source.cache))
          .catchError((_) async {
        return await _firestore
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('bookedAt', descending: true)
            .get(const GetOptions(source: Source.server));
      });

      final bookings = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      return Right(bookings);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch bookings'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Cancel a booking (soft delete)
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({'status': 'cancelled'});
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to cancel booking'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Reschedule a booking (update slot)
  Future<Either<Failure, void>> rescheduleBooking({
    required String bookingId,
    required DateTime newSlot,
  }) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'selectedSlot': Timestamp.fromDate(newSlot),
        'status': 'pending',
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to reschedule booking'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Stream appointments for real-time updates
  Stream<List<AppointmentModel>> getAppointmentsStream({
    int limit = AppConstants.defaultPageSize,
    String? category,
  }) {
    Query query = _firestore
        .collection(AppConstants.appointmentsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.limit(limit).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get available slots for an appointment
  Future<Either<Failure, List<DateTime>>> getAvailableSlots(String appointmentId) async {
    try {
      final doc = await _firestore.collection(AppConstants.appointmentsCollection).doc(appointmentId).get();
      if (!doc.exists) {
        return Left(FirestoreFailure('Appointment not found'));
      }
      final data = doc.data() as Map<String, dynamic>;
      final slotsData = data['availableSlots'] as List<dynamic>? ?? [];
      final slots = slotsData.map((slot) {
        if (slot is Timestamp) {
          return slot.toDate();
        } else if (slot is String) {
          return DateTime.parse(slot);
        }
        return DateTime.now();
      }).toList();
      return Right(slots);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch slots'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}