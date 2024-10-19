// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ajce_staff_contacts/components/student_listview.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  final studentsList;
  final String batchName;
  const StudentList(
      {super.key, required this.batchName, required this.studentsList});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    // print(widget.studentsList);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromRGBO(137, 14, 79, 1),
        elevation: 20,
        title: Text(
          widget.batchName,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: size.width * 0.04),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(236, 241, 244, 1),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: widget.studentsList.length,
            itemBuilder: (context, index) {
              return StudentListview(
                  studentCode: widget.studentsList[index].toString());
            },
          ),
        ),
      ),
    );
  }
}
