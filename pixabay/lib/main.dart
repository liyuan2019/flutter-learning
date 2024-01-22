// import 'dart:io';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List<PixabayImage> pixabayImages = [];

  // 非同期の関数になったため返り値の型にFutureがつき、さらに async キーワードが追加されました。
  Future<void> fetchImages(String text) async {
    // await で待つことで Future が外れ Response 型のデータを受け取ることができました。
    // 中身を書き換えたくない値については final をつける
    final response = await Dio().get(
      // 'https://pixabay.com/api/?key=40700765-9428eb4a08095a96bfdc7219d&q=$text&image_type=photo&pretty=true',
      'https://pixabay.com/api',
      queryParameters: {
        'key': '0700765-9428eb4a08095a96bfdc7219d',
        'q': text,
        'image_type': 'photo',
        'pretty': true,
        'per_page': 100,
      },
    );

    // この時点では要素の中身の型は Map<String, dynamic>
    final List hits = response.data['hits'];
    // map メソッドを使って Map<String, dynamic> の型を一つひとつ PixabayImage 型に変換していきます。
    pixabayImages = hits.map((e) => PixabayImage.fromMap(e)).toList();
    setState(() {});
  }

  Future<void> shareImage(String url) async {
    // まずは一時保存に使えるフォルダ情報を取得します。
    // Future 型なので await で待ちます
    final dir = await getTemporaryDirectory();

    final response = await Dio().get(
      // previewURL は荒いためより高解像度の webformatURL から画像をダウンロードします。
      url,
      options: Options(
        // 画像をダウンロードするときは ResponseType.bytes を指定します。
        responseType: ResponseType.bytes,
      ),
    );

    // フォルダの中に image.png という名前でファイルを作り、そこに画像データを書き込みます。
    final imageFile =
        await File('${dir.path}/image.png').writeAsBytes(response.data);
    // final files = <XFile>[];
    XFile xfile = XFile(imageFile.path);
    // files.add(xfile);
    await Share.shareXFiles([xfile]);
  }

  // この関数の中の処理は初回に一度だけ実行されます。
  @override
  void initState() {
    super.initState();
    // 最初に一度だけ画像データを取得します。
    fetchImages('花');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextFormField(
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 横に並べる個数をここで決めます。今回は 3 にします。
        ),
        // itemCount には要素数を与えます。
        // List の要素数は .length で取得できます。今回は20になります。
        itemCount: pixabayImages.length,
        // index には 0 ~ itemCount - 1 の数が順番に入ってきます。
        // 今回、要素数は 20 なので 0 ~ 19 が順番に入ります。
        itemBuilder: (context, index) {
          // 要素を順番に取り出します。
          // index には 0 ~ 19 の値が順番に入ること、
          // List から番号を指定して要素を取り出す書き方を思い出しながら眺めてください。
          final pixabayImage = pixabayImages[index];
          // プレビュー用の画像データがあるURLは previewURL の value に入っています。
          // URLをつかった画像表示は Image.network(表示したいURL) で実装できます。
          return InkWell(
            onTap: () async {
              shareImage(pixabayImage.webformatURL);
            },
            child: Stack(
              // StackFit.expand を与えると領域いっぱいに広がろうとします。
              fit: StackFit.expand,
              children: [
                Image.network(
                  pixabayImage.previewURL,
                  // BoxFit.cover を与えると領域いっぱいに広がろうとします。
                  fit: BoxFit.cover,
                ),
                Align(
                  // 左上ではなく右下に表示するようにします。
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      // MainAxisSize.min を与えると必要最小限のサイズに縮小します。
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 何の数字かわからないので 👍 アイコンを追加します。
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 14,
                        ),
                        Text('${pixabayImage.likes}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PixabayImage {
  final String previewURL;
  final int likes;
  final String webformatURL;

  PixabayImage(
      {required this.previewURL,
      required this.likes,
      required this.webformatURL});

  factory PixabayImage.fromMap(Map<String, dynamic> map) {
    return PixabayImage(
      previewURL: map['previewURL'],
      likes: map['likes'],
      webformatURL: map['webformatURL'],
    );
  }
}
