import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Hspace extends StatelessWidget {
  const Hspace(this.hspace, {super.key});
  final double hspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: ScreenUtil().setWidth(hspace));
  }
}
