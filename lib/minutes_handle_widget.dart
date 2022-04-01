import 'dart:math';

import 'package:flutter/material.dart';

import 'analog_clock_picker.dart';

class MinutesHandleWidget extends StatelessWidget {
  final Color handleColor;
  final double handleHeight;
  final AnimationController controller;
  final Function(int minute) onDragHandleEnd;
  final Offset centerPosition;
  final Widget? handleWidget;

  const MinutesHandleWidget({
    Key? key,
    required this.handleColor,
    required this.handleHeight,
    required this.controller,
    required this.onDragHandleEnd,
    required this.centerPosition,
    this.handleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, value) => Transform.rotate(
        angle: controller.value / 180 * pi,
        child: GestureDetector(
          onPanEnd: (end) {
            stickyMinuteHand();
          },
          onPanUpdate: (pan) {
            controller.value = calculateAngle(
              centerPosition,
              pan.globalPosition,
            );

            onDragHandleEnd(((controller.value / 360) * 60).toInt());
          },
          child: Container(
            margin: EdgeInsets.only(bottom: handleHeight),
            child: Container(
              //transparent container with horizontal margin for expand handle touch area
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: handleWidget != null
                  ? SizedBox(
                      height: handleHeight,
                      child: handleWidget,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: handleColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 8,
                      height: handleHeight,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  //Logic for sticky minute handle
  void stickyMinuteHand() {
    //search angle beetween all possible angles
    for (int i = 0; i < minutesAngles.length; i++) {
      if (i < minutesAngles.length - 1) {
        double angle1 = minutesAngles[i];
        double angle2 = minutesAngles[i + 1];

        if (controller.value > angle1 && controller.value < angle2) {
          //calculate current hand angle distance beetween previous and next possible angle
          double angleDistance1 = (controller.value - angle1).abs();
          double angleDistance2 = (controller.value - angle2).abs();

          //assign the closest possible angle from current hand angle
          if (angleDistance1 > angleDistance2) {
            controller
                .animateTo(angle2, duration: const Duration(milliseconds: 100))
                .whenComplete(() {
              onDragHandleEnd(((controller.value / 360) * 60).toInt());
            });
          } else {
            controller
                .animateTo(angle1, duration: const Duration(milliseconds: 100))
                .whenComplete(() {
              onDragHandleEnd(((controller.value / 360) * 60).toInt());
            });
          }

          break;
        }
      }
    }
  }
}
