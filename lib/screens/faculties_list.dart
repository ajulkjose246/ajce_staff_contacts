// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ajce_staff_contacts/components/staff_listview.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:flutter/material.dart';

class FacultiesList extends StatefulWidget {
  final deptData;
  final bool isGroup;
  const FacultiesList(
      {super.key, required this.deptData, required this.isGroup});

  @override
  State<FacultiesList> createState() => _FacultiesListState();
}

class _FacultiesListState extends State<FacultiesList> {
  @override
  Widget build(BuildContext context) {
    var staffData;
    List staffCode = [];
    if (widget.isGroup) {
      staffData = widget.deptData;
      staffCode = staffData['group_faculties'].split(',');
    } else {
      staffData = StaffCrudOperations()
          .readSpecificStaff(widget.deptData['deptCode'], 'dept')
          .values
          .toList();
    }

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
          '${widget.isGroup ? staffData['group_name'] : widget.deptData['dept_shortName']}',
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
            itemCount: widget.isGroup ? staffCode.length : staffData.length,
            itemBuilder: (context, index) {
              return widget.isGroup
                  ? StaffListview(
                      staffCode: int.parse(staffCode[index]),
                    )
                  : StaffListview(
                      staffCode: staffData[index]['staffCode'],
                    );
            },
          ),
        ),
      ),
    );
  }
}
