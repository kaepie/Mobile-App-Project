import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:project_mobile_app/services/category_service.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/Widgets/colors.dart';

class RecordCard extends StatefulWidget {
  RecordCard({
    super.key,
    this.docId,
    // required this.category,
    // required this.amount,
    this.color,
    // required this.date,
    // required this.description,
    // required this.relatedPeople
  });
  String? docId;
  Color? color;
  // String category;
  // Color color;
  // num amount;
  // DateTime date;
  // String description;
  // String relatedPeople;

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  RecordService recordService = RecordService();
  CategoryService categoryService = CategoryService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recordService.setRecord();
    categoryService.setCategory();
  }

  num amount = 0.00;
  String category = "";
  DateTime date = DateTime.now();
  String description = "";
  String relatedPeople = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recordService.getDataRecord(widget.docId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            amount = data['Amount'];
            category = data['Category'];
            date = DateFormat("yyyy-MM-dd").parse(data['Date']);
            description = data['Description'];
            relatedPeople = data['Related People'];
            String? image = data['Image'];
            
            return StreamBuilder<QuerySnapshot>(
              stream: categoryService.getCategories(),
              builder: (context2, snapshot2) {
                var categoryList = snapshot2.data?.docs ?? [];
                String name = categoryService.getIconNameWithCategoryName(categoryList, category);
                return GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.6),
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            backgroundColor: CustomColor.primaryColor,
                            icon: IconTheme(
                              data: IconThemeData(),
                              child: SvgPicture.asset(
                                "assets/icons/$name.svg",
                                height: 40.h,
                                width: 40.h,
                              ),
                            ),
                            iconColor: Colors.white,
                            contentTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15.h,
                                overflow: TextOverflow.fade),
                            titleTextStyle:
                                TextStyle(color: Colors.white, fontSize: 20.h),
                            title: const Text("Details"),
                            content: SizedBox(
                              height: 300.h,
                              width: 300.w,
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Divider(
                                      height: 1.h,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.monetization_on,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          const Text(
                                            "Amount",
                                          )
                                        ],
                                      ),
                                      Text("$amount",
                                          style: TextStyle(color: Colors.grey[350]))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: Divider(
                                      height: 1.h,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: Column(
                                          children: [
                                            const Text("Category"),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text("$category",
                                                style: TextStyle(
                                                    color: Colors.grey[350])),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time_filled,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                const Text("Date"),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                                "${date.day}/${date.month}/${date.year}",
                                                style: TextStyle(
                                                    color: Colors.grey[350])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: Divider(
                                      height: 1.h,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          const Text(
                                            "Related People",
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(relatedPeople,
                                                softWrap: false,
                                                style: TextStyle(
                                                    color: Colors.grey[350]),
                                                maxLines: 1))
                                      ]),
                                  SizedBox(
                                    height: 20,
                                    child: Divider(
                                      height: 1.h,
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Description"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  SizedBox(
                                    height: 80.h,
                                    child: Text(
                                      description,
                                      softWrap: true,
                                      style: TextStyle(color: Colors.grey[350]),
                                      maxLines: 6,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: Divider(
                                      height: 1.h,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      image != "" ? image != null ? const Text("Image") : const Text("") : const Text(""),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      height: 150.h,
                                      width: 150.w,
                                      child: image != "" ? image != null ? Image.network(image,fit: BoxFit.cover,) : null : null,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(children: [
                                                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/$name.svg",
                                    height: 16.h,
                                    width: 16.h,
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                  ),
                                  Text(category)
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "THB ${amount.toStringAsFixed(2)}",
                                    style: TextStyle(color: widget.color),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: widget.color,
                                  ),
                                ],
                              )
                            ],
                                                          ),
                                                        ]))));
              }
            );
          } else {
            return Container();
          }
        });
  }

  void updateData() async {
    Future<DocumentSnapshot<Map<String, dynamic>>?> document =
        recordService.getDataRecord(widget.docId!);
    DocumentSnapshot<Map<String, dynamic>>? doc = await document;
    Map<String, dynamic> data = doc!.data() as Map<String, dynamic>;

    setState(() {
      amount = data['Amount'];
      category = data['Category'];
      date = DateFormat("yyyy-MM-dd").parse(data['Date']);
      description = data['Description'];
      relatedPeople = data['Related People'];
    });
  }
}
