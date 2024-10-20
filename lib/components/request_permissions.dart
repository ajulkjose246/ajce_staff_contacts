import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> requestPermissions() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool showCallerId = prefs.getBool('showCallerId') ?? false;

  await Permission.phone.request();
  await Permission.contacts.request();

  if (showCallerId) {
    await Permission.systemAlertWindow.request();
  }
}
