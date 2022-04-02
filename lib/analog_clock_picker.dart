library analog_clock_picker;

import 'dart:math';

import 'package:analog_clock_picker/clock_background_widget.dart';
import 'package:analog_clock_picker/hour_handle_widget.dart';
import 'package:analog_clock_picker/minutes_handle_widget.dart';
import 'package:analog_clock_picker/second_handle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//generate minutes angle
final List<double> minutesAngles = [for (int i = 0; i <= 60; i++) i * 6];
//generate hour angle
final List<double> hourAngles = [for (int i = 0; i <= 12; i++) i * 30];

//Formula for calculating angle from two points
double calculateAngle(Offset origin, Offset target) {
  var dx = origin.dx - target.dx;
  var dy = origin.dy - target.dy;

  var theta = atan2(-dy, -dx);
  theta *= 180 / pi;
  theta += 90;
  if (theta < 0) theta += 360;

  return theta;
}

enum PeriodType {
  am,
  pm,
}

class AnalogClockController extends ValueNotifier<DateTime> {
  PeriodType? _periodType;
  PeriodType? get periodType => _periodType;
  Function(DateTime dateTime, PeriodType periodType)? onPeriodTypeChange;

  void setOnPeriodTypeChangeListener(
    Function(DateTime dateTime, PeriodType periodType) listener,
  ) {
    onPeriodTypeChange = listener;
  }

  void setPeriodType(PeriodType periodType) {
    _periodType = periodType;
    DateTime newDate = DateTime(
      value.year,
      value.month,
      value.day,
      periodType == PeriodType.am
          ? (value.hour > 12 ? value.hour - 12 : value.hour)
          : (value.hour > 12 ? value.hour : value.hour + 12),
      value.minute,
      0,
    );
    value = newDate;
    if (onPeriodTypeChange != null) onPeriodTypeChange!(newDate, periodType);
  }

  AnalogClockController({
    DateTime? value,
    PeriodType? periodType = PeriodType.am,
    this.onPeriodTypeChange,
  }) : super(value ?? DateTime.now()) {
    _periodType = periodType;
  }
}

class AnalogClockPicker extends StatefulWidget {
  final double size;
  final Color clockBackgroundColor;
  final Color secondHandleColor;
  final Color minutesHandleColor;
  final Color hourHandleColor;
  final Widget? clockBackground;
  final Widget? secondHandleWidget;
  final Widget? minutesHandleWidget;
  final Widget? hourHandleWidget;
  final Widget? ringWidget;
  final AnalogClockController controller;
  final Function(DateTime dateTime)? onClockChange;
  final TextStyle? clockTextStyle;
  final Color? minuteStickColor;
  final Color? hourStickColor;

  const AnalogClockPicker({
    Key? key,
    required this.controller,
    required this.size,
    this.onClockChange,
    this.secondHandleColor = Colors.white,
    this.minutesHandleColor = Colors.white,
    this.hourHandleColor = Colors.white,
    this.clockBackgroundColor = Colors.white,
    this.clockBackground,
    this.secondHandleWidget,
    this.minutesHandleWidget,
    this.hourHandleWidget,
    this.ringWidget,
    this.clockTextStyle,
    this.minuteStickColor = Colors.black,
    this.hourStickColor = Colors.black,
  }) : super(key: key);

  @override
  State<AnalogClockPicker> createState() => _AnalogClockPickerState();
}

class _AnalogClockPickerState extends State<AnalogClockPicker>
    with TickerProviderStateMixin {
  GlobalKey key = GlobalKey();

  late AnimationController hourAngle;
  late AnimationController minutesAngle;
  Offset? centerPosition;
  double radius = 0;
  RenderBox? box;

  @override
  void initState() {
    super.initState();
    if (widget.controller.value.hour > 12) {
      widget.controller.setPeriodType(PeriodType.pm);
    }
    hourAngle = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 360,
    );
    minutesAngle = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 360,
    );
    if (widget.controller.value.hour > 12) {
      hourAngle.value = (widget.controller.value.hour - 12) * 30;
    } else {
      hourAngle.value = widget.controller.value.hour * 30;
    }
    minutesAngle.value = widget.controller.value.minute * 6;

    radius = widget.size / 2;

    SchedulerBinding.instance?.addPostFrameCallback((_) async {
      if (key.currentContext != null) {
        box = key.currentContext?.findRenderObject() as RenderBox;
      }
      Offset? position = box?.localToGlobal(Offset.zero);

      setState(() {
        centerPosition = Offset(
          (position?.dx ?? 0) + (widget.size / 2),
          (position?.dy ?? 0) + (widget.size / 2),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    radius = widget.size / 2;

    return SizedBox(
      key: key,
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.clockBackgroundColor,
            ),
            width: widget.size + 10,
            height: widget.size + 10,
          ),
          widget.clockBackground ??
              ClockBackgroundWidget(
                radius: radius,
                textStyle: widget.clockTextStyle,
                hourStickColor: widget.hourStickColor,
                minuteStickColor: widget.minuteStickColor,
              ),
          SecondHandleWidget(
            handleHeight: radius * 0.68,
            handleColor: widget.secondHandleColor,
            handleWidget: widget.secondHandleWidget,
          ),
          HourHandleWidget(
            handleColor: widget.hourHandleColor,
            handleHeight: radius * 0.56,
            controller: hourAngle,
            onDragHandleEnd: (hour) {
              widget.controller.value = DateTime(
                widget.controller.value.year,
                widget.controller.value.month,
                widget.controller.value.day,
                widget.controller.periodType == PeriodType.am
                    ? hour
                    : hour + 12,
                widget.controller.value.minute,
                0,
              );
              if (widget.onClockChange != null) {
                widget.onClockChange!(widget.controller.value);
              }
            },
            centerPosition: centerPosition ?? Offset.zero,
            handleWidget: widget.hourHandleWidget,
            radius: radius,
          ),
          MinutesHandleWidget(
            handleColor: widget.minutesHandleColor,
            handleHeight: radius * 0.68,
            controller: minutesAngle,
            onDragHandleEnd: (minute) {
              widget.controller.value = DateTime(
                widget.controller.value.year,
                widget.controller.value.month,
                widget.controller.value.day,
                widget.controller.value.hour,
                minute,
                0,
              );
              if (widget.onClockChange != null) {
                widget.onClockChange!(widget.controller.value);
              }
            },
            centerPosition: centerPosition ?? Offset.zero,
            handleWidget: widget.minutesHandleWidget,
            radius: radius,
          ),
          widget.ringWidget != null
              ? SizedBox(
                  width: radius * 0.16,
                  height: radius * 0.16,
                  child: widget.ringWidget,
                )
              : Container(
                  width: radius * 0.16,
                  height: radius * 0.16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: radius * 0.04,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
