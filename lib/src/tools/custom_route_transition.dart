import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

class CustomRouteTransition {
  static Widget drawer(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Widget? currentChild,
  ) {
    if (animation.status == AnimationStatus.reverse) {
      return PageTransition(
        type: PageTransitionType.rightToLeft,
        child: child,
      ).buildTransitions(
        context,
        secondaryAnimation,
        animation,
        child,
      );
    } else {
      final whiteOverlayAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );

      final newChild = Stack(
        children: [
          child,
          IgnorePointer(
            child: FadeTransition(
              opacity: whiteOverlayAnimation,
              child: RepaintBoundary(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ],
      );

      return PageTransition(
        type: PageTransitionType.leftToRightJoined,
        reverseType: PageTransitionType.rightToLeft,
        child: newChild,
        childCurrent: currentChild,
      ).buildTransitions(
        context,
        animation,
        secondaryAnimation,
        newChild,
      );
    }
  }

  static Widget drawerBasic(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Widget? currentChild,
  ) {
    if (animation.status == AnimationStatus.reverse) {
      return PageTransition(
        type: PageTransitionType.rightToLeft,
        child: child,
      ).buildTransitions(
        context,
        secondaryAnimation,
        animation,
        child,
      );
    } else {
      return PageTransition(
        type: PageTransitionType.leftToRightJoined,
        reverseType: PageTransitionType.rightToLeft,
        child: child,
        childCurrent: currentChild,
      ).buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }
  }
}
