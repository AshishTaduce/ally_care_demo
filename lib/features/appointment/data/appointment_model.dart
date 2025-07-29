import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel extends Equatable {
  final String id;
  final String title;
  final String iconSvg;
  final String backgroundColor;
  final String description;
  final String category;
  final int duration; // in minutes
  final double price;
  final List<DateTime> availableSlots;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorImage;
  final String location;
  final bool isOnline;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const AppointmentModel({
    required this.iconSvg, required this.backgroundColor,
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.price,
    required this.availableSlots,
    required this.doctorName,
    required this.doctorSpecialty,
    this.doctorImage,
    required this.location,
    required this.isOnline,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  // Factory constructor for creating from Firestore
  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Convert available slots from Firestore timestamps to DateTime
    final slotsData = data['availableSlots'] as List<dynamic>? ?? [];
    final slots = slotsData.map((slot) {
      if (slot is Timestamp) {
        return slot.toDate();
      } else if (slot is String) {
        return DateTime.parse(slot);
      }
      return DateTime.now();
    }).toList();

    return AppointmentModel(
      id: doc.id,
      iconSvg: data['iconSvg'],
      backgroundColor: data['backgroundColor'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      duration: data['duration'] ?? 0,
      price: (data['price'] ?? 0.0).toDouble(),
      availableSlots: slots,
      doctorName: data['doctorName'] ?? '',
      doctorSpecialty: data['doctorSpecialty'] ?? '',
      doctorImage: data['doctorImage'],
      location: data['location'] ?? '',
      isOnline: data['isOnline'] ?? false,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  // Factory constructor for creating from JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final slotsData = json['availableSlots'] as List<dynamic>? ?? [];
    final slots = slotsData.map((slot) => DateTime.parse(slot as String)).toList();

    return AppointmentModel(
      id: json['id'],
      iconSvg: json['iconSvg'],
      backgroundColor: json['backgroundColor'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      duration: json['duration'],
      price: json['price'].toDouble(),
      availableSlots: slots,
      doctorName: json['doctorName'],
      doctorSpecialty: json['doctorSpecialty'],
      doctorImage: json['doctorImage'],
      location: json['location'],
      isOnline: json['isOnline'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      metadata: json['metadata'],
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'price': price,
      'availableSlots': availableSlots.map((slot) => Timestamp.fromDate(slot)).toList(),
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorImage': doctorImage,
      'location': location,
      'isOnline': isOnline,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'price': price,
      'availableSlots': availableSlots.map((slot) => slot.toIso8601String()).toList(),
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorImage': doctorImage,
      'location': location,
      'isOnline': isOnline,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Copy with method
  AppointmentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? duration,
    double? price,
    List<DateTime>? availableSlots,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorImage,
    String? location,
    bool? isOnline,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      iconSvg: iconSvg,
      backgroundColor: backgroundColor,
      description: description ?? this.description,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      availableSlots: availableSlots ?? this.availableSlots,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorImage: doctorImage ?? this.doctorImage,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper getters
  String get durationText => '$duration min';
  String get priceText => '\$${price.toStringAsFixed(2)}';

  String get appointmentTypeText => isOnline ? 'Online' : 'In-Person';

  String get nextAvailableSlot {
    if (availableSlots.isEmpty) return 'No slots available';

    final now = DateTime.now();
    final futureSlots = availableSlots.where((slot) => slot.isAfter(now)).toList();

    if (futureSlots.isEmpty) return 'No upcoming slots';

    futureSlots.sort();
    final nextSlot = futureSlots.first;

    // Format the date nicely
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (nextSlot.year == today.year &&
        nextSlot.month == today.month &&
        nextSlot.day == today.day) {
      return 'Today ${_formatTime(nextSlot)}';
    } else if (nextSlot.year == tomorrow.year &&
        nextSlot.month == tomorrow.month &&
        nextSlot.day == tomorrow.day) {
      return 'Tomorrow ${_formatTime(nextSlot)}';
    } else {
      return '${nextSlot.day}/${nextSlot.month} ${_formatTime(nextSlot)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    duration,
    price,
    availableSlots,
    doctorName,
    doctorSpecialty,
    doctorImage,
    location,
    isOnline,
    isActive,
    createdAt,
    updatedAt,
    metadata,
  ];
}