import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  var collection = FirebaseFirestore.instance.collection('users');
  var collection2 = FirebaseFirestore.instance.collection('classes');
  bool isPresent = false;
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                previousPageTitle: 'Home',
                largeTitle: Text(widget.className),
                middle: Text(widget.teacher),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.calendar),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      topRadius: const Radius.circular(20),
                      elevation: 5,
                      context: context,
                      builder: (context) => buildBottomPicker(
                        buildDateTimePicker(),
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: collection.doc(userUid).snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return const CupertinoActivityIndicator();
                    }

                    if (snapshot.hasData) {
                      var data = snapshot.data!.data();
                      TextEditingController studentNameController =
                          TextEditingController(text: data!['name']);

                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['role'] == 'Student',
                            child: SizedBox(
                              height: 40,
                              width: 350,
                              child: CupertinoTextField(
                                autocorrect: false,
                                controller: studentNameController,
                                autofocus: true,
                                enabled: false,
                                maxLength: 20,
                                placeholder: 'Student Name',
                                prefix: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: const Icon(
                                    CupertinoIcons.person_alt_circle,
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
                          ),
                          Visibility(
                            visible: data['role'] == 'Student',
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: collection2
                                        .doc(widget.classId)
                                        .snapshots(),
                                    builder: (_, snapshot) {
                                      if (snapshot.hasError) {
                                        return const CupertinoActivityIndicator();
                                      }

                                      if (snapshot.hasData) {
                                        var data = snapshot.data!.data();
                                        return CupertinoButton(
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 5, 30, 5),
                                          color: CupertinoColors.systemPink,
                                          onPressed: () async {
                                            // ignore: use_build_context_synchronously
                                            if (data!['latitude'] == null) {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoAlertDialog(
                                                  title: const Text(
                                                      'Attendance Not Started'),
                                                  content: const Text(
                                                      'Attendance has not started yet'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            Position position = await Geolocator
                                                .getCurrentPosition(
                                                    desiredAccuracy:
                                                        LocationAccuracy.high);
                                            double distanceInMeters =
                                                Geolocator.distanceBetween(
                                                    position.latitude,
                                                    position.longitude,
                                                    data['latitude'],
                                                    data['longitude']);
                                            if (distanceInMeters <= 100) {
                                              collection2
                                                  .doc(widget.classId)
                                                  .update({
                                                'presentStudents':
                                                    FieldValue.arrayUnion([
                                                  studentNameController.text
                                                ]),
                                                'absentStudents':
                                                    FieldValue.arrayRemove([
                                                  studentNameController.text
                                                ]),
                                              });
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoAlertDialog(
                                                  title: const Text(
                                                      'Attendance Done'),
                                                  content: const Text(
                                                      'You are marked present for this class'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              // add student in absent studnet in firestore
                                              collection2
                                                  .doc(widget.classId)
                                                  .update({
                                                'absentStudents':
                                                    FieldValue.arrayUnion([
                                                  studentNameController.text
                                                ]),
                                                'presentStudents':
                                                    FieldValue.arrayRemove([
                                                  studentNameController.text
                                                ]),
                                              });
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoAlertDialog(
                                                  title: const Text(
                                                    'Attendance Error',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .systemRed),
                                                  ),
                                                  content: const Text(
                                                      'You are not in the class'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text(
                                                        'Ok',
                                                        style: TextStyle(
                                                            color:
                                                                CupertinoColors
                                                                    .systemRed),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Mark as Present'),
                                        );
                                      }
                                      return const CupertinoActivityIndicator();
                                    }),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: data['role'] == 'Teacher',
                            child: Column(
                              children: [
                                Text(
                                  DateFormat.yMMMMd().format(dateTime),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.67,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: StreamBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                            stream: collection2
                                                .doc(widget.classId)
                                                .snapshots(),
                                            builder: (_, snapshot) {
                                              if (snapshot.hasError) {
                                                return const CupertinoActivityIndicator();
                                              }

                                              if (snapshot.hasData) {
                                                var data =
                                                    snapshot.data!.data();
                                                return ListView.builder(
                                                    itemCount:
                                                        data!['presentStudents']
                                                                .length +
                                                            data['absentStudents']
                                                                .length,
                                                    itemBuilder: (_, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Material(
                                                            child: ListTile(
                                                              leading: data['presentStudents']
                                                                          .length >
                                                                      index
                                                                  ? const Icon(
                                                                      CupertinoIcons
                                                                          .check_mark_circled_solid,
                                                                      color: CupertinoColors
                                                                          .systemGreen,
                                                                    )
                                                                  : const Icon(
                                                                      CupertinoIcons
                                                                          .xmark_circle_fill,
                                                                      color: CupertinoColors
                                                                          .systemRed,
                                                                    ),
                                                              title: Text(
                                                                data['presentStudents']
                                                                            .length >
                                                                        index
                                                                    ? data['presentStudents']
                                                                        [index]
                                                                    : data['absentStudents']
                                                                        [index -
                                                                            data['presentStudents'].length],
                                                              ),
                                                              trailing: data['presentStudents']
                                                                          .length >
                                                                      index
                                                                  ? CupertinoSwitch(
                                                                      value:
                                                                          true,
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value ==
                                                                            false) {
                                                                          collection2
                                                                              .doc(widget.classId)
                                                                              .update({
                                                                            'presentStudents':
                                                                                FieldValue.arrayRemove([
                                                                              data['presentStudents'][index]
                                                                            ]),
                                                                            'absentStudents':
                                                                                FieldValue.arrayUnion([
                                                                              data['presentStudents'][index]
                                                                            ]),
                                                                          });
                                                                        }
                                                                      },
                                                                    )
                                                                  : CupertinoSwitch(
                                                                      value:
                                                                          false,
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value ==
                                                                            true) {
                                                                          collection2
                                                                              .doc(widget.classId)
                                                                              .update({
                                                                            'absentStudents':
                                                                                FieldValue.arrayRemove([
                                                                              data['absentStudents'][index - data['presentStudents'].length]
                                                                            ]),
                                                                            'presentStudents':
                                                                                FieldValue.arrayUnion([
                                                                              data['absentStudents'][index - data['presentStudents'].length]
                                                                            ]),
                                                                          });
                                                                        }
                                                                      },
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                              return const CupertinoActivityIndicator();
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Visibility(
                            visible: data['role'] == 'Teacher',
                            child: CupertinoButton(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                              color: CupertinoColors.systemPink,
                              onPressed: () async {
                                Position position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy:
                                            LocationAccuracy.medium);

                                await FirebaseFirestore.instance
                                    .collection('classes')
                                    .doc(widget.classId)
                                    .update({
                                  'latitude': position.latitude,
                                  'longitude': position.longitude,
                                  'date': dateTime,
                                });

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .where('role', isEqualTo: 'Student')
                                    .get()
                                    .then((value) {
                                  for (var element in value.docs) {
                                    FirebaseFirestore.instance
                                        .collection('classes')
                                        .doc(widget.classId)
                                        .update({
                                      'absentStudents': FieldValue.arrayUnion(
                                          [element.data()['name']]),
                                    });
                                  }
                                });

                                await FirebaseFirestore.instance
                                    .collection('classes')
                                    .doc(widget.classId)
                                    .update({
                                  'presentStudents':
                                      FieldValue.arrayUnion([data['name']]),
                                });
                              },
                              child: const Text('Start Attendance'),
                            ),
                          ),
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
    );
  }

  Widget buildDateTimePicker() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: dateTime,
      maximumDate: DateTime.now(),
      onDateTimeChanged: (DateTime newDataTime) {
        if (mounted) {
          setState(() {
            dateTime = newDataTime;
          });
        }
      },
    );
  }

  Widget buildBottomPicker(Widget picker) {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: 6.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey.withOpacity(0.18),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: picker,
        ),
      ),
    );
  }
}
