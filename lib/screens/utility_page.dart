import 'dart:io';

import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

class UtilityPage extends StatefulWidget {
  const UtilityPage({super.key});

  @override
  State<UtilityPage> createState() => _UtilityPageState();
}

class _UtilityPageState extends State<UtilityPage> {
  PhoneState status = PhoneState.nothing();
  bool granted = false;

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) setStream();
  }

  void setStream() {
    PhoneState.stream.listen((event) {
      setState(() {
        status = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(StaffCrudOperations()
        .readSpecificStaff('binumonjosephk@amaljyothi.ac.in', 'user'));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (Platform.isAndroid)
            MaterialButton(
              onPressed: !granted
                  ? () async {
                      bool temp = await requestPermission();
                      setState(() {
                        granted = temp;
                        if (granted) {
                          setStream();
                        }
                      });
                    }
                  : null,
              child: const Text('Request permission of Phone'),
            ),
          const Text(
            'Status of call',
            style: TextStyle(fontSize: 24),
          ),
          if (status.status == PhoneStateStatus.CALL_INCOMING ||
              status.status == PhoneStateStatus.CALL_STARTED)
            Text(
              'Number: ${status.number}',
              style: const TextStyle(fontSize: 24),
            ),
        ],
      ),
    );
  }
}
