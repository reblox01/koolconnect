import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VisibilityToggleWidget extends StatefulWidget {
  final bool isVisibleToParents;
  final Function(bool) onVisibilityChanged;

  const VisibilityToggleWidget({
    Key? key,
    required this.isVisibleToParents,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityToggleWidget> createState() => _VisibilityToggleWidgetState();
}

class _VisibilityToggleWidgetState extends State<VisibilityToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visibility',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: widget.isVisibleToParents
                        ? 'visibility'
                        : 'visibility_off',
                    color: widget.isVisibleToParents
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isVisibleToParents
                              ? 'Visible to Parents'
                              : 'Teachers Only',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.isVisibleToParents
                              ? 'Parents can view this lesson and attachments'
                              : 'Only teachers and staff can access this lesson',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.isVisibleToParents,
                    onChanged: (value) {
                      widget.onVisibilityChanged(value);
                      setState(() {});
                    },
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                    inactiveThumbColor:
                        AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    inactiveTrackColor:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: widget.isVisibleToParents
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3)
                      : AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: widget.isVisibleToParents ? 'group' : 'school',
                      color: widget.isVisibleToParents
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        widget.isVisibleToParents
                            ? 'This lesson will appear in parent dashboards and notifications will be sent'
                            : 'This lesson is for internal use and won\'t be shared with parents',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: widget.isVisibleToParents
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
