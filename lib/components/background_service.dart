// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:phone_state/phone_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initializeService() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onServiceStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Service Running',
      initialNotificationContent: 'Listening for phone calls',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onServiceStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onServiceStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Get the _showCallerId preference
  final prefs = await SharedPreferences.getInstance();
  bool _showCallerId = prefs.getBool('showCallerId') ?? false;

  // Only request permissions if _showCallerId is true
  if (_showCallerId) {
    SystemAlertWindow.requestPermissions(
        prefMode: SystemWindowPrefMode.OVERLAY);
  }

  PhoneState.stream.listen((event) async {
    String incomingPhoneNumber = "Unknown";

    try {
      switch (event.status) {
        case PhoneStateStatus.CALL_INCOMING:
        case PhoneStateStatus.CALL_STARTED:
          incomingPhoneNumber = event.number ?? "Unknown";

          if (incomingPhoneNumber != "Unknown" && _showCallerId) {
            String cleanedNumber =
                incomingPhoneNumber.replaceAll(RegExp(r'\D'), '');

            try {
              final staffDetails = StaffCrudOperations()
                  .readSpecificStaff(cleanedNumber, "number");

              if (staffDetails.isNotEmpty) {
                final staff = staffDetails.values.first;
                if (staff['staffName'] != null) {
                  showOverlayWindow();
                }
              }
            } catch (e) {
              print("Error retrieving staff details: $e");
            }
          }

          print("Incoming Phone Number: $incomingPhoneNumber");
          break;
        case PhoneStateStatus.CALL_ENDED:
          if (_showCallerId) {
            hideOverlayWindow();
          }
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    } catch (e) {
      print("Error in _listenPhoneState: $e");
    }
  });
}

void showOverlayWindow() async {
  await SystemAlertWindow.showSystemWindow(
    height: 200,
    width: 200,
    gravity: SystemWindowGravity.CENTER,
    prefMode: SystemWindowPrefMode.OVERLAY,
  );
}

void hideOverlayWindow() async {
  await SystemAlertWindow.closeSystemWindow(
      prefMode: SystemWindowPrefMode.OVERLAY);
}
