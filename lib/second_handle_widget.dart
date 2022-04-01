import 'package:flutter/material.dart';

class SecondHandleWidget extends StatelessWidget {
  final Color handleColor;
  final double handleHeight;
  final Widget? handleWidget;

  const SecondHandleWidget({
    Key? key,
    this.handleColor = Colors.red,
    this.handleWidget,
    required this.handleHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return handleWidget ??
        Container(
          decoration: BoxDecoration(
            color: handleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(bottom: handleHeight),
          width: 3,
          height: handleHeight,
        );
  }
}
