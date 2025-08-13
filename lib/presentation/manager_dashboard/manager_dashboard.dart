import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_feed_item.dart';
import './widgets/dashboard_header.dart';
import './widgets/dashboard_metrics_card.dart';
import './widgets/dashboard_tab_bar.dart';
import './widgets/quick_action_card.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({Key? key}) : super(key: key);

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "Total Users",
      "value": "247",
      "subtitle": "Active accounts",
      "icon": "people",
      "color": null,
    },
    {
      "title": "Teachers",
      "value": "32",
      "subtitle": "Teaching staff",
      "icon": "school",
      "color": null,
    },
    {
      "title": "Parents",
      "value": "198",
      "subtitle": "Parent accounts",
      "icon": "family_restroom",
      "color": null,
    },
    {
      "title": "Today's Attendance",
      "value": "89%",
      "subtitle": "Students present",
      "icon": "check_circle",
      "color": null,
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      "title": "Invite Parent",
      "icon": "person_add",
      "route": "/parent-dashboard",
    },
    {
      "title": "Add Teacher",
      "icon": "add_moderator",
      "route": "/teacher-dashboard",
    },
    {
      "title": "View Attendance",
      "icon": "assignment_turned_in",
      "route": "/attendance-marking",
    },
    {
      "title": "System Messages",
      "icon": "message",
      "route": "/messages",
    },
  ];

  final List<Map<String, dynamic>> _activityFeed = [
    {
      "title": "New Teacher Registration",
      "description": "Sarah Johnson joined as Math teacher",
      "timestamp": "2 hours ago",
      "icon": "person_add",
      "color": null,
    },
    {
      "title": "Attendance Submitted",
      "description": "Grade 5A attendance marked by Ms. Davis",
      "timestamp": "3 hours ago",
      "icon": "check_circle",
      "color": null,
    },
    {
      "title": "Photo Upload",
      "description": "15 new photos added to Science Fair album",
      "timestamp": "4 hours ago",
      "icon": "photo_camera",
      "color": null,
    },
    {
      "title": "Parent Invitation Sent",
      "description": "Invitation sent to martinez.family@email.com",
      "timestamp": "5 hours ago",
      "icon": "mail",
      "color": null,
    },
    {
      "title": "Lesson Posted",
      "description": "English Literature lesson shared with parents",
      "timestamp": "6 hours ago",
      "icon": "book",
      "color": null,
    },
    {
      "title": "Message Received",
      "description": "Parent inquiry about homework policy",
      "timestamp": "1 day ago",
      "icon": "chat",
      "color": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard updated successfully'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    }
  }

  void _handleQuickAction(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleActivityTap(Map<String, dynamic> activity) {
    // Handle activity item tap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing: ${activity["title"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleActivityLongPress(Map<String, dynamic> activity) {
    // Show context menu
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _handleActivityTap(activity);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'contact_mail',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Contact User'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/messages');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'assessment',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Generate Report'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating report...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleAddUser() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Add New User',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'add_moderator',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Add Teacher'),
              subtitle: const Text('Create new teacher account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/teacher-dashboard');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Invite Parent'),
              subtitle: const Text('Send invitation to parent'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/parent-dashboard');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'group_add',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Add Staff Member'),
              subtitle: const Text('Create staff account'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Staff creation feature coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metrics Cards
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Overview',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _metricsData.length,
              itemBuilder: (context, index) {
                final metric = _metricsData[index];
                return DashboardMetricsCard(
                  title: metric["title"] as String,
                  value: metric["value"] as String,
                  subtitle: metric["subtitle"] as String,
                  iconName: metric["icon"] as String,
                  backgroundColor: metric["color"] as Color?,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Viewing ${metric["title"]} details'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),

            // Quick Actions
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              height: 14.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _quickActions.length,
                itemBuilder: (context, index) {
                  final action = _quickActions[index];
                  return Container(
                    margin: EdgeInsets.only(right: 3.w),
                    child: QuickActionCard(
                      title: action["title"] as String,
                      iconName: action["icon"] as String,
                      onTap: () =>
                          _handleQuickAction(action["route"] as String),
                    ),
                  );
                },
              ),
            ),

            // Activity Feed
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing all activities'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text(
                      'View All',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _activityFeed.length,
              itemBuilder: (context, index) {
                final activity = _activityFeed[index];
                return ActivityFeedItem(
                  title: activity["title"] as String,
                  description: activity["description"] as String,
                  timestamp: activity["timestamp"] as String,
                  iconName: activity["icon"] as String,
                  iconColor: activity["color"] as Color?,
                  onTap: () => _handleActivityTap(activity),
                  onLongPress: () => _handleActivityLongPress(activity),
                );
              },
            ),
            SizedBox(height: 10.h), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildUsersContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'people',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'User Management',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage teachers, parents, and staff accounts',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'assessment',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Reports & Analytics',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'View attendance reports and system analytics',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'System Settings',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Configure school settings and preferences',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          DashboardHeader(
            schoolName: 'Greenwood Elementary School',
            currentDate: 'Tuesday, August 13, 2025',
            onRefresh: _handleRefresh,
          ),
          DashboardTabBar(
            tabController: _tabController,
            tabs: const ['Dashboard', 'Users', 'Reports', 'Settings'],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardContent(),
                _buildUsersContent(),
                _buildReportsContent(),
                _buildSettingsContent(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddUser,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }
}
