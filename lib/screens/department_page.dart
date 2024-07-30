import 'package:ajce_staff_contacts/screens/faculties_list.dart';
import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  late Map<int, Map<String, dynamic>> departments;

  @override
  Widget build(BuildContext context) {
    setState(() {
      departments = DeptCrudOperations().readDepartments();
    });
    Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromRGBO(236, 241, 244, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final deptCode = departments.keys.elementAt(index);
            final dept = departments[deptCode]!;
            return Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacultiesList(
                        deptData: dept,
                        isGroup: false,
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
                                imageUrl: dept['dept_bgimg'] ?? "",
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.06),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                dept['dept_shortName'] ?? "",
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
                            "Faculties : ${dept['deptshort']}",
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
                                child: Icon(IconData(
                                    int.parse("0x${dept['dept_iconCode']}"),
                                    fontFamily: 'MaterialIcons'))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
