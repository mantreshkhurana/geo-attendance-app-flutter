import 'package:attendance/auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime timestamp = DateTime.now();

CollectionReference className =
    FirebaseFirestore.instance.collection('classes');
String dateFormat = DateFormat.yMEd().add_jm().format(DateTime.now());

addClass(String name, String teacher, String branch, String year) async {
  var docRef = await className.add(
    {
      'class_name': name,
      'teacher': teacher,
      'branch': branch,
      'year': year,
      'createdAt': timestamp,
      'email': userEmail,
      'classId': '',
      'postTime': dateFormat,
    },
  );
  debugPrint('Class Created.');
  var ref = docRef.id.toString();
  addPostUid(ref);
}

Future<void> addPostUid(String ref) async {
  return className
      .doc(ref)
      .update({
        'classId': ref,
      })
      .then((value) => debugPrint("classId Updated."))
      .catchError(
        (error) => debugPrint("Failed to update blog: $error"),
      );
}

Future<void> deleteClass(String classId) async {
  return className
      .doc(classId)
      .delete()
      .then((value) => debugPrint("class Deleted."))
      .catchError(
        (error) => debugPrint("Failed to delete class: $error"),
      );
}
