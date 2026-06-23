import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizingExtensions on num {
  Widget get vS => SizedBox(height: h);
  Widget get hS => SizedBox(width: w);
}
