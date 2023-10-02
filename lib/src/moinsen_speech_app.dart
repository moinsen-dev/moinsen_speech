import 'package:flutter/material.dart';
import 'package:moinsen_speech/moinsen_speech.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

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
  late SpeechToTextProvider speechProvider;
  String currentLocaleId = '';

  bool initDone = false;

  void setCurrentLocale() {
    if (speechProvider.isAvailable && currentLocaleId.isEmpty) {
      currentLocaleId = speechProvider.systemLocale?.localeId ?? '';
    }
  }

  Future<bool> initMoinsenSpeech() async {
    speechProvider = SpeechToTextProvider(speech);

    initDone = await speechProvider.initialize();
    await speech.initialize();

    return initDone;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initMoinsenSpeech(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (speechProvider.isAvailable) {
            setCurrentLocale();

            return ChangeNotifierProvider<SpeechToTextProvider>.value(
              value: speechProvider,
              child: widget.child,
            );
          }

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
