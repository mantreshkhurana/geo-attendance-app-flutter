import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../screens/screens.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Account')),
        body: StreamBuilder<AppUser?>(
          stream: backend.userStream(userUid ?? ''),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            if (!_initialized) {
              nameController.text = data.name;
              _initialized = true;
            }
            final name = data.name;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 12),
                Center(child: GradientAvatar(name: name, radius: 48)),
                const SizedBox(height: 32),
                AppTextField(
                  controller: nameController,
                  label: 'Name',
                  icon: FontAwesomeIcons.user,
                  maxLength: 20,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Save',
                  icon: FontAwesomeIcons.floppyDisk,
                  onPressed: () async {
                    await updateUser(nameController.text);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
