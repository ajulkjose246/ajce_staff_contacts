import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // Request permissions for notifications
  var statusNotification = await Permission.notification.status;
  if (!statusNotification.isGranted) {
    await Permission.notification.request();
  }

  // Request permissions for drawing over other apps
  var statusDrawOverApps = await Permission.systemAlertWindow.status;
  if (!statusDrawOverApps.isGranted) {
    await Permission.systemAlertWindow.request();
  }

  // Request permissions for ignoring battery optimizations
  var statusIgnoreBattery = await Permission.ignoreBatteryOptimizations.status;
  if (!statusIgnoreBattery.isGranted) {
    await Permission.ignoreBatteryOptimizations.request();
  }

  // Request permissions for location
  var statusLocation = await Permission.location.status;
  if (!statusLocation.isGranted) {
    await Permission.location.request();
  }

  // Request permissions for phone state
  var statusPhone = await Permission.phone.status;
  if (!statusPhone.isGranted) {
    await Permission.phone.request();
  }
}
