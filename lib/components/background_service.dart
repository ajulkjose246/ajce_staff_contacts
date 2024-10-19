// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:phone_state/phone_state.dart';

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

  SystemAlertWindow.requestPermissions(prefMode: SystemWindowPrefMode.OVERLAY);

  PhoneState.stream.listen((event) async {
    String incomingPhoneNumber = "Unknown"; // To store the phone number

    try {
      switch (event.status) {
        case PhoneStateStatus.CALL_INCOMING:
        case PhoneStateStatus.CALL_STARTED:
          incomingPhoneNumber = event.number ?? "Unknown";

          if (incomingPhoneNumber != "Unknown") {
            String cleanedNumber =
                incomingPhoneNumber.replaceAll(RegExp(r'\D'), '');

            try {
              final staffDetails = StaffCrudOperations()
                  .readSpecificStaff(cleanedNumber, "number");

              if (staffDetails.isNotEmpty) {
                final staff = staffDetails.values.first;
                if (staff['staffName'] != null) {
                  showOverlayWindow();
                } else {
                  hideOverlayWindow();
                }
              } else {
                hideOverlayWindow();
                print("No staff found with this number");
              }
            } catch (e) {
              print("Error retrieving staff details: $e");
            }
          }

          print("Incoming Phone Number: $incomingPhoneNumber");
          break;
        case PhoneStateStatus.CALL_ENDED:
          hideOverlayWindow();
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    } catch (e) {
      hideOverlayWindow();
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
