import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/notification_badge.dart';
import './widgets/priority_action_card.dart';
import './widgets/recent_activity_item.dart';
import './widgets/schedule_card.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  int _notificationCount = 5;

  // Mock data for teacher dashboard
  final List<Map<String, dynamic>> _priorityActions = [
    {
      "title": "Mark Attendance",
      "subtitle": "32 students in Grade 5A",
      "icon": "how_to_reg",
      "color": const Color(0xFF1B365D),
      "route": "/attendance-marking"
    },
    {
      "title": "Post Today's Lesson",
      "subtitle": "Mathematics - Fractions",
      "icon": "book",
      "color": const Color(0xFF4A90A4),
      "route": "/lesson-creation"
    },
    {
      "title": "Upload Photos",
      "subtitle": "Science experiment activity",
      "icon": "photo_camera",
      "color": const Color(0xFF2D5A27),
      "route": "/photo-upload"
    },
    {
      "title": "Check Messages",
      "subtitle": "3 new parent messages",
      "icon": "message",
      "color": const Color(0xFFB7791F),
      "route": "/messages"
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "title": "Attendance Marked",
      "subtitle": "Grade 5A - 30/32 students present",
      "time": "2 hrs ago",
      "icon": "check_circle",
      "color": const Color(0xFF2D5A27),
      "type": "attendance"
    },
    {
      "title": "Lesson Posted",
      "subtitle": "Mathematics: Introduction to Fractions",
      "time": "4 hrs ago",
      "icon": "school",
      "color": const Color(0xFF4A90A4),
      "type": "lesson"
    },
    {
      "title": "Parent Message",
      "subtitle": "Sarah's mom asked about homework",
      "time": "6 hrs ago",
      "icon": "chat",
      "color": const Color(0xFFB7791F),
      "type": "message"
    },
    {
      "title": "Photos Uploaded",
      "subtitle": "Science lab experiment - 12 photos",
      "time": "1 day ago",
      "icon": "photo_library",
      "color": const Color(0xFF1B365D),
      "imageUrl":
          "https://images.pexels.com/photos/2280547/pexels-photo-2280547.jpeg?auto=compress&cs=tinysrgb&w=400",
      "type": "photo"
    },
    {
      "title": "Lesson Updated",
      "subtitle": "Added worksheet to English lesson",
      "time": "2 days ago",
      "icon": "edit",
      "color": const Color(0xFF4A90A4),
      "type": "lesson"
    },
  ];

  final List<Map<String, dynamic>> _todaySchedule = [
    {
      "subject": "Mathematics",
      "class": "Grade 5A",
      "startTime": "09:00 AM",
      "endTime": "10:00 AM",
      "status": "Completed"
    },
    {
      "subject": "Science",
      "class": "Grade 5A",
      "startTime": "10:30 AM",
      "endTime": "11:30 AM",
      "status": "In Progress"
    },
    {
      "subject": "English",
      "class": "Grade 5B",
      "startTime": "02:00 PM",
      "endTime": "03:00 PM",
      "status": "Upcoming"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _notificationCount = _notificationCount + 1;
    });
  }

  void _navigateToRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleQuickAction() {
    final currentHour = DateTime.now().hour;
    if (currentHour < 12) {
      // Morning - show attendance marking
      _navigateToRoute('/attendance-marking');
    } else {
      // Afternoon - show lesson posting
      _navigateToRoute('/lesson-creation');
    }
  }

  void _handleActivityAction(String type, String action) {
    // Handle activity actions based on type and action
    switch (action) {
      case 'edit':
        if (type == 'lesson') {
          _navigateToRoute('/lesson-creation');
        }
        break;
      case 'share':
        // Handle sharing functionality
        break;
      case 'respond':
        if (type == 'message') {
          _navigateToRoute('/messages');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Grade 5A",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              "Tuesday, August 13, 2025",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          NotificationBadge(
            count: _notificationCount,
            onTap: () => _navigateToRoute('/notifications'),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "Attendance"),
            Tab(text: "Lessons"),
            Tab(text: "Messages"),
            Tab(text: "Photos"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Home Tab
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Priority Actions Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      "Quick Actions",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Column(
                    children: _priorityActions.map((action) {
                      return PriorityActionCard(
                        title: action['title'] as String,
                        subtitle: action['subtitle'] as String,
                        iconName: action['icon'] as String,
                        backgroundColor: action['color'] as Color,
                        onTap: () =>
                            _navigateToRoute(action['route'] as String),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Today's Schedule
                  ScheduleCard(
                    scheduleItems: _todaySchedule,
                    onViewAll: () => _navigateToRoute('/schedule'),
                  ),

                  SizedBox(height: 3.h),

                  // Recent Activity Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      "Recent Activity",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Column(
                    children: _recentActivities.map((activity) {
                      return RecentActivityItem(
                        title: activity['title'] as String,
                        subtitle: activity['subtitle'] as String,
                        time: activity['time'] as String,
                        iconName: activity['icon'] as String,
                        iconColor: activity['color'] as Color,
                        imageUrl: activity['imageUrl'] as String?,
                        onTap: () => _handleActivityAction(
                            activity['type'] as String, 'view'),
                        onEdit: activity['type'] == 'lesson' ||
                                activity['type'] == 'attendance'
                            ? () => _handleActivityAction(
                                activity['type'] as String, 'edit')
                            : null,
                        onShare: () => _handleActivityAction(
                            activity['type'] as String, 'share'),
                        onRespond: activity['type'] == 'message'
                            ? () => _handleActivityAction(
                                activity['type'] as String, 'respond')
                            : null,
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 10.h), // Bottom padding for FAB
                ],
              ),
            ),
          ),

          // Other tabs - placeholder content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'how_to_reg',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Attendance Management",
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () => _navigateToRoute('/attendance-marking'),
                  child: const Text("Mark Attendance"),
                ),
              ],
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Lesson Management",
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () => _navigateToRoute('/lesson-creation'),
                  child: const Text("Create Lesson"),
                ),
              ],
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'message',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Messages",
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () => _navigateToRoute('/messages'),
                  child: const Text("View Messages"),
                ),
              ],
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Photo Gallery",
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () => _navigateToRoute('/photo-upload'),
                  child: const Text("Upload Photos"),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _handleQuickAction,
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: DateTime.now().hour < 12 ? 'how_to_reg' : 'book',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text(
                DateTime.now().hour < 12 ? 'Mark Attendance' : 'Post Lesson',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
