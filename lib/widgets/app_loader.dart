import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;
  final bool isFitted;

  const AppLoader({
    Key key,
    this.color = Colors.deepPurpleAccent,
    this.size = 50.0,
    this.isFitted = false,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFitted
        ? FittedBox(
            fit: BoxFit.fitWidth,
            child: SpinKitThreeBounce(
              color: color,
              size: size,
              duration: duration,
            ),
          )
        : SpinKitThreeBounce(
            color: color,
            size: size,
            duration: duration,
          );
  }
}
