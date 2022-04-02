// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:analog_clock_picker/analog_clock_picker.dart';
import 'package:flutter/material.dart';

class ClockBackgroundWidget extends StatelessWidget {
  final double radius;
  final TextStyle? textStyle;
  final Color? minuteStickColor;
  final Color? hourStickColor;

  const ClockBackgroundWidget({
    Key? key,
    required this.radius,
    this.textStyle,
    this.minuteStickColor = Colors.black,
    this.hourStickColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (double angle in minutesAngles.sublist(1, minutesAngles.length))
          Transform.rotate(
            angle: angle * pi / 180,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: radius * 0.024,
                    ),
                    width: 2,
                    height: radius * 0.04,
                    color: minuteStickColor,
                  ),
                ],
              ),
            ),
          ),
        for (double angle in hourAngles.sublist(1, hourAngles.length))
          Transform.rotate(
            angle: angle * pi / 180,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: radius * 0.024,
                    ),
                    width: 4,
                    height: radius * 0.08,
                    color: hourStickColor,
                  ),
                  Text(
                    "${angle ~/ 30}",
                    style: textStyle ??
                        const TextStyle(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
