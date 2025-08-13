class LessonAttachment {
  final String name;
  final String url;
  final String? type;
  final int? size;

  LessonAttachment({
    required this.name,
    required this.url,
    this.type,
    this.size,
  });

  factory LessonAttachment.fromJson(Map<String, dynamic> json) {
    return LessonAttachment(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      type: json['type'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'type': type,
      'size': size,
    };
  }
}

class Lesson {
  final String id;
  final String? classId;
  final String? teacherId;
  final String subject;
  final String content;
  final List<LessonAttachment>? attachments;
  final DateTime date;
  final bool visibleToParents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    this.classId,
    this.teacherId,
    required this.subject,
    required this.content,
    this.attachments,
    required this.date,
    this.visibleToParents = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    List<LessonAttachment>? attachmentsList;
    if (json['attachments'] is List) {
      attachmentsList = (json['attachments'] as List)
          .map((attachment) => LessonAttachment.fromJson(attachment))
          .toList();
    }

    return Lesson(
      id: json['id'] ?? '',
      classId: json['class_id'],
      teacherId: json['teacher_id'],
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      attachments: attachmentsList,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      visibleToParents: json['visible_to_parents'] ?? true,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'teacher_id': teacherId,
      'subject': subject,
      'content': content,
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'date': date.toIso8601String(),
      'visible_to_parents': visibleToParents,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
