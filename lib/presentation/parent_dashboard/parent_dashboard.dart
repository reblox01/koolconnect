import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../models/attendance.dart';
import '../../models/lesson.dart';
import '../../models/student.dart';
import '../../routes/app_routes.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_service.dart';
import '../../services/lesson_service.dart';
import '../../services/student_service.dart';
import './widgets/attendance_summary_card.dart';
import './widgets/child_card.dart';
import './widgets/recent_lesson_card.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  List<Student> _children = [];
  List<Lesson> _recentLessons = [];
  List<Attendance> _recentAttendance = [];
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load user profile
      final userProfile = await AuthService.instance.getCurrentUserProfile();
      _userName = userProfile?.displayName ?? 'Parent';

      // Load children
      final children = await StudentService.instance.getMyStudents();

      // Load recent lessons for children
      final lessons =
          await LessonService.instance.getLessonsForParent(limit: 10);

      // Load recent attendance for children
      final attendance =
          await AttendanceService.instance.getMyChildrenAttendance(limit: 10);

      setState(() {
        _children = children;
        _recentLessons = lessons;
        _recentAttendance = attendance;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load dashboard data: ${error.toString()}');
    }
  }

  Future<void> _signOut() async {
    try {
      await AuthService.instance.signOut();
      Navigator.pushReplacementNamed(context, AppRoutes.initial);
    } catch (error) {
      _showErrorSnackBar('Failed to sign out: ${error.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good Morning',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400)),
              Text(_userName,
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ]),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: _loadDashboardData,
                  icon: Icon(Icons.refresh, color: Colors.white)),
              PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        // Navigate to profile
                        break;
                      case 'settings':
                        // Navigate to settings
                        break;
                      case 'logout':
                        _signOut();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                        PopupMenuItem(value: 'profile', child: Text('Profile')),
                        PopupMenuItem(
                            value: 'settings', child: Text('Settings')),
                        PopupMenuItem(value: 'logout', child: Text('Logout')),
                      ]),
            ]),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Children Section
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('My Children',
                                    style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold)),
                                if (_children.length > 3)
                                  TextButton(
                                      onPressed: () => _showAllChildren(),
                                      child: Text('View All')),
                              ]),
                          SizedBox(height: 2.h),

                          if (_children.isEmpty)
                            Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withAlpha(13),
                                          blurRadius: 10,
                                          spreadRadius: 2),
                                    ]),
                                child: Column(children: [
                                  Icon(Icons.child_care,
                                      size: 50, color: Colors.grey[400]),
                                  SizedBox(height: 2.h),
                                  Text('No children assigned',
                                      style: GoogleFonts.inter(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600])),
                                  Text(
                                      'Please contact your school administrator',
                                      style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          color: Colors.grey[500]),
                                      textAlign: TextAlign.center),
                                ]))
                          else
                            SizedBox(
                                height: 20.h,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _children.length > 3
                                        ? 3
                                        : _children.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: EdgeInsets.only(right: 3.w),
                                          child: ChildCard(
                                              student: _children[index],
                                              onTap: () => _viewChildDetails(
                                                  _children[index])));
                                    })),

                          SizedBox(height: 3.h),

                          // Quick Stats
                          Row(children: [
                            Expanded(
                                child: AttendanceSummaryCard(
                                    title: 'Present This Week',
                                    value: _calculateWeeklyAttendance(),
                                    icon: Icons.check_circle,
                                    color: Colors.green)),
                            SizedBox(width: 3.w),
                            Expanded(
                                child: AttendanceSummaryCard(
                                    title: 'New Lessons',
                                    value: _recentLessons.length.toString(),
                                    icon: Icons.book,
                                    color: Colors.blue)),
                          ]),

                          SizedBox(height: 3.h),

                          // Recent Lessons Section
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recent Lessons',
                                    style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold)),
                                if (_recentLessons.length > 5)
                                  TextButton(
                                      onPressed: () => _showAllLessons(),
                                      child: Text('View All')),
                              ]),
                          SizedBox(height: 2.h),

                          if (_recentLessons.isEmpty)
                            Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(children: [
                                  Icon(Icons.book,
                                      color: Colors.grey[400], size: 30),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                      child: Text('No recent lessons available',
                                          style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              color: Colors.grey[600]))),
                                ]))
                          else
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _recentLessons.length > 5
                                    ? 5
                                    : _recentLessons.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(bottom: 2.h),
                                      child: RecentLessonCard(
                                          lesson: _recentLessons[index],
                                          onTap: () => _viewLessonDetails(
                                              _recentLessons[index])));
                                }),
                        ]))));
  }

  String _calculateWeeklyAttendance() {
    // Calculate how many children were present this week
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final thisWeekAbsences = _recentAttendance.where((attendance) {
      return attendance.date.isAfter(weekStart);
    }).toList();

    final childDaysThisWeek = _children.length * 5; // 5 school days
    final absentDays = thisWeekAbsences.length;
    final presentDays = childDaysThisWeek - absentDays;

    return '$presentDays/${childDaysThisWeek}';
  }

  void _viewChildDetails(Student child) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChildDetailsScreen(student: child)));
  }

  void _viewLessonDetails(Lesson lesson) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => LessonDetailsBottomSheet(lesson: lesson));
  }

  void _showAllChildren() {
    // Navigate to all children screen
  }

  void _showAllLessons() {
    // Navigate to all lessons screen
  }
}

// Placeholder screens for child details and lesson details
class ChildDetailsScreen extends StatelessWidget {
  final Student student;

  const ChildDetailsScreen({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(student.fullName)),
        body: Center(child: Text('Child Details for ${student.fullName}')));
  }
}

class LessonDetailsBottomSheet extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailsBottomSheet({Key? key, required this.lesson})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2)))),
          SizedBox(height: 3.h),
          Text(lesson.subject,
              style: GoogleFonts.inter(
                  fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 2.h),
          Text(lesson.content,
              style:
                  GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[700])),
          if (lesson.attachments?.isNotEmpty == true) ...[
            SizedBox(height: 2.h),
            Text('Attachments:',
                style: GoogleFonts.inter(
                    fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 1.h),
            ...lesson.attachments!
                .map((attachment) => ListTile(
                    leading: Icon(Icons.attachment),
                    title: Text(attachment.name),
                    onTap: () {
                      // Handle attachment tap
                    }))
                .toList(),
          ],
        ]));
  }
}