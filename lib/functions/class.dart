import 'package:flutter/material.dart';
import '../data/backend.dart';

Future<void> addClass(
    String name, String teacher, String branch, String year) async {
  await backend.addClass(name, teacher, branch, year);
  debugPrint('Class Created.');
}

Future<void> deleteClass(String classId) async {
  await backend.deleteClass(classId);
  debugPrint('class Deleted.');
}
