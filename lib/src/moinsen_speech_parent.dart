import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  late SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
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

      widget.onSpeechRecognized(null);

      if (speech.isAvailable) {
        speech.listen(
          localeId: 'de_DE',
          listenMode: ListenMode.dictation,
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
    if (_isListening) {
      setState(() {
        _isListening = false;
      });

      speech.stop();
    }
  }

  void showRecording() {
    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return Row(
      children: [
        widget.child,
        if (speech.isAvailable && isMobile)
          GestureDetector(
            onPanDown: (details) {
              _startListening();
            },
            onPanEnd: (details) {
              Future.delayed(
                const Duration(seconds: 1),
                () {
                  _stopListening();
                },
              );
            },
            child: Icon(
              Icons.mic,
              color: _isListening ? Colors.red : Colors.grey,
              size: 48,
            ),
          ),
        if (speech.isAvailable && !isMobile)
          MouseRegion(
            onEnter: (details) {
              _startListening();
            },
            onExit: (details) {
              Future.delayed(
                const Duration(milliseconds: 300),
                () {
                  _stopListening();
                },
              );
            },
            child: Icon(
              Icons.mic,
              color: _isListening ? Colors.red : Colors.grey,
              size: 48,
            ),
          ),
        if (!speech.isAvailable)
          const Icon(
            Icons.mic_off,
            color: Colors.black,
            size: 48,
          ),
      ],
    );
  }
}
