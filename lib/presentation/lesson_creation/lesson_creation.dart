import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/file_attachment_widget.dart';
import './widgets/lesson_content_widget.dart';
import './widgets/subject_dropdown_widget.dart';
import './widgets/visibility_toggle_widget.dart';

class LessonCreation extends StatefulWidget {
  const LessonCreation({Key? key}) : super(key: key);

  @override
  State<LessonCreation> createState() => _LessonCreationState();
}

class _LessonCreationState extends State<LessonCreation> {
  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _selectedSubject;
  DateTime _selectedDateTime = DateTime.now();
  bool _isVisibleToParents = true;
  List<Map<String, dynamic>> _attachedFiles = [];
  bool _isDraftSaved = false;
  bool _isPosting = false;

  // Mock data for teacher's subjects
  final List<String> _teacherSubjects = [
    'Mathematics',
    'English Language Arts',
    'Science',
    'Social Studies',
    'Art',
    'Physical Education',
    'Music',
    'Computer Science',
    'Spanish',
    'Reading',
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _contentController.addListener(_onContentChanged);
  }

  void _loadDraft() {
    // Simulate loading draft from local storage
    // In real implementation, this would load from SharedPreferences or local database
  }

  void _onContentChanged() {
    if (!_isDraftSaved) {
      _saveDraft();
    }
  }

  void _saveDraft() {
    setState(() {
      _isDraftSaved = true;
    });

    // Auto-save after 2 seconds of inactivity
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isDraftSaved = false;
        });
      }
    });
  }

  bool _canPost() {
    return _selectedSubject != null &&
        _contentController.text.trim().isNotEmpty;
  }

  Future<void> _postLesson() async {
    if (!_canPost()) return;

    setState(() {
      _isPosting = true;
    });

    try {
      // Simulate posting lesson
      await Future.delayed(Duration(seconds: 2));

      // Haptic feedback for success
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text('Lesson posted successfully!'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back to teacher dashboard
      Navigator.pushReplacementNamed(context, '/teacher-dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post lesson. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  void _cancelCreation() {
    if (_selectedSubject != null ||
        _contentController.text.trim().isNotEmpty ||
        _attachedFiles.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Discard Changes?'),
          content: Text(
              'You have unsaved changes. Are you sure you want to cancel?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Discard'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _onFileAdded(Map<String, dynamic> file) {
    setState(() {
      _attachedFiles.add(file);
    });
    _saveDraft();
  }

  void _onFileRemoved(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
    _saveDraft();

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File removed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Lesson'),
        leading: IconButton(
          onPressed: _cancelCreation,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          if (_isDraftSaved)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'cloud_done',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Saved',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: TextButton(
              onPressed: _canPost() && !_isPosting ? _postLesson : null,
              child: _isPosting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Post',
                      style: TextStyle(
                        color: _canPost()
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: TextButton.styleFrom(
                backgroundColor: _canPost()
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.5),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refreshing subject list
            await Future.delayed(Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Selection
                SubjectDropdownWidget(
                  selectedSubject: _selectedSubject,
                  onSubjectChanged: (subject) {
                    setState(() {
                      _selectedSubject = subject;
                    });
                    _saveDraft();
                  },
                  subjects: _teacherSubjects,
                ),

                SizedBox(height: 3.h),

                // Lesson Content
                LessonContentWidget(
                  contentController: _contentController,
                  onContentChanged: (content) {
                    _saveDraft();
                  },
                ),

                SizedBox(height: 3.h),

                // File Attachments
                FileAttachmentWidget(
                  attachedFiles: _attachedFiles,
                  onFileAdded: _onFileAdded,
                  onFileRemoved: _onFileRemoved,
                ),

                SizedBox(height: 3.h),

                // Date and Time Picker
                DateTimePickerWidget(
                  selectedDateTime: _selectedDateTime,
                  onDateTimeChanged: (dateTime) {
                    setState(() {
                      _selectedDateTime = dateTime;
                    });
                    _saveDraft();
                  },
                ),

                SizedBox(height: 3.h),

                // Visibility Toggle
                VisibilityToggleWidget(
                  isVisibleToParents: _isVisibleToParents,
                  onVisibilityChanged: (isVisible) {
                    setState(() {
                      _isVisibleToParents = isVisible;
                    });
                    _saveDraft();
                  },
                ),

                SizedBox(height: 4.h),

                // Post Button (Mobile)
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canPost() && !_isPosting ? _postLesson : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canPost()
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.5),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: _isPosting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Posting Lesson...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'send',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Post Lesson',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
