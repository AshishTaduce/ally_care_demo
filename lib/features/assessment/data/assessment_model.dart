import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'assessment_model.g.dart';

@HiveType(typeId: 1)
class AssessmentModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final int duration; // in minutes
  @HiveField(6)
  final String difficulty; //
  @HiveField(7)
  final List<String> tags;
  @HiveField(8)
  final double rating;
  @HiveField(9)
  final int reviewCount;
  @HiveField(10)
  final DateTime createdAt;
  @HiveField(11)
  final DateTime updatedAt;
  @HiveField(12)
  final bool isActive;
  @HiveField(13)
  final Map<String, dynamic>? metadata;
  @HiveField(14)
  final String titleLower;
  @HiveField(15)
  final List<String> instructions;

  const AssessmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.metadata,
    required this.titleLower,
    required this.instructions,
  });

  // Factory constructor for creating from Firestore
  factory AssessmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AssessmentModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      duration: data['duration'] ?? 0,
      difficulty: data['difficulty'] ?? 'Easy',
      tags: List<String>.from(data['tags'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      metadata: data['metadata'] as Map<String, dynamic>?,
      titleLower: data['titleLower'] ?? (data['title'] ?? '').toString().toLowerCase(),
      instructions: List<String>.from(data['instructions'] ?? []),
    );
  }

  // Factory constructor for creating from JSON
  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      tags: List<String>.from(json['tags']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      metadata: json['metadata'],
      titleLower: json['titleLower'] ?? (json['title'] ?? '').toString().toLowerCase(),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'metadata': metadata,
      'titleLower': titleLower,
      'instructions': instructions,
    };
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
      'titleLower': titleLower,
      'instructions': instructions,
    };
  }

  // Copy with method
  AssessmentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    int? duration,
    String? difficulty,
    List<String>? tags,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
    String? titleLower,
    List<String>? instructions,
  }) {
    return AssessmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      titleLower: titleLower ?? this.titleLower,
      instructions: instructions ?? this.instructions,
    );
  }

  // Helper getters
  String get durationText => '$duration min';

  String get difficultyEmoji {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return '🟢';
      case 'medium':
        return '🟡';
      case 'hard':
        return '🔴';
      default:
        return '⭐';
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    category,
    duration,
    difficulty,
    tags,
    rating,
    reviewCount,
    createdAt,
    updatedAt,
    isActive,
    metadata,
    titleLower,
    instructions,
  ];
}