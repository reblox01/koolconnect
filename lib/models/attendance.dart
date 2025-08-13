class Attendance {
  final String id;
  final String? studentId;
  final String? classId;
  final DateTime date;
  final String? recordedBy;
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attendance({
    required this.id,
    this.studentId,
    this.classId,
    required this.date,
    this.recordedBy,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? '',
      studentId: json['student_id'],
      classId: json['class_id'],
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      recordedBy: json['recorded_by'],
      reason: json['reason'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'class_id': classId,
      'date': date.toIso8601String().split('T')[0],
      'recorded_by': recordedBy,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
