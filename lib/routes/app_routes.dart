import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/teacher_dashboard/teacher_dashboard.dart';
import '../presentation/attendance_marking/attendance_marking.dart';
import '../presentation/lesson_creation/lesson_creation.dart';
import '../presentation/manager_dashboard/manager_dashboard.dart';
import '../presentation/parent_dashboard/parent_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String login = '/login';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String attendanceMarking = '/attendance-marking';
  static const String lessonCreation = '/lesson-creation';
  static const String managerDashboard = '/manager-dashboard';
  static const String parentDashboard = '/parent-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    login: (context) => const LoginScreen(),
    teacherDashboard: (context) => const TeacherDashboard(),
    attendanceMarking: (context) => const AttendanceMarking(),
    lessonCreation: (context) => const LessonCreation(),
    managerDashboard: (context) => const ManagerDashboard(),
    parentDashboard: (context) => const ParentDashboard(),
    // TODO: Add your other routes here
  };
}
