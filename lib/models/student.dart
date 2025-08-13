class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String? classId;
  final List<String>? parentIds;
  final DateTime? dateOfBirth;
  final DateTime enrollmentDate;
  final String? photoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.classId,
    this.parentIds,
    this.dateOfBirth,
    required this.enrollmentDate,
    this.photoUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      classId: json['class_id'],
      parentIds: json['parent_ids'] != null
          ? List<String>.from(json['parent_ids'])
          : null,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      enrollmentDate: DateTime.parse(
          json['enrollment_date'] ?? DateTime.now().toIso8601String()),
      photoUrl: json['photo_url'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'class_id': classId,
      'parent_ids': parentIds,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'enrollment_date': enrollmentDate.toIso8601String().split('T')[0],
      'photo_url': photoUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
