import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/widgets/colors.dart';
import 'package:project_mobile_app/widgets/summary.dart';

class Summary extends StatelessWidget {
  Summary({super.key});
  RecordService recordService = RecordService();

  @override
  Widget build(BuildContext context) {
    recordService.setRecord();
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            child: Container(
              height: 55.h,
              color: const Color.fromARGB(255, 243, 243, 243),
              child: TabBar(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.all(10.h),
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColor.primaryColor),
                tabs: [
                  Tab(
                    child: Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Total"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Income"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Expense"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          StreamBuilder<QuerySnapshot>(
              stream: recordService.getRecordStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var recordList = snapshot.data?.docs ?? [];
                  var totalList = recordService.filttertype(recordList, "Type","Total");
                  var incomeList = recordService.filttertype(recordList, "Category","Income");
                  var expenseList = recordService.filttertype(recordList, "Category","Expense");

                  return Expanded(child: TabBarView(children: [
                    
                    ListView(
                      children: [
                        GraphSummary(recordTypeList: totalList,recordList: recordList,field: "Type",kind: "Total"),
                        Container(
                          padding: EdgeInsets.all(20.h),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: totalList.length,
                            itemBuilder: (context, index) {
                              num TotalAmount = recordService.sumTypeAmount(recordList, totalList[index]);
                          
                              return Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: RecordSummaryCard(name: totalList[index],amount: TotalAmount, color: totalList[index] == "Income" ? CustomColor.primaryColor : Color.fromARGB(255, 255, 25, 25),check: true),
                              );
                            },),
                        )
                      ],
                    ),
                    ListView(
                      children: [
                        GraphSummary(recordTypeList: incomeList,recordList: recordList,field: "Category",kind: "Income"),
                        Container(
                          padding: EdgeInsets.all(20.h),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: incomeList.length,
                            itemBuilder: (context, index) {
                              List filtterRecordList = recordService.filtterRecordCategory(recordList, incomeList[index]);
                              num TotalAmount = recordService.sumTypeAmount(filtterRecordList, "Income");
                    
                              return Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: RecordSummaryCard(name: incomeList[index],amount: TotalAmount, color: CustomColor.primaryColor),
                              );
                            },),
                        )
                      ],
                    ),
                    ListView(
                      children: [
                        GraphSummary(recordTypeList: expenseList,recordList: recordList,field: "Category",kind: "Expense"),
                        Container(
                          padding: EdgeInsets.all(20.h),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: expenseList.length,
                            itemBuilder: (context, index) {
                              List filtterRecordList = recordService.filtterRecordCategory(recordList, expenseList[index]);
                              num TotalAmount = recordService.sumTypeAmount(filtterRecordList, "Expense");
                          
                              return Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: RecordSummaryCard(name: expenseList[index],amount: TotalAmount, color: const Color.fromARGB(255, 255, 25, 25)),
                              );
                            },),
                        )
                      ],
                    )]));
                  // return Container();                  
                } else {
                  return const Text("Don't have any record");
                }
              }),
        ],
      ),
    );
  }
}
