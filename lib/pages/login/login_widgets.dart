import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_mobile_app/Widgets/colors.dart';

Widget reuseableText(String text) {
  return Container(
    margin: EdgeInsets.only(top: 5.h, bottom: 10.h),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.grey.withOpacity(0.5),
        fontWeight: FontWeight.normal,
        fontSize: 14.sp,
      ),
    ),
  );
}

Widget buildTextField(
    String text, FaIcon icon, String type, TextEditingController controller) {
  return Container(
      width: 325.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15.w)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          icon,
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 270.w,
            height: 50.h,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              obscureText: type == "Email" ? false : true,
              decoration: InputDecoration(
                hintText: text,
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          )
        ],
      ));
}

Widget signUpButton() {
  return GestureDetector(
    
    child: Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 10.h),
      child: Text(
        "Sign up",
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: CustomColor.primaryColor,
          color: CustomColor.primaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}

Widget loginButton(String text, Color color) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    width: 325.w,
    height: 50.h,
    decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(15.w)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, -1))
        ]),
    child: Center(
        child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 16.sp,
      ),
    )),
  );
}
