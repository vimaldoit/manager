import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Vspace extends StatelessWidget {
  final double vspace;
  const Vspace(this.vspace, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: ScreenUtil().setHeight(vspace));
  }
}
