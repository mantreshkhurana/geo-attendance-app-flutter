import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../screens/screens.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _users.doc(userUid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data()!;
          final name = data['name']?.toString() ?? '';
          final email = data['email']?.toString() ?? '';
          final role = data['role']?.toString() ?? 'Student';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 12),
              AnimatedEntrance(
                index: 0,
                child: Center(child: GradientAvatar(name: name, radius: 52)),
              ),
              const SizedBox(height: 18),
              AnimatedEntrance(
                index: 1,
                child: Center(
                  child: Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedEntrance(
                index: 2,
                child: Center(
                  child: Text(
                    email,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AnimatedEntrance(
                index: 3,
                child: Center(child: RoleBadge(role: role)),
              ),
              const SizedBox(height: 36),
              AnimatedEntrance(
                index: 4,
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(FontAwesomeIcons.penToSquare,
                            size: 18),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(FontAwesomeIcons.chevronRight,
                            size: 14),
                        onTap: () => goTo(context, const EditProfilePage()),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.rightFromBracket,
                            size: 18, color: scheme.error),
                        title: Text('Sign Out',
                            style: TextStyle(color: scheme.error)),
                        onTap: () => signOut(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
