import 'dart:math';

import 'package:flutter/material.dart';

const String goo = '✊️';
const String choki = '✌️';
const String par = '🖐';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const JankenPage(),
    );
  }
}

class JankenPage extends StatefulWidget {
  const JankenPage({super.key});

  @override
  State<JankenPage> createState() => _JankenPageState();
}

class _JankenPageState extends State<JankenPage> {
  String myHand = goo;
  String computerHand = goo;
  String result = '引き分け';

  void selectHand(String selectedHand) {
    myHand = selectedHand;
    generateComputerHand();
    judge();
    setState(() {});
  }

  void generateComputerHand() {
    // nextInt() の括弧の中に与えた数字より1小さい値を最高値としたランダムな数を生成する。
    // 3 であれば 0, 1, 2 がランダムで生成される。
    // randomNumberに一時的に値を格納します。
    final randomNumber = Random().nextInt(3);
    // 生成されたランダムな数字を ✊, ✌️, 🖐 に変換して、コンピューターの手に代入します。
    computerHand = randomNumberToHand(randomNumber);
  }

  String randomNumberToHand(int randomNumber) {
    // () のなかには条件となる値を書きます。
    switch (randomNumber) {
      case 0: // 入ってきた値がもし 0 だったら。
        return goo; // ✊を返す。
      case 1: // 入ってきた値がもし 1 だったら。
        return choki; // ✌️を返す。
      case 2: // 入ってきた値がもし 2 だったら。
        return par; // 🖐を返す。
      default: // 上で書いてきた以外の値が入ってきたら。
        return goo; // ✊を返す。（0, 1, 2 以外が入ることはないが念のため）
    }
  }

  void judge() {
    // 引き分けの場合
    if (myHand == computerHand) {
      result = '引き分け';
      // 勝ちの場合
    } else if (myHand == goo && computerHand == choki ||
        myHand == choki && computerHand == par ||
        myHand == par && computerHand == goo) {
      result = '勝ち';
      // 負けの場合
    } else {
      result = '負け';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('じゃんけん'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              computerHand,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            // 余白を追加
            const SizedBox(height: 48),
            Text(
              myHand,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // myHand = goo;
                    // setState(() {});
                    selectHand(goo);
                  },
                  child: const Text(goo),
                ),
                ElevatedButton(
                  onPressed: () {
                    // myHand = choki;
                    // setState(() {});
                    selectHand(choki);
                  },
                  child: const Text(choki),
                ),
                ElevatedButton(
                  onPressed: () {
                    // myHand = par;
                    // setState(() {});
                    selectHand(par);
                  },
                  child: const Text(par),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
