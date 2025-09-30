import 'package:dar/screens/splash_screen.dart';
import 'package:dar/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SmartHomeState(),
      child: MaterialApp(
        title: 'Smart Home',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'SF Pro Display',
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
