import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Navigation {

  static void push({
    required BuildContext context,
    required Widget child, 
    Duration duration = const Duration(milliseconds: 50),
    dynamic pageTransitionType = PageTransitionType.rightToLeft
  }) {
    Navigator.push(context, PageTransition(child: child, type: pageTransitionType, duration: duration));
  }

  static void pushReplacement({
    required BuildContext context,
    required Widget child, 
    Duration duration = const Duration(milliseconds: 50),
    dynamic pageTransitionType = PageTransitionType.rightToLeft
  }) {
    Navigator.pushReplacement(context, PageTransition(child: child, type: pageTransitionType, duration: duration));
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

}