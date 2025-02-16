import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../screens/screens.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<ProfilePage> {
  var collection = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            previousPageTitle: 'Home',
            middle: Text('My Account'),
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: collection.doc(userUid).snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }
                      if (snapshot.hasData) {
                        var data = snapshot.data!.data();
                        var name = data!['name'];
                        var email = data['email'];
                        var role = data['role'];
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                      'assets/images/profile_image.png',
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      name.toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      email,
                                      style: const TextStyle(
                                          color: CupertinoColors.inactiveGray),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: role == 'Teacher'
                                        ? Text(
                                            role,
                                            style: const TextStyle(
                                                color:
                                                    CupertinoColors.activeGreen,
                                                fontSize: 12),
                                          )
                                        : Text(
                                            role,
                                            style: const TextStyle(
                                                color: CupertinoColors
                                                    .activeOrange,
                                                fontSize: 12),
                                          ),
                                  ),
                                  const SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () async {
                                      goTo(context, const EditProfilePage());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff1c1c1e),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 25.0),
                                                child: Text(
                                                  'Edit Profile',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: CupertinoColors
                                                        .activeBlue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () async {
                                  signOut(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        'Sign Out',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: CupertinoColors.systemRed
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const CupertinoActivityIndicator();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
