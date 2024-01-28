import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final userProvider = StreamProvider((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return firebaseAuth.userChanges();
});

final uidProvider = StreamProvider((ref) {
  // ignore: deprecated_member_use
  return ref.watch(userProvider.stream).map((event) => event?.uid);
});
