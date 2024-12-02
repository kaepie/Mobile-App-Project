import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_mobile_app/services/plan_service.dart';
import 'package:project_mobile_app/widgets/appbar.dart';
import 'package:project_mobile_app/widgets/colors.dart';
import 'package:project_mobile_app/widgets/home_widgets.dart';

class CreatePlan extends StatefulWidget {
  CreatePlan({super.key, this.docId});
  String? docId ;

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  TextEditingController nameController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? docId;
  String? timeText;
  DateTime? date;
  var format = DateFormat("yyyy-MM-dd");

  PlanService planService = PlanService();

  @override
  void initState() {
    super.initState();
    planService.setPlan();
    timeText = format.format(DateTime.now());
    docId = widget.docId;
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: docId != null ? "Edit Plan" : "Create Plan",
          checkPop: true,
        ),
        backgroundColor: CustomColor.backgroundColor,
        body: Center(
            child: ListView(
          children: [
            Padding(
              // target textField
              padding: const EdgeInsets.all(8.0),
              child: CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Name",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
                      child: customTextField(
                          nameController, "Name", TextInputType.name, 55),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              // target textField
              padding: const EdgeInsets.all(8.0),
              child: CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Target",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
                      child: customTextField(
                          targetController, "Amount", TextInputType.number, 50),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              //date picker
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "End Date",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                CustomColor.primaryColor),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          date = await showDatePicker(
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color.fromARGB(255, 77, 145,
                                          90), // header background color
                                      onPrimary:
                                          Colors.white, // header text color
                                      onSurface: Colors.black,
                                      // body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.black, // button text color
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2028));
                          setState(() {
                            timeText = format.format(date!);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeText!),
                            const Icon(Icons.calendar_view_month_outlined)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              //description
              padding: const EdgeInsets.all(8.0),
              child: CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Description",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
                      child: customTextField(descriptionController, "",
                          TextInputType.multiline, 70),
                    ),
                  ],
                ),
              )),
            ),
            GestureDetector(
                onTap: () async {
                  if (docId == null) {
                    try {
                      await planService.addPlan(
                      nameController.text,double.parse(targetController.text),descriptionController.text,timeText!);
                      targetController.clear();
                      descriptionController.clear();
                      nameController.clear();
                      
                      Navigator.pop(context);
                    } on FormatException catch (e) {
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.6),
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            icon: const Icon(Icons.error),
                            iconColor: Colors.white,
                            contentTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            titleTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            title: const Text("Invalid Money Format"),
                            content: const Text(
                                "Please enter a valid amount in the format: X.XX (e.g., 123.45)"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.6),
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            icon: const Icon(Icons.error),
                            iconColor: Colors.white,
                            contentTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            titleTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            title: const Text("Error"),
                            content: Text("An unexpected error occurred: $e"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    try {
                      await planService.updatePlan(docId!,
                      nameController.text,double.parse(targetController.text),descriptionController.text,timeText!);
                      targetController.clear();
                      descriptionController.clear();
                      nameController.clear();

                      Navigator.pop(context);
                    } on FormatException catch (e) {
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.6),
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            icon: const Icon(Icons.error),
                            iconColor: Colors.white,
                            contentTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            titleTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            title: const Text("Invalid Money Format"),
                            content: const Text(
                                "Please enter a valid amount in the format: X.XX (e.g., 123.45)"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.6),
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            icon: const Icon(Icons.error),
                            iconColor: Colors.white,
                            contentTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            titleTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            title: const Text("Error"),
                            content: Text("An unexpected error occurred: $e"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          );
                        },
                      );
                    }
                  }

                  void fetchData() {}
                },
                child: createPlanButton(docId == null ? "Create" : "Edit", CustomColor.primaryColor),
            )],
        )));
  }

  Future<void> fetchData() async {
    // Make the function async
    final document = planService.getDataPlan(docId!);
    final doc = await document;
    Map<String, dynamic> data = doc!.data() as Map<String, dynamic>;

    setState(() {
      targetController.text = data['Target'].toString();
      descriptionController.text = data['Description'].toString();
      nameController.text = data['Name'].toString();
      timeText =
          format.format(data['EndDate']);
    });
  }

  Widget createPlanButton(String text, Color color) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        width: 325.w,
        height: 40.h,
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
      ),
    );
  }



  Widget customTextField(TextEditingController controller, String text,
    TextInputType inputType, int height) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: Colors.grey)),
    width: 325.w,
    height: height.h,
    child: TextField(
      controller: controller,
      maxLines: 2,
      keyboardType: inputType,
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
  );
}  
}