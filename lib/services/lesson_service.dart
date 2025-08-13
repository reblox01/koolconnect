import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/lesson.dart';
import './auth_service.dart';
import './supabase_service.dart';

class LessonService {
  static LessonService? _instance;
  static LessonService get instance => _instance ??= LessonService._();
  LessonService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Create a new lesson
  Future<Lesson> createLesson({
    required String classId,
    required String subject,
    required String content,
    List<LessonAttachment>? attachments,
    DateTime? date,
    bool visibleToParents = true,
  }) async {
    final userId = AuthService.instance.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final lessonData = {
        'class_id': classId,
        'teacher_id': userId,
        'subject': subject,
        'content': content,
        'attachments': attachments?.map((a) => a.toJson()).toList() ?? [],
        'date': (date ?? DateTime.now()).toIso8601String(),
        'visible_to_parents': visibleToParents,
      };

      final response =
          await _client.from('lessons').insert(lessonData).select().single();

      return Lesson.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create lesson: $error');
    }
  }

  // Get lessons for a specific class
  Future<List<Lesson>> getLessonsByClass(String classId,
      {int limit = 50}) async {
    try {
      final response = await _client
          .from('lessons')
          .select()
          .eq('class_id', classId)
          .order('date', ascending: false)
          .limit(limit);

      return response.map((json) => Lesson.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get lessons by class: $error');
    }
  }

  // Get lessons for current teacher
  Future<List<Lesson>> getMyLessons({int limit = 50}) async {
    final userId = AuthService.instance.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final response = await _client
          .from('lessons')
          .select()
          .eq('teacher_id', userId)
          .order('date', ascending: false)
          .limit(limit);

      return response.map((json) => Lesson.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get my lessons: $error');
    }
  }

  // Get lessons visible to parents for their children
  Future<List<Lesson>> getLessonsForParent({int limit = 50}) async {
    try {
      final userProfile = await AuthService.instance.getCurrentUserProfile();
      if (userProfile == null ||
          userProfile.linkedStudentIds?.isEmpty == true) {
        return [];
      }

      // Get class IDs for linked students
      final studentsResponse = await _client
          .from('students')
          .select('class_id')
          .inFilter('id', userProfile.linkedStudentIds!);

      final classIds = studentsResponse
          .map((s) => s['class_id'])
          .where((id) => id != null)
          .toSet()
          .toList();

      if (classIds.isEmpty) return [];

      final response = await _client
          .from('lessons')
          .select()
          .inFilter('class_id', classIds)
          .eq('visible_to_parents', true)
          .order('date', ascending: false)
          .limit(limit);

      return response.map((json) => Lesson.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get lessons for parent: $error');
    }
  }

  // Get today's lessons for a class
  Future<List<Lesson>> getTodaysLessons(String classId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(Duration(days: 1));

      final response = await _client
          .from('lessons')
          .select()
          .eq('class_id', classId)
          .gte('date', startOfDay.toIso8601String())
          .lt('date', endOfDay.toIso8601String())
          .order('date');

      return response.map((json) => Lesson.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get today\'s lessons: $error');
    }
  }

  // Update lesson
  Future<Lesson> updateLesson(
      String lessonId, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .from('lessons')
          .update(updates)
          .eq('id', lessonId)
          .select()
          .single();

      return Lesson.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update lesson: $error');
    }
  }

  // Delete lesson
  Future<void> deleteLesson(String lessonId) async {
    try {
      await _client.from('lessons').delete().eq('id', lessonId);
    } catch (error) {
      throw Exception('Failed to delete lesson: $error');
    }
  }

  // Get lesson statistics for a class
  Future<Map<String, dynamic>> getLessonStats(String classId) async {
    try {
      final totalResponse = await _client
          .from('lessons')
          .select('id')
          .eq('class_id', classId)
          .count();

      final thisMonthStart =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      final thisMonthResponse = await _client
          .from('lessons')
          .select('id')
          .eq('class_id', classId)
          .gte('date', thisMonthStart.toIso8601String())
          .count();

      return {
        'total_lessons': totalResponse.count ?? 0,
        'this_month': thisMonthResponse.count ?? 0,
      };
    } catch (error) {
      throw Exception('Failed to get lesson stats: $error');
    }
  }

  // Upload lesson attachment (file should be uploaded to storage first)
  Future<LessonAttachment> uploadAttachment(
    String filePath,
    String fileName,
    String fileUrl,
  ) async {
    try {
      return LessonAttachment(
        name: fileName,
        url: fileUrl,
        type: _getFileType(fileName),
      );
    } catch (error) {
      throw Exception('Failed to process attachment: $error');
    }
  }

  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }
}
