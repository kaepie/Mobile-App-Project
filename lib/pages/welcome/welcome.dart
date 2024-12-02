import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_mobile_app/pages/welcome/bloc/welcomeBloc.dart';
import 'package:project_mobile_app/pages/welcome/bloc/welcomeEvent.dart';
import 'package:project_mobile_app/pages/welcome/bloc/welcomeState.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          return Container(
            width: 375.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    state.page = index;
                    BlocProvider.of<WelcomeBloc>(context).add(WelcomeEvent());
                  },
                  children: [
                    _page(0, context, "Next", "HI 1", "Good Luck", "1"),
                    _page(1, context, "Next", "HI 2", "Good Job", "2"),
                    _page(2, context, "Go", "HI 3", "Good to see you", "3")
                  ],
                ),
                Positioned(
                    bottom: 100.h,
                    child: DotsIndicator(
                      position: state.page,
                      dotsCount: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      decorator: DotsDecorator(
                          activeColor: Colors.green,
                          color: Colors.grey,
                          size: Size.square(7),
                          activeSize: Size(18, 8),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ))
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _page(int index, BuildContext context, String buttonName, String title,
      String subTitle, String image) {
    return Column(
      children: [
        SizedBox(
          width: 345.w,
          height: 345.w,
          child: Text(""),
        ),
        Container(
          child: Text(title),
        ),
        Container(
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Text(subTitle),
        ),
        GestureDetector(
          onTap: () {
            if (index < 2) {
              pageController.animateToPage(index + 1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
            } else {
              Navigator.pushNamed(context, 'login');
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 100.h),
            width: 325.w,
            height: 50.h,
            decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.all(Radius.circular(15.w)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, -1))
                ]),
            child: Center(
                child: Text(
              buttonName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
              ),
            )),
          ),
        )
      ],
    );
  }
}
