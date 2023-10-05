import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

enum Category {
  incoming,
  idea,
  feature,
  note,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.idea:
        return 'Idea';
      case Category.feature:
        return 'Feature';
      case Category.note:
        return 'Note';
      case Category.incoming:
        return 'Incoming';
      default:
        return '*Unknown*';
    }
  }
}

class NodeData {
  final int id;
  final String text;
  final Category category;

  NodeData({
    required this.id,
    required this.text,
    this.category = Category.incoming,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? text;
  String? origin;

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  int counter = 0;

  int selectedNode = -1;

  final List<NodeData> nodes = [];

  @override
  void initState() {
    super.initState();

    addNode(NodeData(id: ++counter, text: 'Brainstorming'));
    addNode(NodeData(id: ++counter, text: 'Idas'));
    addNode(NodeData(id: ++counter, text: 'Features'));

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  Node addNode(NodeData nodeData) {
    final node = Node.Id(nodeData.id);
    nodes.add(nodeData);

    graph.addNode(node);

    setState(() {
      graph.addEdge(
        Node.Id(1),
        node,
      );
    });

    return node;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNode(
            NodeData(
              id: ++counter,
              text: 'New Node',
              category: Category.incoming,
            ),
          );
        },
        child: const Icon(Icons.add_box_outlined),
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
            Expanded(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.01,
                  maxScale: 5.6,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(
                      builder,
                      TreeEdgeRenderer(builder),
                    ),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key!.value as int;
                      return rectangleWidget(a);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget rectangleWidget(int a) {
    return InkWell(
      onTap: () {
        debugPrint('clicked at node $a');
        setState(() {
          selectedNode = a;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
          ],
        ),
        child: Column(
          children: [
            Text(nodes[a - 1].category.name),
            Text(nodes[a - 1].text),
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
