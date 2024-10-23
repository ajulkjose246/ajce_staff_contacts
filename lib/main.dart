import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
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
  await Hive.openBox('studentsDataBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
