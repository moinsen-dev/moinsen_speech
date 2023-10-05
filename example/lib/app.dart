import 'package:flutter/material.dart';
import 'package:moinsen_speech/moinsen_speech.dart';

import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moinsen Speech Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MoinsenSpeechApp(
        child: MyHomePage(title: 'Moinsen Speech Demo'),
      ),
    );
  }
}
