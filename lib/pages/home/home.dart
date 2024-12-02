import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_mobile_app/pages/create_plan/create_plan.dart';
import 'package:project_mobile_app/pages/create_record/create_record.dart';
import 'package:project_mobile_app/pages/home/home_page.dart';
import 'package:project_mobile_app/pages/list/list.dart';
import 'package:project_mobile_app/pages/setting/setting.dart';
import 'package:project_mobile_app/pages/summary/summary.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/widgets/appbar.dart';
import 'package:project_mobile_app/widgets/colors.dart';

class Home extends StatefulWidget {
  Home({super.key, this.page});
  int? page;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List WidgetOption = [const HomePage(), const ListPage(), Summary(), const Setting()];
  List namePage = ["Home", "list", "Summary", "Setting"];
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.page != null) {
      pageIndex = widget.page!;
    }
  }

  RecordService recordService = RecordService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: pageIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateRecord()));
              },
              backgroundColor: CustomColor.primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : pageIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePlan()));
                  },
                  backgroundColor: CustomColor.primaryColor,
                  child: const Icon(
                    Icons.playlist_add_rounded,
                    color: Colors.white,
                  ),
                )
              : null,
      backgroundColor: pageIndex == 3 ?Colors.white : const Color.fromARGB(255, 243, 243, 243),
      appBar: CustomAppBar(
        title: namePage[pageIndex],
        checkPop: false,
      ),
      // AppBar(
      //   backgroundColor: Color.fromARGB(255, 77, 145, 90),
      //   elevation: 0,
      //   actions: [
      //     IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
      //   ],
      //   leading: IconButton(
      //     icon: Icon(Icons.menu),
      //     splashColor: Colors.transparent, //action หลังกดปุ่มแล้วมีกลมๆ
      //     onPressed: () => {},
      //   ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 77, 145, 90)),
        margin: EdgeInsets.only(left: 12.h, right: 12.h, bottom: 12.h),
        // Container(
        // margin: EdgeInsets.only(left: 16, right: 16),
        // decoration: BoxDecoration(
        //   color: Colors.amber,
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(200), topRight: Radius.circular(200)),
        // ),
        // child: BottomAppBar(
        //   clipBehavior: Clip.antiAlias,
        //   elevation: 0,
        //   child: Container(
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.all(Radius.circular(15.w)),
        //         boxShadow: [
        //           BoxShadow(
        //               color: Colors.grey.withOpacity(0.1),
        //               spreadRadius: 1,
        //               blurRadius: 2,
        //               offset: Offset(0, -1))
        //         ]),
        //     height: 60.h,
        // child: Row(
        //   children: [
        //     navItem(
        //       Icons.credit_card,
        //       pageIndex == 0,
        //     ),
        //     navItem(
        //       Icons.receipt,
        //       pageIndex == 1,
        //     ),
        //     navItem(
        //       Icons.auto_graph,
        //       pageIndex == 2,
        //     ),
        //     navItem(
        //       Icons.supervised_user_circle,
        //       pageIndex == 3,
        //     )
        //   ],
        // ),
        child: BottomNavigationBar(
          currentIndex: pageIndex,
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.grey[350],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: 'home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'list',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: 'summary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: 'setting',
            ),
          ],
          selectedItemColor: Colors.white,
          onTap: (value) => setState(() {
            pageIndex = value;
          }),
        ),
        // ),
        // ),
      ),
      body: Center(
        child: WidgetOption[pageIndex],
      ),
    ));
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
        child: Container(
      color: selected ? const Color.fromARGB(255, 77, 145, 90) : Colors.white,
      child: InkWell(
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    ));
  }
}
