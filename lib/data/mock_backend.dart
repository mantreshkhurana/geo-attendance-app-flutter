import 'dart:async';

import 'backend.dart';

/// In-memory backend used when Firebase is not configured.
///
/// Any email/password "works": you are signed in instantly against seeded
/// demo data. Two demo accounts give the full experience for both roles:
///
///   • Teacher  →  teacher@demo.com  (or any email containing "teacher")
///   • Student  →  student@demo.com  (or any other email)
///
/// All writes (create class, start attendance, mark present, edit profile)
/// mutate the in-memory store and stream back live, so the app behaves exactly
/// like the real thing — the data just resets when the app restarts.
class MockBackend implements Backend {
  MockBackend() {
    _seed();
  }

  // Broadcast "something changed" signal. Each stream re-reads the store and
  // re-emits whenever this fires (and once immediately on listen).
  final _events = StreamController<void>.broadcast();

  final Map<String, AppUser> _users = {};
  final List<AppClass> _classes = [];
  AppUser? _currentUser;

  void _notify() {
    if (!_events.isClosed) _events.add(null);
  }

  AppClass? _findClass(String classId) {
    for (final c in _classes) {
      if (c.classId == classId) return c;
    }
    return null;
  }

  AppUser? _findUserByUid(String uid) {
    for (final u in _users.values) {
      if (u.uid == uid) return u;
    }
    return null;
  }

  @override
  bool get isMock => true;

  // ---------------------------------------------------------------------------
  // Seed data
  // ---------------------------------------------------------------------------
  static const _teacherName = 'Prof. Ada Lovelace';
  static const _teacherEmail = 'teacher@demo.com';
  static const _studentEmail = 'student@demo.com';

  void _seed() {
    _users[_teacherEmail] =
        const AppUser(uid: 'u_teacher', name: _teacherName, email: _teacherEmail, role: 'Teacher');
    for (final s in const [
      ['u_alex', 'Alex Johnson', 'student@demo.com'],
      ['u_maria', 'Maria Garcia', 'maria@demo.com'],
      ['u_liam', 'Liam Smith', 'liam@demo.com'],
      ['u_sofia', 'Sofia Patel', 'sofia@demo.com'],
      ['u_noah', 'Noah Williams', 'noah@demo.com'],
    ]) {
      _users[s[2]] =
          AppUser(uid: s[0], name: s[1], email: s[2], role: 'Student');
    }

    final now = DateTime(2026, 6, 16, 9);
    _classes.addAll([
      AppClass(
        classId: 'c_ds',
        className: 'Data Structures',
        teacher: _teacherName,
        email: _teacherEmail,
        branch: 'CSE',
        year: '2',
        createdAt: now,
        latitude: 28.6139,
        longitude: 77.2090,
        presentStudents: [_teacherName, 'Alex Johnson', 'Maria Garcia'],
        absentStudents: ['Liam Smith', 'Sofia Patel'],
      ),
      AppClass(
        classId: 'c_os',
        className: 'Operating Systems',
        teacher: _teacherName,
        email: _teacherEmail,
        branch: 'CSE',
        year: '3',
        createdAt: now.subtract(const Duration(days: 1)),
        latitude: 28.6139,
        longitude: 77.2090,
        presentStudents: [_teacherName, 'Liam Smith', 'Noah Williams'],
        absentStudents: ['Alex Johnson', 'Maria Garcia', 'Sofia Patel'],
      ),
      AppClass(
        classId: 'c_algo',
        className: 'Algorithms',
        teacher: _teacherName,
        email: _teacherEmail,
        branch: 'IT',
        year: '2',
        createdAt: now.subtract(const Duration(days: 2)),
        // Not started yet — demonstrates the empty/"not marked" state.
      ),
    ]);
  }

  String _inferRole(String email) =>
      email.toLowerCase().contains('teacher') ? 'Teacher' : 'Student';

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    final words = local.split(RegExp(r'[._\-+]')).where((w) => w.isNotEmpty);
    return words
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  AppClass _replace(AppClass c,
      {List<String>? present, List<String>? absent, double? lat, double? lng}) {
    final i = _classes.indexWhere((e) => e.classId == c.classId);
    final updated = AppClass(
      classId: c.classId,
      className: c.className,
      teacher: c.teacher,
      email: c.email,
      branch: c.branch,
      year: c.year,
      createdAt: c.createdAt,
      latitude: lat ?? c.latitude,
      longitude: lng ?? c.longitude,
      presentStudents: present ?? c.presentStudents,
      absentStudents: absent ?? c.absentStudents,
    );
    _classes[i] = updated;
    return updated;
  }

  /// Gives a freshly signed-in student a realistic spread across classes:
  /// present in one, absent in another, unmarked in the rest.
  void _seedStudentRoster(String name) {
    for (final c in List<AppClass>.from(_classes)) {
      if (c.presentStudents.contains(name) ||
          c.absentStudents.contains(name)) {
        continue;
      }
      if (c.classId == 'c_ds') {
        _replace(c, present: [...c.presentStudents, name]);
      } else if (c.classId == 'c_os') {
        _replace(c, absent: [...c.absentStudents, name]);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _currentUser;
    yield* _events.stream.map((_) => _currentUser);
  }

  AppUser _resolveUser(String email, {String? name}) {
    final existing = _users[email];
    if (existing != null) {
      return name == null ? existing : existing.copyWith(name: name);
    }
    final role = _inferRole(email);
    return AppUser(
      uid: 'u_${email.hashCode.toUnsigned(20)}',
      name: name ?? _nameFromEmail(email),
      email: email,
      role: role,
    );
  }

  void _signInUser(AppUser user) {
    _users[user.email] = user;
    _currentUser = user;
    if (!user.isTeacher) _seedStudentRoster(user.name);
    _notify();
  }

  @override
  Future<void> signIn(String email, String password,
      {String? roleOverride}) async {
    // The login screen's Teacher/Student pill picks the demo persona so each
    // role lands on rich, role-appropriate seeded data.
    if (roleOverride == 'Teacher') {
      _signInUser(_users[_teacherEmail]!);
      return;
    }
    if (roleOverride == 'Student') {
      _signInUser(_users[_studentEmail]!);
      return;
    }
    _signInUser(_resolveUser(email));
  }

  @override
  Future<void> register(String email, String password) async {
    // The display name is set right after via [upsertUserProfile] (addUser),
    // mirroring the real two-step register → write-profile flow.
    _signInUser(_resolveUser(email));
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _notify();
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    // No-op in mock mode; the UI still shows its success dialog.
  }

  // ---------------------------------------------------------------------------
  // Users
  // ---------------------------------------------------------------------------
  @override
  Stream<AppUser?> userStream(String uid) async* {
    yield _findUserByUid(uid);
    yield* _events.stream.map((_) => _findUserByUid(uid));
  }

  @override
  Future<void> upsertUserProfile(String name, String email) async {
    final user = _resolveUser(email, name: name);
    _users[email] = user;
    _currentUser = user;
    if (!user.isTeacher) _seedStudentRoster(user.name);
    _notify();
  }

  @override
  Future<void> updateUserName(String name) async {
    final cur = _currentUser;
    if (cur == null) return;
    final updated = cur.copyWith(name: name);
    _users[cur.email] = updated;
    _currentUser = updated;
    _notify();
  }

  // ---------------------------------------------------------------------------
  // Classes
  // ---------------------------------------------------------------------------
  List<AppClass> _sorted() {
    final list = List<AppClass>.from(_classes);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Stream<List<AppClass>> classesStream() async* {
    yield _sorted();
    yield* _events.stream.map((_) => _sorted());
  }

  @override
  Stream<AppClass?> classStream(String classId) async* {
    yield _findClass(classId);
    yield* _events.stream.map((_) => _findClass(classId));
  }

  @override
  Future<AppClass?> getClass(String classId) async => _findClass(classId);

  @override
  Future<void> addClass(
      String name, String teacher, String branch, String year) async {
    final id = 'c_${DateTime.now().microsecondsSinceEpoch}';
    _classes.add(AppClass(
      classId: id,
      className: name,
      teacher: teacher,
      email: _currentUser?.email ?? _teacherEmail,
      branch: branch,
      year: year,
      createdAt: DateTime.now(),
    ));
    _notify();
  }

  @override
  Future<void> deleteClass(String classId) async {
    _classes.removeWhere((c) => c.classId == classId);
    _notify();
  }

  @override
  Future<void> startAttendance(
    String classId, {
    required String teacherName,
    double? latitude,
    double? longitude,
  }) async {
    final c = await getClass(classId);
    if (c == null) return;
    final absent = _users.values
        .where((u) => !u.isTeacher)
        .map((u) => u.name)
        .toList();
    _replace(
      c,
      lat: latitude ?? 28.6139,
      lng: longitude ?? 77.2090,
      present: [teacherName],
      absent: absent,
    );
    _notify();
  }

  @override
  Future<void> setAttendance(
      String classId, String studentName, bool present) async {
    final c = await getClass(classId);
    if (c == null) return;
    final presentList = List<String>.from(c.presentStudents)
      ..remove(studentName);
    final absentList = List<String>.from(c.absentStudents)..remove(studentName);
    if (present) {
      presentList.add(studentName);
    } else {
      absentList.add(studentName);
    }
    _replace(c, present: presentList, absent: absentList);
    _notify();
  }
}
