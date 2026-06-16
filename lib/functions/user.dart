import 'package:flutter/material.dart';
import '../data/backend.dart';

/// Creates the signed-in user's profile (called right after registration).
Future<void> addUser(String name, email) async {
  await backend.upsertUserProfile(name, email.toString());
  debugPrint('User added.');
}

/// Updates the signed-in user's display name.
Future<void> updateUser(String name) async {
  await backend.updateUserName(name);
  debugPrint('User Updated.');
}
