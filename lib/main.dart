import 'package:flutter/material.dart';
import 'package:flutter_prueba_visorus/pages/home.dart';
import 'package:flutter_prueba_visorus/test/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        backgroundColor: colorFondo,
        body: PanelHome(),
      ),
    );
  }
}
