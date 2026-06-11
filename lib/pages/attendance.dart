import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/screens.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _users = FirebaseFirestore.instance.collection('users');
  final _classes = FirebaseFirestore.instance.collection('classes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _users.doc(userUid).snapshots(),
        builder: (context, userSnap) {
          if (!userSnap.hasData || userSnap.data!.data() == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = userSnap.data!.data()!;
          final isTeacher = userData['role'] == 'Teacher';
          final myName = userData['name'] as String? ?? '';

          return StreamBuilder<QuerySnapshot>(
            stream:
                _classes.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs.where((doc) {
                if (!isTeacher) return true;
                final data = doc.data() as Map<String, dynamic>;
                return data['email'] == userEmail;
              }).toList();

              if (docs.isEmpty) {
                return const EmptyState(
                  icon: FontAwesomeIcons.clipboardList,
                  title: 'Nothing to Show',
                  subtitle: 'Attendance records will appear here.',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final present =
                      List<String>.from(data['presentStudents'] ?? []);
                  final absent =
                      List<String>.from(data['absentStudents'] ?? []);

                  return AnimatedEntrance(
                    index: index,
                    child: isTeacher
                        ? _TeacherSummaryCard(
                            className: data['class_name'] ?? '',
                            presentCount: present.length,
                            absentCount: absent.length,
                          )
                        : _StudentStatusCard(
                            className: data['class_name'] ?? '',
                            teacher: data['teacher'] ?? '',
                            status: present.contains(myName)
                                ? _Status.present
                                : absent.contains(myName)
                                    ? _Status.absent
                                    : _Status.notMarked,
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

enum _Status { present, absent, notMarked }

class _StudentStatusCard extends StatelessWidget {
  final String className;
  final String teacher;
  final _Status status;

  const _StudentStatusCard({
    required this.className,
    required this.teacher,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final IconData icon;
    late final String label;
    switch (status) {
      case _Status.present:
        color = AppColors.present;
        icon = FontAwesomeIcons.circleCheck;
        label = 'Present';
        break;
      case _Status.absent:
        color = AppColors.absent;
        icon = FontAwesomeIcons.circleXmark;
        label = 'Absent';
        break;
      case _Status.notMarked:
        color = Theme.of(context).colorScheme.onSurfaceVariant;
        icon = FontAwesomeIcons.circleMinus;
        label = 'Not Marked';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(className,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(teacher),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _TeacherSummaryCard extends StatelessWidget {
  final String className;
  final int presentCount;
  final int absentCount;

  const _TeacherSummaryCard({
    required this.className,
    required this.presentCount,
    required this.absentCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = presentCount + absentCount;
    final ratio = total == 0 ? 0.0 : presentCount / total;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.bookOpen, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    className,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Text('$presentCount/$total present'),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: AppColors.absent.withValues(alpha: 0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.present),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Present: $presentCount',
                    style: const TextStyle(color: AppColors.present)),
                Text('Absent: $absentCount',
                    style: const TextStyle(color: AppColors.absent)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
