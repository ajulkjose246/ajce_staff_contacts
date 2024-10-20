import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:ajce_staff_contacts/components/custom_overlay.dart';
import 'package:ajce_staff_contacts/components/request_permissions.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'firebase_options.dart';
import 'provider/favorites_provider.dart';
import 'authentication/auth_page.dart';
import 'screens/container_page.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('staffDataBox');
  await Hive.openBox('staffGroupDataBox');
  await Hive.openBox('deptDataBox');
  await Hive.openBox('userDataBox');
  await Hive.openBox('favoriteStaff');
  await Hive.openBox('studentsDataBox');
  await initializeService();
  requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

@pragma("vm:entry-point")
Future<void> overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('staffDataBox');
  await Hive.openBox('staffGroupDataBox');
  await Hive.openBox('deptDataBox');
  await Hive.openBox('userDataBox');
  await Hive.openBox('favoriteStaff');
  await Hive.openBox('studentsDataBox');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrueCallerOverlay(),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  service.on('showOverlay').listen((event) {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      MaterialApp(
        home: TrueCallerOverlay(),
      ),
    );
  });

  PhoneState.stream.listen((event) async {
    String incomingPhoneNumber = "Unknown";
    bool showCallerId = prefs.getBool('showCallerId') ?? false;

    if (!showCallerId) {
      return; // Exit early if showCallerId is false
    }

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
                  await SystemAlertWindow.showSystemWindow(
                    height: 200,
                    width: 200,
                    gravity: SystemWindowGravity.CENTER,
                    prefMode: SystemWindowPrefMode.OVERLAY,
                  );
                }
              } else {
                print("No staff found with this number");
              }
            } catch (e) {
              print("Error retrieving staff details: $e");
            }
          }

          print("Incoming Phone Number: $incomingPhoneNumber");
          break;
        case PhoneStateStatus.CALL_ENDED:
          await SystemAlertWindow.closeSystemWindow(
              prefMode: SystemWindowPrefMode.OVERLAY);
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    } catch (e) {
      await SystemAlertWindow.closeSystemWindow(
          prefMode: SystemWindowPrefMode.OVERLAY);
      print("Error in _listenPhoneState: $e");
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const ContainerPage(),
        '/auth': (context) => const AuthPage(),
      },
      initialRoute: '/auth',
    );
  }
}
