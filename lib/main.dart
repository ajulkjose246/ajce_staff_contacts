import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:ajce_staff_contacts/components/custom_overlay.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'firebase_options.dart';
import 'provider/favorites_provider.dart';
import 'authentication/auth_page.dart';
import 'screens/container_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('staffDataBox');
  await Hive.openBox('staffGroupDataBox');
  await Hive.openBox('deptDataBox');
  await Hive.openBox('userDataBox');
  await Hive.openBox('favoriteStaff');
  await initializeService();

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
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrueCallerOverlay(),
    ),
  );
}

Future<void> requestPermissions() async {
  var status = await Permission.location.status;
  await Permission.phone.request();
  await Permission.systemAlertWindow.request();
  // await Permission.ignoreBatteryOptimizations.request();
  if (!status.isGranted) {
    await Permission.location.request();
  }
  var statusL = await Permission.phone.status;
  if (!statusL.isGranted) {
    await Permission.phone.request();
  }
}

Future<void> initializeService() async {
  requestPermissions();
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
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    DartPluginRegistrant.ensureInitialized();

    PhoneState.stream.listen((event) {
      final double screenWidth = WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.width /
          WidgetsBinding
              .instance.platformDispatcher.views.first.devicePixelRatio;
      SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
      switch (event.status) {
        case PhoneStateStatus.CALL_INCOMING:
        case PhoneStateStatus.CALL_STARTED:
          SystemAlertWindow.showSystemWindow(
            height: 200,
            width: screenWidth.floor(),
            gravity: SystemWindowGravity.CENTER,
            prefMode: prefMode,
          );
          break;
        case PhoneStateStatus.CALL_ENDED:
          SystemAlertWindow.closeSystemWindow();
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    });
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

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await Future.delayed(Duration(seconds: 2));
  DartPluginRegistrant.ensureInitialized();
  // await SystemAlertWindow.requestPermissions(
  //     prefMode: SystemWindowPrefMode.OVERLAY);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
      const MaterialApp(
        home: TrueCallerOverlay(),
      ),
    );
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );
      }
    }

    PhoneState.stream.listen((event) {
      final double screenWidth = WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.width /
          WidgetsBinding
              .instance.platformDispatcher.views.first.devicePixelRatio;
      SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
      switch (event.status) {
        case PhoneStateStatus.CALL_INCOMING:
        case PhoneStateStatus.CALL_STARTED:
          SystemAlertWindow.showSystemWindow(
            height: 200,
            width: screenWidth.floor(),
            gravity: SystemWindowGravity.CENTER,
            prefMode: prefMode,
          );
          break;
        case PhoneStateStatus.CALL_ENDED:
          SystemAlertWindow.closeSystemWindow();
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    });

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
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
