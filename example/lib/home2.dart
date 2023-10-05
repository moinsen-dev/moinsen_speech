import 'package:flutter/material.dart';
import 'package:moinsen_speech/moinsen_speech.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  String? text;
  String? origin;
  List<String> ideas = [];
  List<String> features = [];
  List<String> notes = [];

  TextEditingController textCtrl = TextEditingController();

  Widget overviewWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  categoryHeaderButton('Idea'),
                  ...ideas.map((e) => Text(e)),
                ],
              ),
              Column(
                children: [
                  categoryHeaderButton('Feature'),
                  ...features.map((e) => Text(e)),
                ],
              ),
              Column(
                children: [
                  categoryHeaderButton('Note'),
                  ...notes.map((e) => Text(e)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryHeaderButton(String title) {
    return MoinsenSpeechParent(
      onSpeechRecognized: (text) {
        if (text != null && text.isNotEmpty) {
          switch (title) {
            case 'Idea':
              ideas.add(text);
              break;
            case 'Feature':
              features.add(text);
              break;
            case 'Note':
              notes.add(text);
              break;
          }

          regonizedText('categoryHeaderButton $title', text);
        }

        regonizedText('categoryButton $title', text);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 100,
          child: TextButton(
            onPressed: null,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Business'),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 100,
                child: Text(
                  'Recognized from ${origin ?? "---"} : ${text ?? "---"}',
                  maxLines: 3,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            overviewWidget(),
          ],
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
