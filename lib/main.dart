import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csmkatalog/firebase_options.dart';
import 'package:csmkatalog/screens/catalog_screen.dart';
import 'package:csmkatalog/screens/admin/admin_screen.dart';
import 'package:csmkatalog/screens/sales/sales_screen.dart';

class MouseTooScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MouseTooScrollBehavior(),
      title: 'Katalog CSM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      // home: const CatalogScreen(),
      home: const AdminScreen(),
      // home: const SalesScreen(),
    );
  }
}