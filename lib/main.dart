import 'package:flutter/material.dart';
import 'package:tetris/feature/game/main.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: const Scaffold(body: GameMain()),
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      );
}
