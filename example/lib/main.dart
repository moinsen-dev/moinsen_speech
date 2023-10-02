import 'package:flutter/material.dart';
import 'package:moinsen_speech/moinsen_speech.dart';

void main() {
  runApp(const MyApp());
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? text;
  String? origin;

  TextEditingController textCtrl = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          maxLines: 2,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MoinsenSpeechParent(
              onSpeechRecognized: (text) {
                return regonizedText('Text', text);
              },
              child: const Text(
                'You have pushed the button this many times:',
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 40,
            ),
            MoinsenSpeechParent(
              onSpeechRecognized: (text) {
                textCtrl.text = text ?? '';
                regonizedText('Textinputfield', text);
              },
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: textCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.mic),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Recognized text from ${origin ?? "---"}:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              width: 400,
              child: Text(
                text ?? '---',
                maxLines: 3,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MoinsenSpeechParent(
        onSpeechRecognized: (text) =>
            regonizedText('FloatingActionButton', text),
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  regonizedText(String from, String? recognizedWords) {
    debugPrint(recognizedWords);
    setState(() {
      origin = from;
      text = recognizedWords;
    });
  }
}
