import '../firebase_options.dart';
import 'firebase_backend.dart';
import 'mock_backend.dart';
import 'models.dart';

export 'models.dart';

/// Whether real Firebase credentials have been configured.
///
/// `lib/firebase_options.dart` ships with placeholder values so the project
/// compiles and runs out of the box. As soon as the user runs
/// `flutterfire configure`, those placeholders are replaced with real values
/// and this flips to `true` automatically — switching the whole app from the
/// in-memory [MockBackend] to the live [FirebaseBackend].
bool get isFirebaseConfigured {
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    final apiKey = options.apiKey;
    return !apiKey.contains('Placeholder') &&
        options.projectId != 'placeholder-project';
  } catch (_) {
    return false;
  }
}

/// Abstraction over auth + data so the UI never touches Firebase directly.
abstract class Backend {
  /// `true` when running on seeded in-memory mock data.
  bool get isMock;

  // ---- Auth ----
  AppUser? get currentUser;
  Stream<AppUser?> authStateChanges();

  /// Signs in. [roleOverride] is only honored by the mock backend, where it
  /// selects the Teacher/Student demo persona chosen on the login screen.
  Future<void> signIn(String email, String password, {String? roleOverride});
  Future<void> register(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordReset(String email);

  // ---- Users ----
  Stream<AppUser?> userStream(String uid);

  /// Creates or updates the signed-in user's profile document.
  Future<void> upsertUserProfile(String name, String email);
  Future<void> updateUserName(String name);

  // ---- Classes ----
  Stream<List<AppClass>> classesStream();
  Stream<AppClass?> classStream(String classId);
  Future<AppClass?> getClass(String classId);
  Future<void> addClass(String name, String teacher, String branch, String year);
  Future<void> deleteClass(String classId);

  /// Teacher starts attendance: records location and seeds the roster.
  Future<void> startAttendance(
    String classId, {
    required String teacherName,
    double? latitude,
    double? longitude,
  });

  /// Marks [studentName] present (`true`) or absent (`false`) for a class.
  Future<void> setAttendance(String classId, String studentName, bool present);
}

Backend? _instance;

/// The active backend for the whole app. Lazily resolved once based on whether
/// Firebase is configured.
Backend get backend => _instance ??=
    isFirebaseConfigured ? FirebaseBackend() : MockBackend();
