import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/student.dart';

class ChildCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const ChildCard({
    Key? key,
    required this.student,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 35.w,
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
              SizedBox(height: 2.h),
              // Student Photo
              Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: student.photoUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                              imageUrl: student.photoUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.child_care, size: 30)))
                      : Icon(Icons.child_care, size: 30)),
              SizedBox(height: 1.h),

              // Student Name
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(student.firstName,
                      style: GoogleFonts.inter(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),

              // Grade/Class Info
              Text(student.classId != null ? 'Class' : 'Not Assigned',
                  style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400)),

              Spacer(),

              // Status Indicator
              Container(
                  margin: EdgeInsets.all(2.w),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: student.isActive
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: student.isActive
                                ? Colors.green
                                : Colors.orange)),
                    SizedBox(width: 1.w),
                    Text(student.isActive ? 'Active' : 'Inactive',
                        style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: student.isActive
                                ? Colors.green.shade800
                                : Colors.orange.shade800)),
                  ])),
            ])));
  }
}
