import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../providers/auth_provider.dart';
import '../utils/util_log.dart';
import 'chat_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  Future<void> signInWithGoogle() async {
    // GoogleSignIn をして得られた情報を Firebase と関連づけることをやっています。
    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await ref.read(firebaseAuthProvider).signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoogleSignIn'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('GoogleSignIn'),
          onPressed: () async {
            await signInWithGoogle();
            // ログインが成功すると FirebaseAuth.instance.currentUser にログイン中のユーザーの情報が入ります
            utilLog(ref.read(firebaseAuthProvider).currentUser?.displayName);
            // SignInPageを表示するロジックを変更したので必要なくなった。

            // // ログインに成功したら ChatPage に遷移します。
            // // 前のページに戻らせないようにするにはpushAndRemoveUntilを使います。
            // if (mounted) {
            //   await Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) {
            //       return const ChatPage();
            //     }),
            //     (route) => false,
            //   );
            // }
          },
        ),
      ),
    );
  }
}
