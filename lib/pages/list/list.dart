import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_mobile_app/pages/create_record/create_record.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/widgets/colors.dart';
import 'package:project_mobile_app/widgets/list.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  final RecordService recordService = RecordService();

  @override
  initState() {
    super.initState();
    recordService.setRecord();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                        child: Text("Today"),
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
                  var todayRecordList =
                      recordService.checkTime(recordList, "today");
                  return Expanded(
                      child: TabBarView(children: [
                    ListView.builder(
                      itemCount: recordList.length,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        DocumentSnapshot doucument = recordList[index];
                        Map<String, dynamic> data =
                            doucument.data() as Map<String, dynamic>;
                        String type = data['Type'];
                        String docId = doucument.id;
                        return Slidable(
                            startActionPane: ActionPane(
                                motion: const BehindMotion(), children: [SlidableAction(
                                    backgroundColor: CustomColor.primaryColor,
                                    icon: Icons.edit,
                                    onPressed: (context) =>
                                        {Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRecord(docId: docId,)))})]),
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (context) =>
                                        {recordService.deleteRecord(docId)})
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: RecordCard(
                                  docId: docId,
                                  color: type == "Income"
                                      ? const Color.fromARGB(255, 77, 145, 90)
                                      : const Color.fromARGB(255, 255, 25, 25)),
                            ));
                      },
                    ),
                    ListView.builder(
                      itemCount: todayRecordList.length,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        DocumentSnapshot doucument = todayRecordList[index];
                        Map<String, dynamic> data =
                            doucument.data() as Map<String, dynamic>;
                        String type = data['Type'];
                        String docId = doucument.id;
                        return Slidable(
                            startActionPane: ActionPane(
                                motion: const BehindMotion(), children: [SlidableAction(
                                    backgroundColor: CustomColor.primaryColor,
                                    icon: Icons.edit,
                                    onPressed: (context) =>
                                        {Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRecord(docId: docId,)))})]),
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (context) =>
                                        {recordService.deleteRecord(docId)})
                              ],
                            ),
                            child: Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: RecordCard(
                              docId: docId,
                              color: type == "Income"
                                  ? const Color.fromARGB(255, 77, 145, 90)
                                  : const Color.fromARGB(255, 255, 25, 25)),
                        ));
                      },
                    ),
                  ]));
                } else {
                  return const Text("Don't have any record");
                }
              }),

          // Expanded(
          //   child: TabBarView(
          //     children: [
          //       StreamBuilder <QuerySnapshot> (
          //         stream: recordService.getRecordStream(),
          //         builder: (context, snapshot) {
          //           if (snapshot.hasData){
          //             var recordList = snapshot.data?.docs ?? [];

          //             return ListView.builder(
          //               itemCount: recordList.length,
          //               padding: EdgeInsets.all(15),
          //               itemBuilder: (context, index) {
          //                 DocumentSnapshot doucument = recordList[index];
          //                 Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
          //                 String amount = data['Amount'].toString();
          //                 return Padding(padding: EdgeInsets.only(bottom: 5.h), child: RecordCard(amount: amount),);
          //               },
          //             );
          //           }
          //           else{
          //             return const Text("Don't have any record");
          //           }
          //         }
          //         ),
          //         ListView.builder(
          //         itemCount: record.length,
          //         padding: EdgeInsets.all(15),
          //         itemBuilder: (context, index) {
          //           return Padding(padding: EdgeInsets.only(bottom: 5.h), child: RecordCard(amount: record[index]),);
          //         },
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
