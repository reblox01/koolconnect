import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student.dart';
import './auth_service.dart';
import './supabase_service.dart';

class StudentService {
  static StudentService? _instance;
  static StudentService get instance => _instance ??= StudentService._();
  StudentService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Get students for current user based on role
  Future<List<Student>> getMyStudents() async {
    final userId = AuthService.instance.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final userProfile = await AuthService.instance.getCurrentUserProfile();
      if (userProfile == null) throw Exception('User profile not found');

      List<dynamic> response;

      switch (userProfile.role.value) {
        case 'parent':
          // Parents see only their linked children
          if (userProfile.linkedStudentIds?.isEmpty ?? true) {
            return [];
          }
          response = await _client
              .from('students')
              .select()
              .inFilter('id', userProfile.linkedStudentIds!)
              .eq('is_active', true);
          break;

        case 'teacher':
          // Teachers see students in their assigned classes
          if (userProfile.assignedClassIds?.isEmpty ?? true) {
            return [];
          }
          response = await _client
              .from('students')
              .select()
              .inFilter('class_id', userProfile.assignedClassIds!)
              .eq('is_active', true);
          break;

        case 'manager':
        case 'staff':
          // Managers and staff see all students in their school
          response = await _client
              .from('students')
              .select()
              .eq('is_active', true)
              .order('first_name');
          break;

        default:
          return [];
      }

      return response.map((json) => Student.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get students: $error');
    }
  }

  // Get students by class ID
  Future<List<Student>> getStudentsByClass(String classId) async {
    try {
      final response = await _client
          .from('students')
          .select()
          .eq('class_id', classId)
          .eq('is_active', true)
          .order('first_name');

      return response.map((json) => Student.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to get students by class: $error');
    }
  }

  // Get single student
  Future<Student?> getStudent(String studentId) async {
    try {
      final response =
          await _client.from('students').select().eq('id', studentId).single();

      return Student.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get student: $error');
    }
  }

  // Create new student (managers only)
  Future<Student> createStudent(Map<String, dynamic> studentData) async {
    try {
      final response =
          await _client.from('students').insert(studentData).select().single();

      return Student.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create student: $error');
    }
  }

  // Update student (managers/teachers only)
  Future<Student> updateStudent(
      String studentId, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .from('students')
          .update(updates)
          .eq('id', studentId)
          .select()
          .single();

      return Student.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update student: $error');
    }
  }

  // Search students
  Future<List<Student>> searchStudents(String query) async {
    try {
      final response = await _client
          .from('students')
          .select()
          .or('first_name.ilike.%$query%,last_name.ilike.%$query%')
          .eq('is_active', true)
          .order('first_name')
          .limit(50);

      return response.map((json) => Student.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to search students: $error');
    }
  }

  // Get students with parents
  Future<List<Map<String, dynamic>>> getStudentsWithParents() async {
    try {
      final response = await _client.from('students').select('''
            *,
            parents:user_profiles!students_parent_ids_fkey(
              id,
              display_name,
              email
            )
          ''').eq('is_active', true).order('first_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get students with parents: $error');
    }
  }
}
