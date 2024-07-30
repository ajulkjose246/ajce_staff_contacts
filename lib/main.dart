import 'package:ajce_staff_contacts/firebase_options.dart';
import 'package:ajce_staff_contacts/provider/favorites_provider.dart';
import 'package:ajce_staff_contacts/authentication/auth_page.dart';
import 'package:ajce_staff_contacts/screens/container_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('staffDataBox');
  await Hive.openBox('staffGroupDataBox');
  await Hive.openBox('deptDataBox');
  await Hive.openBox('userDataBox');
  await Hive.openBox('favoriteStaff');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
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
        '/': (context) => ContainerPage(),
        '/auth': (context) => AuthPage(),
      },
      initialRoute: '/auth',
    );
  }
}
