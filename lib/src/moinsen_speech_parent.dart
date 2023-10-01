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
  final Function(String?) onSpeechRecognized;

  @override
  State<MoinsenSpeechParent> createState() => MoinsenSpeechParentState();
}

class MoinsenSpeechParentState extends State<MoinsenSpeechParent> {
  bool _isListening = false;
  late SpeechToTextProvider speechProvider;
  late SpeechToText speech;

  @override
  void initState() {
    super.initState();

    speech = SpeechToText();
  }

  @override
  void dispose() {
    speech.stop();

    super.dispose();
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });

      await speech.initialize();

      if (speech.isAvailable) {
        speech.listen(
          localeId: 'de_DE',
          onResult: (result) {
            debugPrint('onResult: $result');

            if (result.finalResult) {
              widget.onSpeechRecognized(result.recognizedWords);
            } else {
              widget.onSpeechRecognized(null);
            }
          },
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });

      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    speechProvider = Provider.of<SpeechToTextProvider>(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        widget.child,
        if (speechProvider.isAvailable)
          GestureDetector(
            onPanDown: (details) {
              _startListening();
            },
            onPanEnd: (details) {
              Future.delayed(const Duration(seconds: 1), () {
                _stopListening();
              });
            },
            child: Icon(
              Icons.mic,
              color: _isListening ? Colors.red : Colors.grey,
              size: 48,
            ),
          ),
        if (speechProvider.isNotAvailable)
          const Icon(
            Icons.mic_off,
            color: Colors.black,
            size: 48,
          ),
      ],
    );
  }
}
