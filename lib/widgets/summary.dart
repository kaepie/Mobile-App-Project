import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_mobile_app/services/category_service.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/widgets/colors.dart';

class GraphSummary extends StatelessWidget {
  GraphSummary(
      {super.key,
      required this.recordTypeList,
      required this.recordList,
      required this.field,
      required this.kind});

  RecordService recordService = RecordService();
  List recordTypeList;
  List recordList;
  String kind;
  String field;
  @override
  Widget build(BuildContext context) {
    List colorList = [
        const Color.fromARGB(255, 255, 25, 25),
          CustomColor.primaryColor,
          const Color.fromARGB(255, 156, 156, 156),
          const Color.fromARGB(255, 158, 151, 100),
          const Color.fromARGB(255, 34, 113, 179),
          const Color.fromARGB(255, 001, 93, 82),
          const Color.fromARGB(255, 220, 156, 0),
          const Color.fromARGB(255, 121, 85, 61),
          const Color.fromARGB(255, 165, 32, 25),
          const Color.fromARGB(255, 88, 114, 70),
          const Color.fromARGB(255, 143, 139, 102),
          const Color.fromARGB(255, 112, 083, 053),
          const Color.fromARGB(255, 049, 127, 67),
          const Color.fromARGB(255, 222, 76, 138),
          const Color.fromARGB(255, 109, 63, 91),
          const Color.fromARGB(255, 217, 80, 48),
          const Color.fromARGB(255, 93, 155, 155),
          const Color.fromARGB(255, 59, 60, 54),
          const Color.fromARGB(255, 236, 124, 38),
          const Color.fromARGB(255, 248, 243, 53),
          const Color.fromARGB(255, 69, 50, 46),
          const Color.fromARGB(255, 199, 180, 70),
          const Color.fromARGB(255, 24, 23, 28),
          const Color.fromARGB(255, 32, 33, 79),
          const Color.fromARGB(255, 108, 112, 89),
          const Color.fromARGB(255, 165, 165, 165),
          const Color.fromARGB(255, 89, 35, 33),
          const Color.fromARGB(255, 27, 85, 131),
          const Color.fromARGB(255, 89, 53, 31),
          const Color.fromARGB(255, 193, 135, 107),
          const Color.fromARGB(255, 94, 33, 41),
          const Color.fromARGB(255, 169, 131, 7),
          const Color.fromARGB(255, 32, 33, 79),
          const Color.fromARGB(255, 214, 174, 001),
          const Color.fromARGB(255, 225, 204, 079),
        ];
    recordService.setRecord;
    return Container(
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.only(top: 20.h ,left: 20.h, right: 20.h),
      child: Column(
        children: [
          SizedBox(
            height: 200.h,
            child: AspectRatio(aspectRatio: 1.2,child: PieChart(
              swapAnimationDuration: const Duration(milliseconds: 750),
              swapAnimationCurve: Curves.easeInOutQuint,
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 2.h,
                sections: getSections(recordTypeList, recordList, kind, colorList),
                centerSpaceRadius: 60.h
                )),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.h,bottom: 15.h),
            child: 
            SizedBox(
              height: 75.h,
              child: 
            ListView.builder(
              shrinkWrap: true,
              itemCount: recordTypeList.length,  
              itemBuilder: (context, index) {
                return 
                  SizedBox(
                    height: 25.h,
                    child: 
                    Row(children: [
                      Container(width: 14.w,height: 14.h,decoration: BoxDecoration(shape: BoxShape.circle,color: colorList[index])),
                      SizedBox(width: 8.w,),
                      Text(recordTypeList[index], style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),),
                    ],),
                  );
              },)
              ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections(List record, List recordList, String kind, List colorList) => record
      .asMap()
      .map<int, PieChartSectionData>((key, value) {
        double percent =
            recordService.percentType(recordList, field, record[key],kind);
        final value = PieChartSectionData(
          color: colorList[key],
          value: percent,
          title: '${percent.toStringAsFixed(2)}%',
          titleStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white,overflow: TextOverflow.ellipsis),
        );
        return MapEntry(key, value);
      })
      .values
      .toList();
}

class RecordSummaryCard extends StatelessWidget {
  RecordSummaryCard(
      {super.key,
      required this.name,
      required this.amount,
      required this.color,this.check});
  String name;
  Color color;
  num amount;
  bool? check;
  @override
  Widget build(BuildContext context) {
    CategoryService categoryService = CategoryService();
    categoryService.setCategory();
    return StreamBuilder<QuerySnapshot>(
      stream: categoryService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        var categoryList = snapshot.data?.docs ?? [];

        String image = categoryService.getIconNameWithCategoryName(categoryList, name);
        return Container(
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
                        check == null ?SvgPicture.asset(
                            "assets/icons/$image.svg",
                            height: 16.h,
                            width: 16.h,
                          ): Icon(Icons.monetization_on, color: color,),
                        SizedBox(
                          width: 50.w,
                        ),
                        Text(name)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "THB ${amount.toStringAsFixed(2)}",
                          style: TextStyle(color: color),
                        ),
                      ],
                    )
                  ],
                                      ),
                                    ])),
        );
        }
        else {
          return Container();
        }
      }
    );
  }
}
