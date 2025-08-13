import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AbsenceReasonBottomSheet extends StatefulWidget {
  final String studentName;
  final String? currentReason;
  final Function(String reason) onReasonSelected;

  const AbsenceReasonBottomSheet({
    Key? key,
    required this.studentName,
    this.currentReason,
    required this.onReasonSelected,
  }) : super(key: key);

  @override
  State<AbsenceReasonBottomSheet> createState() =>
      _AbsenceReasonBottomSheetState();
}

class _AbsenceReasonBottomSheetState extends State<AbsenceReasonBottomSheet> {
  String? selectedReason;
  final TextEditingController customReasonController = TextEditingController();

  final List<String> predefinedReasons = [
    'Sick',
    'Family Emergency',
    'Medical Appointment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    selectedReason = widget.currentReason;
    if (selectedReason != null && !predefinedReasons.contains(selectedReason)) {
      customReasonController.text = selectedReason!;
      selectedReason = 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            'Absence Reason for ${widget.studentName}',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 3.h),

          // Predefined Reasons
          Text(
            'Select a reason:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2.h),

          ...predefinedReasons.map((reason) => _buildReasonOption(reason)),

          // Custom Reason Input
          if (selectedReason == 'Other') ...[
            SizedBox(height: 2.h),
            TextField(
              controller: customReasonController,
              decoration: InputDecoration(
                labelText: 'Custom reason',
                hintText: 'Enter custom absence reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),
          ],

          SizedBox(height: 4.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveReason,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildReasonOption(String reason) {
    final isSelected = selectedReason == reason;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReason = reason;
          if (reason != 'Other') {
            customReasonController.clear();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: isSelected
                  ? 'radio_button_checked'
                  : 'radio_button_unchecked',
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              reason,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveReason() {
    String finalReason = '';

    if (selectedReason == 'Other') {
      finalReason = customReasonController.text.trim();
      if (finalReason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a custom reason'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else if (selectedReason != null) {
      finalReason = selectedReason!;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onReasonSelected(finalReason);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    customReasonController.dispose();
    super.dispose();
  }
}
