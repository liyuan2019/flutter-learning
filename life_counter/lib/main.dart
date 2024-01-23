import 'package:flutter/material.dart';

import 'life_event.dart';
import 'objectbox.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LifeCounterPage(
        title: '',
      ),
    );
  }
}

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key, required this.title});

  final String title;

  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  Store? store;
  Box<LifeEvent>? lifeEventBox;
  List<LifeEvent> lifeEvents = [];

  Future<void> initialize() async {
    store = await openStore();
    lifeEventBox = store?.box<LifeEvent>();
    fetchLifeEvents();
  }

  void fetchLifeEvents() {
    lifeEvents = lifeEventBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('人生カウンター'),
      ),
      body: ListView.builder(
        itemCount: lifeEvents.length,
        itemBuilder: (context, index) {
          final lifeEvent = lifeEvents[index];
          return Text(lifeEvent.title); // まずはTextを表示するだけにします。
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // pop された値を受け取る
          final newLifeEvent = await Navigator.of(context).push<LifeEvent>(
            MaterialPageRoute(
              builder: (context) {
                return const AddLifeEventPage();
              },
            ),
          );
          // 受け取った値を ObjectBox に保存
          if (newLifeEvent != null) {
            lifeEventBox?.put(newLifeEvent);
            fetchLifeEvents();
          }
        },
      ),
    );
  }
}

class AddLifeEventPage extends StatefulWidget {
  const AddLifeEventPage({super.key});

  @override
  State<AddLifeEventPage> createState() => _AddLifeEventPageState();
}

class _AddLifeEventPageState extends State<AddLifeEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ライフイベント追加'),
      ),
      body: TextFormField(
        onFieldSubmitted: (text) {
          final lifeEvent = LifeEvent(title: text, count: 0); // インスタンス作成
          Navigator.of(context).pop(lifeEvent); // 前のページにインスタンスを渡します
        },
      ),
    );
  }
}
