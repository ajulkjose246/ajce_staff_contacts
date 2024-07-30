import 'package:ajce_staff_contacts/hive/staff_group_crud_operations.dart';
import 'package:ajce_staff_contacts/screens/faculties_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StaffGroups extends StatefulWidget {
  const StaffGroups({super.key});

  @override
  State<StaffGroups> createState() => _StaffGroupsState();
}

class _StaffGroupsState extends State<StaffGroups> {
  @override
  Widget build(BuildContext context) {
    // var staffData = StaffCrudOperations()
    //     .readSpecificStaff(widget.staffCode, 'staff')
    //     .values
    //     .toList();
    var staffGroup =
        StaffGroupCrudOperations().readStaffGroups().values.toList();
    return Container(
      color: const Color.fromRGBO(236, 241, 244, 1),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: staffGroup.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FacultiesList(
                            deptData: staffGroup[index],
                            isGroup: true,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CachedNetworkImage(
                                        imageUrl: staffGroup[index]
                                            ['group_icon']),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    staffGroup[index]['group_name'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
