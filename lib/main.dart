import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Flutter勉強 @li_yuan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              TweetTile(),
              TweetTile(),
              TweetTile(),
              TweetTile(),
              TweetTile(),
              TweetTile(),
              TweetTile(),
              TweetTile(),
              TweetTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class TweetTile extends StatelessWidget {
  const TweetTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://picsum.photos/id/56/40/40'),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Flutter勉強 @li_yuan'),
                  SizedBox(width: 8),
                  Text('2023/11/10'),
                ],
              ),
              const SizedBox(height: 4),
              const Text('最高でした。'),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_border))
            ],
          ),
        ],
      ),
    );
  }
}
