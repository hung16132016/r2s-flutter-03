import 'package:flutter/cupertino.dart';

class Animations {
  static PageRouteBuilder createSlideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const beginOffset = Offset(0, 1);
        const endOffset = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween<Offset>(
          begin: beginOffset,
          end: endOffset,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
