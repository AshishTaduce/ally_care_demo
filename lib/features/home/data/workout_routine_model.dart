class WorkoutRoutine {
  final String id;
  final String title;
  final String type;
  final String imageUrl;
  final String tag;
  final String difficulty;
  final String? description;

  WorkoutRoutine({
    required this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.tag,
    required this.difficulty,
    this.description,
  });

  factory WorkoutRoutine.fromMap(Map<String, dynamic> map, String id) {
    return WorkoutRoutine(
      id: id,
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      tag: map['tag'] ?? '',
      difficulty: map['difficulty'] ?? '',
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'imageUrl': imageUrl,
      'tag': tag,
      'difficulty': difficulty,
      'description': description,
    };
  }
} 