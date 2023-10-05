import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MoinsenSpeechApp extends StatefulWidget {
  const MoinsenSpeechApp({
    super.key,
    required this.child,
    this.localeId,
  });

  final Widget child;
  final String? localeId;

  @override
  State<MoinsenSpeechApp> createState() => MoinsenSpeechAppState();
}

class MoinsenSpeechAppState extends State<MoinsenSpeechApp> {
  final SpeechToText speech = SpeechToText();

  bool initDone = false;

  Future<bool> initMoinsenSpeech() async {
    await speech.initialize();

    initDone = true;

    return initDone;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initMoinsenSpeech(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.child;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
