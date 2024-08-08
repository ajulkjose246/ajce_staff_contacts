import 'dart:async';
import 'dart:ui';
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

  PhoneState.stream.listen((event) {
    switch (event.status) {
      case PhoneStateStatus.CALL_INCOMING:
      case PhoneStateStatus.CALL_STARTED:
        showOverlayWindow();
        break;
      case PhoneStateStatus.CALL_ENDED:
        hideOverlayWindow();
        break;
      case PhoneStateStatus.NOTHING:
        break;
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
