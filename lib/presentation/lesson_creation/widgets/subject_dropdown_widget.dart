import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectDropdownWidget extends StatefulWidget {
  final String? selectedSubject;
  final Function(String?) onSubjectChanged;
  final List<String> subjects;

  const SubjectDropdownWidget({
    Key? key,
    required this.selectedSubject,
    required this.onSubjectChanged,
    required this.subjects,
  }) : super(key: key);

  @override
  State<SubjectDropdownWidget> createState() => _SubjectDropdownWidgetState();
}

class _SubjectDropdownWidgetState extends State<SubjectDropdownWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredSubjects = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredSubjects = widget.subjects;
  }

  void _filterSubjects(String query) {
    setState(() {
      _filteredSubjects = widget.subjects
          .where(
              (subject) => subject.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isDropdownOpen = !_isDropdownOpen;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.selectedSubject ?? 'Select Subject',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: widget.selectedSubject != null
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      CustomIconWidget(
                        iconName: _isDropdownOpen
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isDropdownOpen) ...[
                Divider(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterSubjects,
                    decoration: InputDecoration(
                      hintText: 'Search subjects...',
                      prefixIcon: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 25.h),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = _filteredSubjects[index];
                      return InkWell(
                        onTap: () {
                          widget.onSubjectChanged(subject);
                          _searchController.clear();
                          _filteredSubjects = widget.subjects;
                          setState(() {
                            _isDropdownOpen = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.5.h),
                          child: Text(
                            subject,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: subject == widget.selectedSubject
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: subject == widget.selectedSubject
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
