import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/attendance.dart';
import './auth_service.dart';
import './supabase_service.dart';

class AttendanceService {
  static AttendanceService? _instance;
  static AttendanceService get instance => _instance ??= AttendanceService._();
  AttendanceService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Mark student as absent
  Future<Attendance> markAbsent({
    required String studentId,
    required String classId,
    DateTime? date,
    String? reason,
  }) async {
    final userId = AuthService.instance.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final attendanceData = {
        'student_id': studentId,
        'class_id': classId,
        'date': (date ?? DateTime.now()).toIso8601String().split('T')[0],
        'recorded_by': userId,
        'reason': reason,
      };

      final response = await _client
          .from('absences')
          .insert(attendanceData)
          .select()
          .single();

      return Attendance.fromJson(response);
    } catch (error) {
      throw Exception('Failed to mark absent: $error');
    }
  }

  // Mark multiple students as absent
  Future<List<Attendance>> markMultipleAbsent({
    required List<String> studentIds,
    required String classId,
    DateTime? date,
    String? reason,
  }) async {
    final userId = AuthService.instance.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final attendanceData = studentIds
          .map((studentId) => {
                'student_id': studentId,
                'class_id': classId,
                'date':
                    (date ?? DateTime.now()).toIso8601String().split('T')[0],
                'recorded_by': userId,
                'reason': reason,
              })
          .toList();

      final response =
          await _client.from('absences').insert(attendanceData).select();

      return response.map((json) => Attendance.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to mark multiple absent: $error');
    }
  }

  // Get attendance for a specific date and class
  Future<List<Attendance>> getAttendanceByDate(
      String classId, DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await _client
          .from('absences')
          .select()
          .eq('class_id', classId)
          .eq('date', dateStr)
          .order('created_at', ascending: false);

      return response.map((json) => Attendance.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get attendance by date: $error');
    }
  }

  // Get attendance for a specific student
  Future<List<Attendance>> getStudentAttendance(String studentId,
      {int limit = 50}) async {
    try {
      final response = await _client
          .from('absences')
          .select()
          .eq('student_id', studentId)
          .order('date', ascending: false)
          .limit(limit);

      return response.map((json) => Attendance.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get student attendance: $error');
    }
  }

  // Get recent attendance for parent's children
  Future<List<Attendance>> getMyChildrenAttendance({int limit = 50}) async {
    try {
      final userProfile = await AuthService.instance.getCurrentUserProfile();
      if (userProfile == null ||
          userProfile.linkedStudentIds?.isEmpty == true) {
        return [];
      }

      final response = await _client
          .from('absences')
          .select()
          .inFilter('student_id', userProfile.linkedStudentIds!)
          .order('date', ascending: false)
          .limit(limit);

      return response.map((json) => Attendance.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get children attendance: $error');
    }
  }

  // Remove absence record (mark as present)
  Future<void> markPresent(String attendanceId) async {
    try {
      await _client.from('absences').delete().eq('id', attendanceId);
    } catch (error) {
      throw Exception('Failed to mark present: $error');
    }
  }

  // Get attendance statistics for a class
  Future<Map<String, dynamic>> getAttendanceStats(String classId) async {
    try {
      final today = DateTime.now();
      final thisMonthStart = DateTime(today.year, today.month, 1);

      final totalStudentsResponse = await _client
          .from('students')
          .select('id')
          .eq('class_id', classId)
          .eq('is_active', true)
          .count();

      final todayAbsencesResponse = await _client
          .from('absences')
          .select('id')
          .eq('class_id', classId)
          .eq('date', today.toIso8601String().split('T')[0])
          .count();

      final thisMonthAbsencesResponse = await _client
          .from('absences')
          .select('id')
          .eq('class_id', classId)
          .gte('date', thisMonthStart.toIso8601String().split('T')[0])
          .count();

      final totalStudents = totalStudentsResponse.count ?? 0;
      final todayAbsences = todayAbsencesResponse.count ?? 0;
      final thisMonthAbsences = thisMonthAbsencesResponse.count ?? 0;

      return {
        'total_students': totalStudents,
        'present_today': totalStudents - todayAbsences,
        'absent_today': todayAbsences,
        'attendance_rate_today': totalStudents > 0
            ? ((totalStudents - todayAbsences) / totalStudents * 100).round()
            : 100,
        'total_absences_this_month': thisMonthAbsences,
      };
    } catch (error) {
      throw Exception('Failed to get attendance stats: $error');
    }
  }

  // Check if student is absent today
  Future<bool> isStudentAbsentToday(String studentId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final response = await _client
          .from('absences')
          .select('id')
          .eq('student_id', studentId)
          .eq('date', today)
          .count();

      return (response.count ?? 0) > 0;
    } catch (error) {
      return false;
    }
  }
}
