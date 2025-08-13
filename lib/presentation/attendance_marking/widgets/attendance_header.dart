import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AttendanceHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onDateTap;
  final VoidCallback onMarkAllPresent;
  final VoidCallback onMarkAllAbsent;
  final int totalStudents;
  final int presentCount;

  const AttendanceHeader({
    Key? key,
    required this.selectedDate,
    required this.onDateTap,
    required this.onMarkAllPresent,
    required this.onMarkAllAbsent,
    required this.totalStudents,
    required this.presentCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date Selection Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onDateTap,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Attendance Summary
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem(
                  'Total',
                  totalStudents.toString(),
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                _buildSummaryItem(
                  'Present',
                  presentCount.toString(),
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                _buildSummaryItem(
                  'Absent',
                  (totalStudents - presentCount).toString(),
                  AppTheme.lightTheme.colorScheme.error,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Bulk Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onMarkAllPresent,
                  icon: CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    'Mark All Present',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMarkAllAbsent,
                  icon: CustomIconWidget(
                    iconName: 'cancel',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 18,
                  ),
                  label: Text(
                    'Mark All Absent',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
