import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../models/lesson.dart';
import '../../../theme/app_theme.dart';

class RecentLessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const RecentLessonCard({
    Key? key,
    required this.lesson,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 8,
                      spreadRadius: 1),
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                // Subject Icon
                Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        color: _getSubjectColor(lesson.subject).withAlpha(26),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(_getSubjectIcon(lesson.subject),
                        color: _getSubjectColor(lesson.subject), size: 20)),
                SizedBox(width: 3.w),

                // Lesson Info
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(lesson.subject,
                          style: GoogleFonts.inter(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                      Text(_formatDate(lesson.date),
                          style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400)),
                    ])),

                // Attachment Indicator
                if (lesson.attachments?.isNotEmpty == true)
                  Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100, shape: BoxShape.circle),
                      child: Icon(Icons.attachment,
                          size: 16, color: Colors.blue.shade700)),
              ]),

              SizedBox(height: 2.h),

              // Lesson Content Preview
              Text(
                  lesson.content.length > 100
                      ? '${lesson.content.substring(0, 100)}...'
                      : lesson.content,
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, color: Colors.grey[700], height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),

              if (lesson.attachments?.isNotEmpty == true) ...[
                SizedBox(height: 2.h),
                Row(children: [
                  Icon(Icons.attachment, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 1.w),
                  Text(
                      '${lesson.attachments!.length} attachment${lesson.attachments!.length > 1 ? 's' : ''}',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp, color: Colors.grey[600])),
                ]),
              ],
            ])));
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'math':
        return Colors.blue;
      case 'science':
        return Colors.green;
      case 'english':
        return Colors.red;
      case 'history':
        return Colors.brown;
      case 'geography':
        return Colors.teal;
      case 'art':
        return Colors.purple;
      case 'music':
        return Colors.pink;
      case 'physical education':
      case 'pe':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'math':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'english':
        return Icons.book;
      case 'history':
        return Icons.history_edu;
      case 'geography':
        return Icons.public;
      case 'art':
        return Icons.palette;
      case 'music':
        return Icons.music_note;
      case 'physical education':
      case 'pe':
        return Icons.sports;
      default:
        return Icons.subject;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lessonDate = DateTime(date.year, date.month, date.day);

    if (lessonDate == today) {
      return 'Today';
    } else if (lessonDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday';
    } else if (now.difference(lessonDate).inDays < 7) {
      return '${now.difference(lessonDate).inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}