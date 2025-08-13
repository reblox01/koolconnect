import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/absence_reason_bottom_sheet.dart';
import './widgets/attendance_header.dart';
import './widgets/student_attendance_card.dart';
import './widgets/student_context_menu.dart';
import './widgets/student_search_bar.dart';

class AttendanceMarking extends StatefulWidget {
  const AttendanceMarking({Key? key}) : super(key: key);

  @override
  State<AttendanceMarking> createState() => _AttendanceMarkingState();
}

class _AttendanceMarkingState extends State<AttendanceMarking> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isLoading = false;
  bool hasUnsavedChanges = false;

  // Mock student data
  final List<Map<String, dynamic>> allStudents = [
    {
      "id": 1,
      "name": "Emma Johnson",
      "studentId": "ST001",
      "profilePhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": true,
      "absenceReason": null,
    },
    {
      "id": 2,
      "name": "Liam Smith",
      "studentId": "ST002",
      "profilePhoto":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": false,
      "absenceReason": "Sick",
    },
    {
      "id": 3,
      "name": "Olivia Brown",
      "studentId": "ST003",
      "profilePhoto":
          "https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": true,
      "absenceReason": null,
    },
    {
      "id": 4,
      "name": "Noah Davis",
      "studentId": "ST004",
      "profilePhoto":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": true,
      "absenceReason": null,
    },
    {
      "id": 5,
      "name": "Ava Wilson",
      "studentId": "ST005",
      "profilePhoto":
          "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": false,
      "absenceReason": "Family Emergency",
    },
    {
      "id": 6,
      "name": "William Miller",
      "studentId": "ST006",
      "profilePhoto":
          "https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": true,
      "absenceReason": null,
    },
    {
      "id": 7,
      "name": "Sophia Garcia",
      "studentId": "ST007",
      "profilePhoto":
          "https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": true,
      "absenceReason": null,
    },
    {
      "id": 8,
      "name": "James Martinez",
      "studentId": "ST008",
      "profilePhoto":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isPresent": false,
      "absenceReason": "Medical Appointment",
    },
  ];

  List<Map<String, dynamic>> get filteredStudents {
    if (searchQuery.isEmpty) {
      return allStudents;
    }
    return allStudents.where((student) {
      final name = (student["name"] as String).toLowerCase();
      final studentId = (student["studentId"] as String).toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query) || studentId.contains(query);
    }).toList();
  }

  int get presentCount {
    return allStudents.where((student) => student["isPresent"] as bool).length;
  }

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadAttendanceData();
    Fluttertoast.showToast(
      msg: "Attendance data refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleStudentAttendance(int studentId) {
    setState(() {
      final studentIndex = allStudents.indexWhere((s) => s["id"] == studentId);
      if (studentIndex != -1) {
        final student = allStudents[studentIndex];
        student["isPresent"] = !(student["isPresent"] as bool);

        // Clear absence reason if marking present
        if (student["isPresent"] as bool) {
          student["absenceReason"] = null;
        }

        hasUnsavedChanges = true;
      }
    });

    _autoSave();
  }

  void _showAbsenceReasonSheet(int studentId) {
    final student = allStudents.firstWhere((s) => s["id"] == studentId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AbsenceReasonBottomSheet(
          studentName: student["name"] as String,
          currentReason: student["absenceReason"] as String?,
          onReasonSelected: (reason) {
            setState(() {
              student["absenceReason"] = reason;
              student["isPresent"] = false;
              hasUnsavedChanges = true;
            });
            _autoSave();
          },
        ),
      ),
    );
  }

  void _showStudentContextMenu(int studentId) {
    final student = allStudents.firstWhere((s) => s["id"] == studentId);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StudentContextMenu(
        studentName: student["name"] as String,
        onViewProfile: () => _viewStudentProfile(studentId),
        onMessageParent: () => _messageParent(studentId),
        onViewHistory: () => _viewAttendanceHistory(studentId),
      ),
    );
  }

  void _viewStudentProfile(int studentId) {
    Fluttertoast.showToast(
      msg: "Opening student profile...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _messageParent(int studentId) {
    Navigator.pushNamed(context, '/messages');
  }

  void _viewAttendanceHistory(int studentId) {
    Fluttertoast.showToast(
      msg: "Loading attendance history...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _markAllPresent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark All Present'),
        content: Text('Are you sure you want to mark all students as present?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var student in allStudents) {
                  student["isPresent"] = true;
                  student["absenceReason"] = null;
                }
                hasUnsavedChanges = true;
              });
              Navigator.pop(context);
              _autoSave();
              Fluttertoast.showToast(
                msg: "All students marked present",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _markAllAbsent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark All Absent'),
        content: Text('Are you sure you want to mark all students as absent?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var student in allStudents) {
                  student["isPresent"] = false;
                  if (student["absenceReason"] == null) {
                    student["absenceReason"] = "Not specified";
                  }
                }
                hasUnsavedChanges = true;
              });
              Navigator.pop(context);
              _autoSave();
              Fluttertoast.showToast(
                msg: "All students marked absent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await _loadAttendanceData();
    }
  }

  void _autoSave() {
    // Simulate auto-save with a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && hasUnsavedChanges) {
        setState(() {
          hasUnsavedChanges = false;
        });
        Fluttertoast.showToast(
          msg: "Attendance saved automatically",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _saveAttendance() {
    setState(() {
      hasUnsavedChanges = false;
    });

    Fluttertoast.showToast(
      msg: "Attendance saved successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Attendance Marking',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
        ),
        actions: [
          if (hasUnsavedChanges)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              child: TextButton(
                onPressed: _saveAttendance,
                child: Text(
                  'Save',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Attendance Header
          AttendanceHeader(
            selectedDate: selectedDate,
            onDateTap: _selectDate,
            onMarkAllPresent: _markAllPresent,
            onMarkAllAbsent: _markAllAbsent,
            totalStudents: allStudents.length,
            presentCount: presentCount,
          ),

          // Search Bar
          StudentSearchBar(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onClear: _clearSearch,
          ),

          // Student List
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: filteredStudents.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'search_off',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 48,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'No students found'
                                      : 'No students match your search',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 2.h),
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              return StudentAttendanceCard(
                                student: student,
                                isPresent: student["isPresent"] as bool,
                                onToggleAttendance: () =>
                                    _toggleStudentAttendance(
                                        student["id"] as int),
                                onSwipeRight: () => _showAbsenceReasonSheet(
                                    student["id"] as int),
                                onLongPress: () => _showStudentContextMenu(
                                    student["id"] as int),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
