import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

class MoinsenSpeechParent extends StatefulWidget {
  const MoinsenSpeechParent({
    super.key,
    required this.child,
    required this.onSpeechRecognized,
  });

  final Widget child;
  final Function(String) onSpeechRecognized;

  @override
  State<MoinsenSpeechParent> createState() => MoinsenSpeechParentState();
}

class MoinsenSpeechParentState extends State<MoinsenSpeechParent> {
  bool _isListening = false;
  late SpeechToTextProvider speechProvider;

  @override
  void initState() {
    super.initState();

    speechProvider = Provider.of<SpeechToTextProvider>(context);
  }

  Future<void> _startListening() async {
    final SpeechToText speech = SpeechToText();

    if (!_isListening) {
      setState(() => _isListening = true);

      await speech.initialize();

      if (speech.isAvailable) {
        speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              widget.onSpeechRecognized(result.recognizedWords);
            }
          },
        );
      }
    }
  }

  void _stopListening() {
    final SpeechToText speech = SpeechToText();

    if (_isListening) {
      setState(() => _isListening = false);

      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _startListening(),
      onPanEnd: (details) => _stopListening(),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          widget.child,
          if (speechProvider.isAvailable)
            Icon(Icons.mic, color: _isListening ? Colors.red : Colors.grey),
          if (speechProvider.isNotAvailable)
            const Icon(Icons.mic_off, color: Colors.grey),
        ],
      ),
    );
  }
}
