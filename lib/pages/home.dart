import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geo_attendance_app/functions/class.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../screens/screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final classNameController = TextEditingController();
  final yearNameController = TextEditingController();
  final branchNameController = TextEditingController();

  @override
  void dispose() {
    classNameController.dispose();
    yearNameController.dispose();
    branchNameController.dispose();
    super.dispose();
  }

  void _openAddClassSheet(String teacherName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Add Class',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: TextEditingController(text: teacherName),
                label: 'Teacher',
                icon: FontAwesomeIcons.chalkboardUser,
                enabled: false,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: classNameController,
                label: 'Class Name',
                icon: FontAwesomeIcons.book,
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: branchNameController,
                label: 'Branch',
                icon: FontAwesomeIcons.codeBranch,
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: yearNameController,
                label: 'Year',
                icon: FontAwesomeIcons.calendar,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Create Class',
                icon: FontAwesomeIcons.plus,
                onPressed: () async {
                  await addClass(
                    classNameController.text,
                    teacherName,
                    branchNameController.text,
                    yearNameController.text,
                  );
                  classNameController.clear();
                  branchNameController.clear();
                  yearNameController.clear();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String classId) async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Delete Class',
      message: 'Are you sure you want to delete this class?',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (ok) await deleteClass(classId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: backend.userStream(userUid ?? ''),
      builder: (context, userSnap) {
        if (!userSnap.hasData || userSnap.data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final appUser = userSnap.data!;
        final name = appUser.name;
        final isTeacher = appUser.isTeacher;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => goTo(context, const ProfilePage()),
                  child: GradientAvatar(name: name, radius: 18),
                ),
              ),
            ],
          ),
          floatingActionButton: isTeacher
              ? FloatingActionButton.extended(
                  onPressed: () => _openAddClassSheet(name),
                  icon: const Icon(FontAwesomeIcons.plus, size: 16),
                  label: const Text('Add Class'),
                )
              : null,
          body: StreamBuilder<List<AppClass>>(
            stream: backend.classesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.where((c) {
                if (!isTeacher) return true;
                return c.email == userEmail;
              }).toList();

              if (docs.isEmpty) {
                return EmptyState(
                  icon: FontAwesomeIcons.bookBookmark,
                  title: 'No Classes Yet',
                  subtitle: isTeacher
                      ? 'Tap "Add Class" to create your first class.'
                      : 'Classes created by teachers will appear here.',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final cls = docs[index];
                  final classId = cls.classId;
                  return AnimatedEntrance(
                    index: index,
                    child: BookCard(
                      heroTag: 'class_$classId',
                      className: cls.className,
                      teacher: cls.teacher,
                      branch: cls.branch,
                      year: cls.year,
                      onDelete:
                          isTeacher ? () => _confirmDelete(classId) : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassPage(
                              cls.teacher,
                              cls.className,
                              classId,
                              cls.branch,
                              cls.year,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
