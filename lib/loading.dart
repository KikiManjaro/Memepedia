import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memepedia/theme.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: 25,
      color: AppTheme.BrightAccent,
    );
  }
}
