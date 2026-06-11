import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../screens/screens.dart';

class ClassPage extends StatefulWidget {
  final String teacher;
  final String className;
  final String classId;
  final Timestamp createdAt;
  final String branch;
  final String year;

  const ClassPage(
    this.teacher,
    this.className,
    this.classId,
    this.createdAt,
    this.branch,
    this.year, {
    super.key,
  });

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final _users = FirebaseFirestore.instance.collection('users');
  final _classes = FirebaseFirestore.instance.collection('classes');
  DateTime dateTime = DateTime.now();

  /// Ensures location services + permission, then returns the current
  /// position. Returns null (after showing a dialog) if unavailable.
  Future<Position?> _resolvePosition(LocationAccuracy accuracy) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        await AppDialog.info(
          context,
          title: 'Location Off',
          message: 'Please enable location services and try again.',
          isError: true,
        );
      }
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        await AppDialog.info(
          context,
          title: 'Permission Denied',
          message: 'Location permission is required to mark attendance.',
          isError: true,
        );
      }
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: accuracy),
    );
  }

  // ---- Student: mark attendance via geolocation ----
  Future<void> _markPresent(String studentName) async {
    final classDoc = await _classes.doc(widget.classId).get();
    final classData = classDoc.data();

    if (classData == null || classData['latitude'] == null) {
      if (mounted) {
        await AppDialog.info(
          context,
          title: 'Attendance Not Started',
          message: 'Attendance has not started yet.',
        );
      }
      return;
    }

    final position = await _resolvePosition(LocationAccuracy.high);
    if (position == null) return;
    final distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      classData['latitude'],
      classData['longitude'],
    );

    if (distanceInMeters <= 100) {
      await _classes.doc(widget.classId).update({
        'presentStudents': FieldValue.arrayUnion([studentName]),
        'absentStudents': FieldValue.arrayRemove([studentName]),
      });
      if (mounted) {
        await AppDialog.info(
          context,
          title: 'Attendance Done',
          message: 'You are marked present for this class.',
        );
      }
    } else {
      await _classes.doc(widget.classId).update({
        'absentStudents': FieldValue.arrayUnion([studentName]),
        'presentStudents': FieldValue.arrayRemove([studentName]),
      });
      if (mounted) {
        await AppDialog.info(
          context,
          title: 'Attendance Error',
          message: 'You are not in the class.',
          isError: true,
        );
      }
    }
  }

  // ---- Teacher: start attendance, capture location, seed lists ----
  Future<void> _startAttendance(String teacherName) async {
    final position = await _resolvePosition(LocationAccuracy.medium);
    if (position == null) return;

    await _classes.doc(widget.classId).update({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'date': dateTime,
    });

    final students =
        await _users.where('role', isEqualTo: 'Student').get();
    for (final element in students.docs) {
      await _classes.doc(widget.classId).update({
        'absentStudents': FieldValue.arrayUnion([element.data()['name']]),
      });
    }

    await _classes.doc(widget.classId).update({
      'presentStudents': FieldValue.arrayUnion([teacherName]),
    });

    if (mounted) {
      await AppDialog.info(
        context,
        title: 'Attendance Started',
        message: 'Students can now mark themselves present.',
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => dateTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _users.doc(userUid).snapshots(),
      builder: (context, userSnap) {
        if (!userSnap.hasData || userSnap.data!.data() == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final userData = userSnap.data!.data()!;
        final isTeacher = userData['role'] == 'Teacher';
        final myName = userData['name'] as String? ?? '';

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.className),
            actions: [
              if (isTeacher)
                IconButton(
                  icon: const Icon(FontAwesomeIcons.calendar, size: 18),
                  onPressed: _pickDate,
                ),
            ],
          ),
          body: Column(
            children: [
              _ClassHeader(
                className: widget.className,
                teacher: widget.teacher,
                branch: widget.branch,
                year: widget.year,
                heroTag: 'class_${widget.classId}',
              ),
              if (isTeacher) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.calendarDay, size: 14),
                      const SizedBox(width: 8),
                      Text(DateFormat.yMMMMd().format(dateTime)),
                    ],
                  ),
                ),
                Expanded(child: _TeacherAttendanceList(classId: widget.classId)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PrimaryButton(
                    label: 'Start Attendance',
                    icon: FontAwesomeIcons.locationCrosshairs,
                    onPressed: () => _startAttendance(myName),
                  ),
                ),
              ] else ...[
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      GradientAvatar(name: myName, radius: 44),
                      const SizedBox(height: 16),
                      Text(
                        myName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make sure you are inside the classroom before marking your attendance.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PrimaryButton(
                    label: 'Mark as Present',
                    icon: FontAwesomeIcons.locationDot,
                    onPressed: () => _markPresent(myName),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ClassHeader extends StatelessWidget {
  final String className;
  final String teacher;
  final String branch;
  final String year;
  final String heroTag;

  const _ClassHeader({
    required this.className,
    required this.teacher,
    required this.branch,
    required this.year,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.bookGradientFor(className);
    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(FontAwesomeIcons.bookOpen, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [teacher, if (branch.isNotEmpty) branch, if (year.isNotEmpty) 'Year $year']
                          .join(' • '),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherAttendanceList extends StatelessWidget {
  final String classId;

  const _TeacherAttendanceList({required this.classId});

  @override
  Widget build(BuildContext context) {
    final classes = FirebaseFirestore.instance.collection('classes');
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: classes.doc(classId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!.data()!;
        final present = List<String>.from(data['presentStudents'] ?? []);
        final absent = List<String>.from(data['absentStudents'] ?? []);
        final total = present.length + absent.length;

        if (total == 0) {
          return const EmptyState(
            icon: FontAwesomeIcons.userCheck,
            title: 'No Students Yet',
            subtitle: 'Start attendance to load the student list.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: total,
          itemBuilder: (context, index) {
            final isPresent = index < present.length;
            final name = isPresent
                ? present[index]
                : absent[index - present.length];
            return AnimatedEntrance(
              index: index,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: GradientAvatar(name: name, radius: 20),
                  title: Text(name),
                  subtitle: Text(
                    isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      color: isPresent ? AppColors.present : AppColors.absent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: AttendanceCheckbox(
                    value: isPresent,
                    onChanged: (newValue) {
                      if (newValue) {
                        classes.doc(classId).update({
                          'absentStudents': FieldValue.arrayRemove([name]),
                          'presentStudents': FieldValue.arrayUnion([name]),
                        });
                      } else {
                        classes.doc(classId).update({
                          'presentStudents': FieldValue.arrayRemove([name]),
                          'absentStudents': FieldValue.arrayUnion([name]),
                        });
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
