import 'package:ajce_staff_contacts/components/staff_profile_view_modal.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StaffListview extends StatefulWidget {
  final int staffCode;
  const StaffListview({super.key, required this.staffCode});

  @override
  State<StaffListview> createState() => _StaffListviewState();
}

class _StaffListviewState extends State<StaffListview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var staffData = StaffCrudOperations()
        .readSpecificStaff(widget.staffCode, 'staff')
        .values
        .toList();

    return GestureDetector(
      onTap: () {
        StaffProfileView(context, staffData);
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
                      imageUrl: staffData[0]['photo'] ?? "",
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                      "${staffData[0]['staffName']}",
                      style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Text(
                      "${staffData[0]['designation']}",
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
