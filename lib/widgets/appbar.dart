import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  CustomAppBar({super.key, required this.title, required this.checkPop});
  bool checkPop;
  String title;
  @override
  Widget build(BuildContext context) {
    return
        AppBar(
          backgroundColor: const Color.fromARGB(255, 77, 145, 90),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: checkPop,
          centerTitle: true,
          title: Text(title),
          
        );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(
        double.maxFinite,
        50.h,
      );
}
