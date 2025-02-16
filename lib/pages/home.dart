import 'package:attendance/functions/class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../screens/screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var collection = FirebaseFirestore.instance.collection('users');
  var collection2 =
      FirebaseFirestore.instance.collection('classes').snapshots();
  TextEditingController classNameController = TextEditingController();
  TextEditingController yearNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Home'),
                leading: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: collection.doc(userUid).snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        return const CupertinoActivityIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: SizedBox());
                      } else if (snapshot.hasData) {
                        var data = snapshot.data!.data();

                        return Visibility(
                          visible: data!['role'] == 'Teacher',
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.plus, size: 27),
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                topRadius: const Radius.circular(20),
                                elevation: 5,
                                context: context,
                                builder: (context) => KeyboardDismisser(
                                  gestures: const [
                                    GestureType.onTap,
                                    GestureType.onPanUpdateDownDirection
                                  ],
                                  child: Container(
                                    height: 600,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.18),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            'Add Class',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Center(
                                            child: StreamBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                              stream: collection
                                                  .doc(userUid)
                                                  .snapshots(),
                                              builder: (_, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const CupertinoActivityIndicator();
                                                }

                                                if (snapshot.hasData) {
                                                  var data =
                                                      snapshot.data!.data();
                                                  TextEditingController
                                                      teacherNameController =
                                                      TextEditingController(
                                                          text: data!['name']);

                                                  return Column(
                                                    children: [
                                                      const SizedBox(
                                                          height: 20),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 350,
                                                        child:
                                                            CupertinoTextField(
                                                          enabled: false,
                                                          autocorrect: false,
                                                          controller:
                                                              teacherNameController,
                                                          autofocus: true,
                                                          maxLength: 20,
                                                          placeholder:
                                                              'Teacher Name',
                                                          prefix:
                                                              CupertinoButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .person_crop_circle,
                                                              size: 23,
                                                              color:
                                                                  CupertinoColors
                                                                      .systemGrey,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .systemGrey6,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 350,
                                                        child:
                                                            CupertinoTextField(
                                                          autocorrect: false,
                                                          controller:
                                                              classNameController,
                                                          autofocus: true,
                                                          maxLength: 20,
                                                          placeholder:
                                                              'Class Name',
                                                          prefix:
                                                              CupertinoButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .book,
                                                              size: 23,
                                                              color:
                                                                  CupertinoColors
                                                                      .systemGrey,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .systemGrey6,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 350,
                                                        child:
                                                            CupertinoTextField(
                                                          autocorrect: false,
                                                          controller:
                                                              branchNameController,
                                                          maxLength: 20,
                                                          placeholder:
                                                              'Branch Name',
                                                          prefix:
                                                              CupertinoButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .arrow_branch,
                                                              size: 23,
                                                              color:
                                                                  CupertinoColors
                                                                      .systemGrey,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .systemGrey6,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 350,
                                                        child:
                                                            CupertinoTextField(
                                                          autocorrect: false,
                                                          controller:
                                                              yearNameController,
                                                          maxLength: 20,
                                                          placeholder: 'Year',
                                                          prefix:
                                                              CupertinoButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .calendar,
                                                              size: 23,
                                                              color:
                                                                  CupertinoColors
                                                                      .systemGrey,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    "[0-9]")),
                                                          ],
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .systemGrey6,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      CupertinoButton(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                30, 5, 30, 5),
                                                        color: CupertinoColors
                                                            .systemPink,
                                                        onPressed: () async {
                                                          await addClass(
                                                            classNameController
                                                                .text,
                                                            teacherNameController
                                                                .text,
                                                            branchNameController
                                                                .text,
                                                            yearNameController
                                                                .text,
                                                          );
                                                          classNameController
                                                              .clear();
                                                          branchNameController
                                                              .clear();
                                                          yearNameController
                                                              .clear();

                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Add Class'),
                                                      ),
                                                      const SizedBox(
                                                          height: 50),
                                                    ],
                                                  );
                                                }
                                                return const CupertinoActivityIndicator();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child:
                      const Icon(CupertinoIcons.person_crop_circle, size: 27),
                  onPressed: () {
                    goTo(context, const ProfilePage());
                  },
                ),
              ),
            ];
          },
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: collection.doc(userUid).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasData) {
                  var data = snapshot.data!.data();
                  var role = data!['role'];
                  return Column(
                    children: [
                      role == 'Teacher'
                          ? Visibility(
                              visible: role == 'Teacher',
                              child: Expanded(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('classes')
                                      .orderBy(
                                        'createdAt',
                                        descending: true,
                                      )
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                                    } else if (snapshot.data!.docs.isEmpty) {
                                      return Visibility(
                                        visible: data['email'] == userEmail,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Image.asset(
                                                    'assets/images/empty.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              const Text(
                                                'No Classes Yet',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                            Map<String, dynamic> data = document
                                                .data() as Map<String, dynamic>;
                                            return Center(
                                              child: Column(
                                                children: [
                                                  Visibility(
                                                    visible: data['email'] ==
                                                        userEmail,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ClassPage(
                                                              data['teacher'],
                                                              data[
                                                                  'class_name'],
                                                              data['classId'],
                                                              data['createdAt'],
                                                              data['branch'],
                                                              data['year'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 200,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.18),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 0,
                                                              blurRadius: 7,
                                                              offset:
                                                                  const Offset(
                                                                      0, 0),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/background.jpg',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                CupertinoButton(
                                                                  child: Icon(
                                                                    CupertinoIcons
                                                                        .delete_simple,
                                                                    color: CupertinoColors
                                                                        .systemBlue
                                                                        .withOpacity(
                                                                            0.4),
                                                                    size: 19,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showCupertinoDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return CupertinoAlertDialog(
                                                                          title:
                                                                              const Text(
                                                                            'Delete Class',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          content:
                                                                              const Text(
                                                                            'Are you sure you want to delete this class?',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            CupertinoDialogAction(
                                                                              child: const Text(
                                                                                'Cancel',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                            CupertinoDialogAction(
                                                                              child: const Text(
                                                                                'Delete',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: CupertinoColors.systemRed,
                                                                                ),
                                                                              ),
                                                                              onPressed: () async {
                                                                                await deleteClass(data['classId']);
                                                                                // ignore: use_build_context_synchronously
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5,
                                                                        left:
                                                                            15),
                                                                child: SizedBox(
                                                                  height: 50,
                                                                  width: 300,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            data['class_name'],
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 21,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              15),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            data['teacher'],
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : Visibility(
                              visible: role == 'Student',
                              // && data2['year'] == 36@year'] &&
                              // data2['branch'] == data['branch'],
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('classes')
                                    .orderBy(
                                      'createdAt',
                                      descending: true,
                                    )
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox(
                                              height: 200,
                                              width: 200,
                                              child: Image.asset(
                                                'assets/images/empty.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            'No Classes Yet',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                            children: snapshot.data!.docs.map(
                                                (DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()
                                                      as Map<String, dynamic>;

                                              return Column(
                                                children: [
                                                  Visibility(
                                                    visible: true,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ClassPage(
                                                              data['teacher'],
                                                              data[
                                                                  'class_name'],
                                                              data['classId'],
                                                              data['createdAt'],
                                                              data['branch'],
                                                              data['year'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 200,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.18),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 0,
                                                              blurRadius: 7,
                                                              offset:
                                                                  const Offset(
                                                                      0, 0),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/background.jpg',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5,
                                                                        left:
                                                                            15),
                                                                child: SizedBox(
                                                                  height: 50,
                                                                  width: 300,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            data['class_name'],
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 21,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              15),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            data['teacher'],
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  );
                }
                return const CupertinoActivityIndicator();
              }),
        ),
      ),
    );
  }
}
