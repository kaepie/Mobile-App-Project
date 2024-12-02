import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_mobile_app/services/home_service.dart';
import 'package:project_mobile_app/services/plan_service.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/widgets/home_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeService homeService = HomeService();
  RecordService recordService = RecordService();
  PlanService planService = PlanService();
  num amount = 0;
  var format = DateFormat("yyyy-MM-dd");
  String dropDownMonth = "${DateTime.now().month}";
  String dropDownYear = "1";

  @override
  void initState() {
    super.initState();
    planService.setPlan();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
            future: homeService.getUserAmount(),
            builder: (context1, snapshot1) {
              recordService.setRecord();
              planService.setPlan();
              if (snapshot1.hasData) {
                return StreamBuilder(
                    stream: recordService.getRecordStream(),
                    builder: (context2, snapshot2) {
                      if (snapshot2.hasData) {
                        var recordList = snapshot2.data?.docs ?? [];
                        var todayRecordList =
                            recordService.checkTime(recordList, "today");
                        var thisMonthRecordList = recordService.checkMonth(
                            recordList, int.parse(dropDownMonth));
                        var thisYearRecordList = recordService.checkYear(
                            recordList,
                            dropDownYear == "1"
                                ? 2024
                                : dropDownYear == "2"
                                    ? 2023
                                    : dropDownYear == "3"
                                        ? 2022
                                        : dropDownYear == "4"
                                            ? 2021
                                            : dropDownYear == "5"
                                                ? 2020
                                                : 2024);
                        updateAmount(recordList);
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20.h,
                            ),
                            Center(
                              child: WalletCard(money: amount),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            StreamBuilder(
                              stream: planService.getPlans(),
                              builder: (context3, snapshot3) {
                                if (snapshot3.hasData) {
                                  var planList = snapshot3.data?.docs ?? [];
                                  if (planList.isNotEmpty) {
                                    return Column(
                                                                            children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.h,
                                          right: 20.h,
                                          bottom: 10.h),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Plan",
                                          style:
                                              TextStyle(fontSize: 18.h),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    CarouselSlider.builder(
                                      itemCount: planList.length,
                                      itemBuilder:
                                          (context, index, realIndex) {
                                        DocumentSnapshot doucument =
                                            planList[index];
                                        String docId = doucument.id;
                                        return ShowPlan(
                                          docId: docId,
                                          recordList: recordList,
                                        );
                                      },
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 10),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 1000),
                                        autoPlayCurve:
                                            Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        viewportFraction: 0.9,
                                        aspectRatio: 2.0,
                                        height: 210.h,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        scrollDirection: Axis.vertical,
                                      ),
                                    )
                                                                            ],
                                                                          );
                                  }else{
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                        width: 320.w,
                                        height: 60.h,
                                      child: Center(
                                        child: Text(
                                          "Start Your Plan Now!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                                                          ),
                                    );
                                  }
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                        width: 320.w,
                                        height: 60.h,
                                      child: Center(
                                        child: Text(
                                          "Start Your Plan Now!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20.h, right: 20.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Today",
                                  style: TextStyle(fontSize: 18.h),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.h),
                              child: ListCategory(
                                income: recordService.sumTypeAmount(
                                    todayRecordList, "Income"),
                                expense: recordService.sumTypeAmount(
                                    todayRecordList, "Expense"),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20.h, right: 20.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Month",
                                      style: TextStyle(fontSize: 18.h),
                                      textAlign: TextAlign.left,
                                    ),
                                    DropdownButton<String>(
                                      menuMaxHeight:
                                          100.h, // dropdown income expense
                                      underline: Container(
                                        height: 10.h,
                                      ),
                                      value: dropDownMonth,
                                      items: const [
                                        DropdownMenuItem(
                                            value: '1',
                                            child: Text("January")),
                                        DropdownMenuItem(
                                            value: '2',
                                            child: Text("February")),
                                        DropdownMenuItem(
                                            value: '3', child: Text("March")),
                                        DropdownMenuItem(
                                            value: '4', child: Text("April")),
                                        DropdownMenuItem(
                                            value: '5', child: Text("May")),
                                        DropdownMenuItem(
                                            value: "6", child: Text("June")),
                                        DropdownMenuItem(
                                            value: "7", child: Text("July")),
                                        DropdownMenuItem(
                                            value: "8",
                                            child: Text("August")),
                                        DropdownMenuItem(
                                            value: "9",
                                            child: Text("September")),
                                        DropdownMenuItem(
                                            value: "10",
                                            child: Text("October")),
                                        DropdownMenuItem(
                                            value: "11",
                                            child: Text("November")),
                                        DropdownMenuItem(
                                            value: "12",
                                            child: Text("December")),
                                      ],
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropDownMonth = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.h),
                              child: ListCategory(
                                income: recordService.sumTypeAmount(
                                    thisMonthRecordList, "Income"),
                                expense: recordService.sumTypeAmount(
                                    thisMonthRecordList, "Expense"),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20.h, right: 20.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Year",
                                      style: TextStyle(fontSize: 18.h),
                                      textAlign: TextAlign.left,
                                    ),
                                    DropdownButton<String>(
                                      menuMaxHeight:
                                          100.h, // dropdown income expense
                                      underline: Container(
                                        height: 10.h,
                                      ),
                                      value: dropDownYear,
                                      items: const [
                                        DropdownMenuItem(
                                            value: '1', child: Text("2024")),
                                        DropdownMenuItem(
                                            value: '2', child: Text("2023")),
                                        DropdownMenuItem(
                                            value: '3', child: Text("2022")),
                                        DropdownMenuItem(
                                            value: '4', child: Text("2021")),
                                        DropdownMenuItem(
                                            value: '5', child: Text("2020")),
                                      ],
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropDownYear = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.h),
                              child: ListCategory(
                                income: recordService.sumTypeAmount(
                                    thisYearRecordList, "Income"),
                                expense: recordService.sumTypeAmount(
                                    thisYearRecordList, "Expense"),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Align(
                            alignment: AlignmentDirectional.center,
                            child: CircularProgressIndicator());
                      }
                    });
              } else {
                return const Align(
                    alignment: AlignmentDirectional.center,
                    child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Future<void> updateAmount(List recordList) async {
    setState(() {
      amount = recordService.calculatorAmountUser(recordList);
      homeService.updateAmount(amount);
    });
  }
}
