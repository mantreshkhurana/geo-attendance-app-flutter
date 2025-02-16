import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../screens/screens.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyEditAccountPageState createState() => _MyEditAccountPageState();
}

class _MyEditAccountPageState extends State<EditProfilePage> {
  var collection = FirebaseFirestore.instance.collection('users');
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            previousPageTitle: 'Back',
            middle: Text('Edit Account'),
          ),
          child: Center(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: collection.doc(userUid).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return const CupertinoActivityIndicator();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CupertinoActivityIndicator();
                }
                if (snapshot.hasData) {
                  var data = snapshot.data!.data();

                  final nameController =
                      TextEditingController(text: data!['name']);
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 350,
                            child: CupertinoTextField(
                              maxLength: 20,
                              controller: nameController,
                              placeholder: 'Name',
                              prefix: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 23,
                                  color: CupertinoColors.systemGrey,
                                ),
                                onPressed: () {},
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          CupertinoButton(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            color: CupertinoColors.systemPink,
                            onPressed: () async {
                              await updateUser(
                                nameController.text,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const CupertinoActivityIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
