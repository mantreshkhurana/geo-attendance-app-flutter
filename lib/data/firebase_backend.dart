import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'backend.dart';

/// Live backend backed by Firebase Auth + Cloud Firestore. Used whenever real
/// Firebase credentials are configured.
class FirebaseBackend implements Backend {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');
  final _classes = FirebaseFirestore.instance.collection('classes');

  @override
  bool get isMock => false;

  AppUser? _fromAuth(User? u) => u == null
      ? null
      : AppUser(uid: u.uid, name: u.displayName ?? '', email: u.email ?? '', role: '');

  @override
  AppUser? get currentUser => _fromAuth(_auth.currentUser);

  @override
  Stream<AppUser?> authStateChanges() =>
      _auth.authStateChanges().map(_fromAuth);

  @override
  Future<void> signIn(String email, String password, {String? roleOverride}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Stream<AppUser?> userStream(String uid) => _users.doc(uid).snapshots().map(
        (d) => d.data() == null ? null : AppUser.fromMap(d.data()!),
      );

  @override
  Future<void> upsertUserProfile(String name, String email) async {
    final uid = _auth.currentUser!.uid;
    await _users.doc(uid).set({
      'name': name,
      'uid': uid,
      'email': email,
      'role': 'Student',
    });
  }

  @override
  Future<void> updateUserName(String name) =>
      _users.doc(_auth.currentUser!.uid).update({'name': name});

  @override
  Stream<List<AppClass>> classesStream() => _classes
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs
          .map((d) => AppClass.fromFirestore(d.id, d.data()))
          .toList());

  @override
  Stream<AppClass?> classStream(String classId) =>
      _classes.doc(classId).snapshots().map((d) =>
          d.data() == null ? null : AppClass.fromFirestore(d.id, d.data()!));

  @override
  Future<AppClass?> getClass(String classId) async {
    final doc = await _classes.doc(classId).get();
    final data = doc.data();
    return data == null ? null : AppClass.fromFirestore(doc.id, data);
  }

  @override
  Future<void> addClass(
      String name, String teacher, String branch, String year) async {
    final docRef = await _classes.add({
      'class_name': name,
      'teacher': teacher,
      'branch': branch,
      'year': year,
      'createdAt': DateTime.now(),
      'email': currentUser?.email,
      'classId': '',
      'postTime': DateFormat.yMEd().add_jm().format(DateTime.now()),
    });
    await _classes.doc(docRef.id).update({'classId': docRef.id});
  }

  @override
  Future<void> deleteClass(String classId) => _classes.doc(classId).delete();

  @override
  Future<void> startAttendance(
    String classId, {
    required String teacherName,
    double? latitude,
    double? longitude,
  }) async {
    await _classes.doc(classId).update({
      'latitude': latitude,
      'longitude': longitude,
      'date': DateTime.now(),
    });

    final students = await _users.where('role', isEqualTo: 'Student').get();
    for (final element in students.docs) {
      await _classes.doc(classId).update({
        'absentStudents': FieldValue.arrayUnion([element.data()['name']]),
      });
    }

    await _classes.doc(classId).update({
      'presentStudents': FieldValue.arrayUnion([teacherName]),
    });
  }

  @override
  Future<void> setAttendance(
      String classId, String studentName, bool present) async {
    if (present) {
      await _classes.doc(classId).update({
        'presentStudents': FieldValue.arrayUnion([studentName]),
        'absentStudents': FieldValue.arrayRemove([studentName]),
      });
    } else {
      await _classes.doc(classId).update({
        'absentStudents': FieldValue.arrayUnion([studentName]),
        'presentStudents': FieldValue.arrayRemove([studentName]),
      });
    }
  }
}
