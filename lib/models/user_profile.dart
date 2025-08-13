enum UserRole {
  manager('manager'),
  teacher('teacher'),
  parent('parent'),
  staff('staff');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere((role) => role.value == value);
  }
}

class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final String? schoolId;
  final List<String>? linkedStudentIds;
  final List<String>? assignedClassIds;
  final List<String>? fcmTokens;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.schoolId,
    this.linkedStudentIds,
    this.assignedClassIds,
    this.fcmTokens,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'parent'),
      schoolId: json['school_id'],
      linkedStudentIds: json['linked_student_ids'] != null
          ? List<String>.from(json['linked_student_ids'])
          : null,
      assignedClassIds: json['assigned_class_ids'] != null
          ? List<String>.from(json['assigned_class_ids'])
          : null,
      fcmTokens: json['fcm_tokens'] != null
          ? List<String>.from(json['fcm_tokens'])
          : null,
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
      'email': email,
      'display_name': displayName,
      'role': role.value,
      'school_id': schoolId,
      'linked_student_ids': linkedStudentIds,
      'assigned_class_ids': assignedClassIds,
      'fcm_tokens': fcmTokens,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
