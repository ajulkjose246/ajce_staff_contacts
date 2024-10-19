// ignore_for_file: avoid_print

import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({Key? key}) : super(key: key);

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  bool isGold = true;

  final _goldColors = const [
    Color(0xFFa2790d),
    Color(0xFFebd197),
    Color(0xFFa2790d),
  ];

  final _silverColors = const [
    Color(0xFFAEB2B8),
    Color(0xFFC7C9CB),
    Color(0xFFD7D7D8),
    Color(0xFFAEB2B8),
  ];

  bool _isShowingWindow = false;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;

  String _incomingPhoneNumber = "Unknown"; // To store the phone number
  String _staffName = "Unknown"; // To store the staff name
  String _staffDepartment = "Unknown"; // To store the staff department
  String _staffDesignation = "Unknown"; // To store the staff department
  String _staffImage =
      "https://api.multiavatar.com/x-slayer.png"; // To store the staff department

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _listenPhoneState();
  }

  void _listenPhoneState() {
    PhoneState.stream.listen((event) async {
      try {
        switch (event.status) {
          case PhoneStateStatus.CALL_INCOMING:
          case PhoneStateStatus.CALL_STARTED:
            _incomingPhoneNumber = event.number ?? "Unknown";

            if (_incomingPhoneNumber != "Unknown") {
              String cleanedNumber =
                  _incomingPhoneNumber.replaceAll(RegExp(r'\D'), '');

              try {
                final staffDetails = StaffCrudOperations()
                    .readSpecificStaff(cleanedNumber, "number");

                if (staffDetails.isNotEmpty) {
                  final staff = staffDetails.values.first;
                  final deptDetails = DeptCrudOperations()
                      .getDepartmentByCode(staff['deptCode']);

                  setState(() {
                    _staffName = staff['staffName'] ?? "Unknown";
                    _staffDepartment = deptDetails!['deptName'].toString();
                    _staffImage = staff['photo'] ?? "Unknown";
                    _staffDesignation = staff['designation'] ?? "Unknown";
                  });

                  if (_staffName != "Unknown") {
                    _showOverlayWindow(_incomingPhoneNumber);
                  } else {
                    _hideOverlayWindow();
                  }
                } else {
                  _hideOverlayWindow();
                  print("No staff found with this number");
                }
              } catch (e) {
                _hideOverlayWindow();
                print("Error retrieving staff details: $e");
              }
            } else {
              _hideOverlayWindow();
            }

            print("Incoming Phone Number: $_incomingPhoneNumber");
            break;

          case PhoneStateStatus.CALL_ENDED:
            _hideOverlayWindow();
            break;

          case PhoneStateStatus.NOTHING:
            break;
        }
      } catch (e) {
        _hideOverlayWindow();
        print("Error in _listenPhoneState: $e");
      }
    });
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow(String phoneNumber) async {
    if (!_isShowingWindow) {
      SystemAlertWindow.showSystemWindow(
        height: 200,
        width: MediaQuery.of(context).size.width.floor(),
        gravity: SystemWindowGravity.CENTER,
        prefMode: prefMode,
        notificationBody: phoneNumber,
      );
      setState(() {
        _isShowingWindow = true;
      });
    } else {
      Fluttertoast.showToast(msg: "not showing");
    }
  }

  void _hideOverlayWindow() async {
    if (_isShowingWindow) {
      setState(() {
        _isShowingWindow = false;
      });
      await SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
      SystemAlertWindow.disposeOverlayListener();
    }
  }

  @override
  void dispose() {
    SystemAlertWindow.removeOnClickListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isGold ? _goldColors : _silverColors,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isGold = !isGold;
              });
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip
                            .hardEdge, // Ensures the image is clipped to the circular shape
                        child: CachedNetworkImage(
                          imageUrl: _staffImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      title: Text(
                        _staffName, // Display the staff name
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_staffDepartment),
                          Text(_staffDesignation),
                        ],
                      ), // Display the department
                    ),
                    const Spacer(),
                    const Divider(color: Colors.black54),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    _incomingPhoneNumber), // Display the phone number
                              ],
                            ),
                          ),
                          const Text(
                            "Ajce Staff Contacts",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      _hideOverlayWindow(); // This will close the overlay window
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
