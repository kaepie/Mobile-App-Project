import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_mobile_app/pages/create_plan/create_plan.dart';
import 'package:project_mobile_app/services/plan_service.dart';
import 'package:project_mobile_app/widgets/colors.dart';

class WalletCard extends StatelessWidget {
  WalletCard({super.key, required this.money});

  num money = 0.00;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185.h,
      width: 300.h,
      decoration: BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ]),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.h, top: 15.h),
            child: Column(
              children: [
                Text(
                  "Account",
                  style: TextStyle(fontSize: 12.h, color: Colors.grey[300]),
                ),
                const Text(
                  "MY ACCOUNT",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 130.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                      color: CustomColor.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.h)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Money",
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                        Text(
                          money.toStringAsFixed(2),
                          softWrap: false,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontSize: 15.h,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListCategory extends StatelessWidget {
  ListCategory({super.key, required this.income, required this.expense});

  num income = 0.00;
  num expense = 0.00;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15),
          // boxShadow: [
          //   BoxShadow(color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: Offset(0, 3),)]
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_rounded,
                        color: CustomColor.primaryColor,
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      const Text("income")
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "THB $income",
                        style: TextStyle(color: CustomColor.primaryColor),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 40.h,
                child: Divider(
                  height: 1.h,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_rounded,
                        color: Color.fromARGB(255, 255, 25, 25),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      const Text("Expense")
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "THB $expense",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 25, 25)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class CustomContainer extends StatelessWidget {
  CustomContainer({super.key, required this.child, this.margin});

  Widget child;
  EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      margin: margin,
      child: child,
    );
  }
}

class ShowPlan extends StatefulWidget {
  ShowPlan({super.key, required this.docId, required this.recordList});
  String docId;
  List recordList;

  @override
  State<ShowPlan> createState() => _ShowPlanState();
}

class _ShowPlanState extends State<ShowPlan> {
  PlanService planService = PlanService();
  var format = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planService.setPlan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: planService.getDataPlan(widget.docId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String name = data['Name'];
          String description = data['Description'];
          num target = data['Target'];
          DateTime startDate = format.parse(data['StartDate']);
          DateTime endDate = format.parse(data['EndDate']);
          double percent = planService.percentPlan(
              widget.recordList, startDate, endDate, target);

          return Slidable(
              startActionPane: ActionPane(motion: BehindMotion(), children: [
                SlidableAction(
                    backgroundColor: CustomColor.primaryColor,
                    icon: Icons.edit,
                    onPressed: (context) => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePlan(
                                        docId: widget.docId,
                                      )))
                        })
              ]),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) =>
                          {planService.deletePlan(widget.docId)})
                ],
              ),
              child: Center(
                child: Container(
                  width: 300.w,
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  margin: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                        )
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.h, left: 15.w, right: 15.w, bottom: 15.h),
                        child: Text(
                          "$name ${target.toStringAsFixed(2)} ${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}",
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 70.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: percent,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${(percent * 100).toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 20.0),
                            ),
                            (percent * 100) >= 70
                                ? Icon(Icons.sentiment_satisfied_alt,
                                    color: CustomColor.primaryColor, size: 30.h)
                                : (percent * 100) >= 40
                                    ? Icon(
                                        Icons.sentiment_neutral,
                                        color: Colors.amber,
                                        size: 30.h,
                                      )
                                    : Icon(Icons.sentiment_dissatisfied_outlined,
                                        color: Colors.red, size: 30.h),
                          ],
                        ),
                        footer: Text(
                          description,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: (percent * 100) >= 70
                            ? CustomColor.primaryColor
                            : (percent * 100) >= 40
                                ? Colors.amber
                                : Colors.red,
                      ),
                    ],
                  ),
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }
}
