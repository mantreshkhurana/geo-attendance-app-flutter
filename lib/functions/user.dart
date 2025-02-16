import 'package:attendance/auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final User info = FirebaseAuth.instance.currentUser!;
final uid = info.uid;
CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> addUser(String name, email) async {
  await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
    {
      'name': name,
      'uid': uid,
      'email': email,
      'role': 'Student',
    },
  );
  debugPrint('User added.');
}

Future<void> updateUser(String name) {
  return users
      .doc(info.uid)
      .update({
        'name': name,
      })
      .then((value) => debugPrint("User Updated."))
      .catchError(
        (error) => debugPrint("Failed to update user: $error"),
      );
}

Widget userUpdated(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Your details are Updated.'),
    actions: [
      CupertinoDialogAction(
        child: const Text('Continue'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
