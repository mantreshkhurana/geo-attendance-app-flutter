import 'package:flutter/material.dart';

void goTo(context, page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

void goFront(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (Route<dynamic> route) => false,
  );
}
