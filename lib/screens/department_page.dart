import 'package:ajce_staff_contacts/screens/faculties_list.dart';
import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/staff_group_crud_operations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  late Map<int, Map<String, dynamic>> departments;
  List<Map<String, dynamic>>? staffGroups;

  @override
  void initState() {
    super.initState();
    departments = DeptCrudOperations().readDepartments();
    _loadStaffGroups();
  }

  Future<void> _loadStaffGroups() async {
    staffGroups =
        StaffGroupCrudOperations().readStaffGroups("college").values.toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromRGBO(236, 241, 244, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: staffGroups == null
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                ),
                itemCount: departments.length + staffGroups!.length,
                itemBuilder: (context, index) {
                  if (index < departments.length) {
                    // Render department item
                    final deptCode = departments.keys.elementAt(index);
                    final dept = departments[deptCode]!;
                    return _buildGridItem(context, size, dept,
                        isDepartment: true);
                  } else {
                    // Render staff group item
                    final groupIndex = index - departments.length;
                    final group = staffGroups![groupIndex];
                    return _buildGridItem(context, size, group,
                        isDepartment: false);
                  }
                },
              ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, Size size, Map<String, dynamic> item,
      {required bool isDepartment}) {
    print(item);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FacultiesList(
                deptData: item,
                isGroup: !isDepartment,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: item[isDepartment ? 'dept_bgimg' : ''] ??
                            "https://ajce.in/home/images/college_small_pic_01.jpg",
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.06),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item[isDepartment ? 'dept_shortName' : 'group_name'] ??
                            "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Text(
                    isDepartment
                        ? "Faculties : ${item['deptshort']}"
                        : "Staff Group",
                    style: TextStyle(fontSize: size.width * 0.03),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: size.width * 0.055,
                      child: isDepartment
                          ? Icon(IconData(
                              int.parse("0x${item['dept_iconCode'] ?? 'e59c'}"),
                              fontFamily: 'MaterialIcons',
                            ))
                          : Image.network(
                              item['group_icon'] ?? '',
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.group),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
