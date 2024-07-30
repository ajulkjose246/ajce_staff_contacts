import 'package:ajce_staff_contacts/provider/favorites_provider.dart';
import 'package:ajce_staff_contacts/components/profile_view_modal.dart';
import 'package:ajce_staff_contacts/components/user_listview.dart';
import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/user_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  String? email = FirebaseAuth.instance.currentUser?.providerData[0].email;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = UserData().readUserData();
    var userDept =
        DeptCrudOperations().getDepartmentByCode(userData['deptCode']);
    print(userDept);
    // Map<int, Map<String, dynamic>> allUserData = UserData().readUserData();
    // print('All User Data: $allUserData');
    var favStaff = Provider.of<FavoritesProvider>(context).favoriteContactIds;
    Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromRGBO(236, 241, 244, 1),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Class Timetable ( Today )",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          "1",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "2",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "3",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "4",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "5",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "6",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "7",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "8",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Exam Duties ( Week )",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          "Mon",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Tue",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Wed",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Thu",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Fri",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Sat",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                favStaff.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Favorites",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                      )
                    : Container(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: List.generate(favStaff.length, (index) {
                        var staffData = StaffCrudOperations()
                            .readSpecificStaff(favStaff[index], 'staff')
                            .values
                            .toList();
                        return GestureDetector(
                          onTap: () {
                            ProfileView(context, staffData);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: staffData[0]['photo'] ?? "",
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${userDept?['deptshort']} Contacts",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: StaffCrudOperations()
                      .readSpecificStaff(userDept?['deptCode'], 'dept')
                      .length,
                  itemBuilder: (context, index) {
                    var staffData = StaffCrudOperations()
                        .readSpecificStaff(userDept?['deptCode'], 'dept')
                        .values
                        .toList()[index];
                    return UserListview(
                      staffCode: staffData['staffCode'],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
