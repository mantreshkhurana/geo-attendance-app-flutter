import 'package:cloud_firestore/cloud_firestore.dart';

/// Plain data models shared by every backend (Firebase or mock).
///
/// Pages talk to these instead of raw Firestore snapshots, which lets the app
/// run identically whether it is backed by a real Firebase project or the
/// in-memory mock used when Firebase is not configured.

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'Student' | 'Teacher'

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isTeacher => role == 'Teacher';

  AppUser copyWith({String? name, String? role}) => AppUser(
        uid: uid,
        name: name ?? this.name,
        email: email,
        role: role ?? this.role,
      );

  factory AppUser.fromMap(Map<String, dynamic> data) => AppUser(
        uid: data['uid']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        role: data['role']?.toString() ?? 'Student',
      );
}

class AppClass {
  final String classId;
  final String className;
  final String teacher;
  final String email; // teacher's email
  final String branch;
  final String year;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final List<String> presentStudents;
  final List<String> absentStudents;

  const AppClass({
    required this.classId,
    required this.className,
    required this.teacher,
    required this.email,
    required this.branch,
    required this.year,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.presentStudents = const [],
    this.absentStudents = const [],
  });

  /// Whether the teacher has started attendance for this class yet.
  bool get isStarted => latitude != null;

  factory AppClass.fromFirestore(String id, Map<String, dynamic> data) {
    final created = data['createdAt'];
    return AppClass(
      classId: id,
      className: data['class_name']?.toString() ?? '',
      teacher: data['teacher']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      branch: data['branch']?.toString() ?? '',
      year: data['year']?.toString() ?? '',
      createdAt: created is Timestamp ? created.toDate() : DateTime.now(),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      presentStudents: List<String>.from(data['presentStudents'] ?? const []),
      absentStudents: List<String>.from(data['absentStudents'] ?? const []),
    );
  }
}
