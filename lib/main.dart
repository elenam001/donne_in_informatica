import 'package:donne_e_informatica/view/navigation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Per il supporto Web

void main() {
  // Inizializza il database per le piattaforme desktop
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit(); // Inizializza Sqflite FFI per desktop
    databaseFactory = databaseFactoryFfi; // Imposta databaseFactory per desktop
  }

  // Inizializza il database per il Web
  if (kIsWeb) {
    databaseFactory =
        databaseFactoryFfiWeb; // Imposta databaseFactory per il Web
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donne e Informatica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Navigation(),
    );
  }
}
