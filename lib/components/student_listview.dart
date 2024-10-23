import 'package:ajce_staff_contacts/components/error_image.dart';
import 'package:ajce_staff_contacts/components/student_profile_view_modal.dart';
import 'package:ajce_staff_contacts/hive/students_crud_operations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StudentListview extends StatefulWidget {
  final String studentCode;
  const StudentListview({super.key, required this.studentCode});

  @override
  State<StudentListview> createState() => _StudentListviewState();
}

class _StudentListviewState extends State<StudentListview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var studentData =
        StudentCrudOperations().readSpecificStudentById(widget.studentCode);

    return GestureDetector(
      onTap: () {
        StudentProfileView(context, studentData);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: studentData!['student_photo'] ?? "",
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) {
                        final studentName =
                            studentData['student_name'] ?? 'Unknown';
                        final firstLetter = studentName.isNotEmpty
                            ? studentName[0].toUpperCase()
                            : '?';
                        return ErrorImage(
                          firstLetter: firstLetter,
                        );
                      },
                      errorWidget: (context, url, error) {
                        final studentName =
                            studentData['student_name'] ?? 'Unknown';
                        final firstLetter = studentName.isNotEmpty
                            ? studentName[0].toUpperCase()
                            : '?';
                        return ErrorImage(
                          firstLetter: firstLetter,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${studentData['student_name']}",
                      style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Text(
                      "${widget.studentCode} ( ${studentData['student_type']} ) ",
                      style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Icon(Icons.keyboard_arrow_right),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
