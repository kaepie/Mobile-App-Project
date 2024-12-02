import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_mobile_app/services/category_service.dart';
import 'package:project_mobile_app/services/home_service.dart';
import 'package:project_mobile_app/services/record_services.dart';
import 'package:project_mobile_app/widgets/appbar.dart';
import 'package:project_mobile_app/widgets/colors.dart';
import 'package:project_mobile_app/widgets/home_widgets.dart';

class CreateRecord extends StatefulWidget {
  CreateRecord({super.key, this.docId});
  String? docId;
  @override
  State<CreateRecord> createState() => _CreateRecordState();
}

class _CreateRecordState extends State<CreateRecord> {
  TextEditingController moneyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController relatedController = TextEditingController();
  String? docId;
  String? timeText;
  DateTime? date;

  var format = DateFormat("yyyy-MM-dd");
  String dropDownValue = "Income";
  String dropDownCategory = "Food";

  XFile? _imageFile;
  late Widget imageContainer;
  late final Reference imageReference;
  late String imageUrl = "";

  RecordService recordService = RecordService();
  CategoryService categoryService = CategoryService();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  HomeService homeService = HomeService();

  @override
  initState() {
    timeText = format.format(DateTime.now());
    recordService.setRecord();
    categoryService.setCategory();
    imageContainer = imageContainerFuction();
    imageReference = firebaseStorage
        .ref()
        .child("$uid/${DateTime.now().millisecondsSinceEpoch}.png");
    super.initState();
    docId = widget.docId;
    fetchData();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: docId != null ? "Edit Record" : "Create Record",
          checkPop: true,
        ),
        backgroundColor: CustomColor.backgroundColor,
        body: Center(
            child: ListView(
          children: [
            Padding(
              // categoryDropdown
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
                        "Category",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
                      child: StreamBuilder(
                        stream: categoryService.getCategories(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            var categoryList = snapshot.data?.docs ?? [];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DropdownButton<String>(
                                  //category button
                                  menuMaxHeight: 100,
                                  // dropdown category
                                  underline: Container(
                                    height: 0,
                                  ),
                                  value: dropDownCategory,
                                  items: categoryList.map((index) {
                                    return DropdownMenuItem<String>(
                                        value: index["CategoryName"],
                                        child: Text(index["CategoryName"]));
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropDownCategory = value!;
                                    });
                                  },
                                ),
                                DropdownButton<String>(
                                  // dropdown income expense
                                  underline: Container(
                                    height: 0,
                                  ),
                                  value: dropDownValue,
                                  items: const [
                                    DropdownMenuItem(
                                        value: "Income", child: Text("Income")),
                                    DropdownMenuItem(
                                        value: "Expense",
                                        child: Text("Expense"))
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropDownValue = value!;
                                    });
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              // money textField
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
                        "Amount",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
                      child: customTextField(
                          moneyController, "Amount", TextInputType.number, 50),
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
                        "Date",
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
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now());
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomContainer(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "Photo",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0), child: imageContainer)
                ],
              )),
            ),
            Padding(
              // Related TextField
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Related People",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: customTextField(
                          relatedController, "", TextInputType.multiline, 70),
                    ),
                  ],
                ),
              )),
            ),
            GestureDetector(
                onTap: () async {
                  if (_imageFile != null) {
                    final file = File(_imageFile!.path);
                    await imageReference.putFile(file);
                    final url = await imageReference.getDownloadURL();
                    imageUrl = url;
                  }
                  if (docId == null) {
                    try {
                      await recordService.addRecord(
                          dropDownCategory, timeText!, dropDownValue,
                          related: relatedController.text,
                          description: descriptionController.text,
                          amount: double.parse(moneyController.text),
                          imageUrl: imageUrl);
                      moneyController.clear();
                      descriptionController.clear();

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
                            title: Text("Error"),
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
                      if (_imageFile != null) {
                    final file = File(_imageFile!.path);
                    await imageReference.putFile(file);
                    final url = await imageReference.getDownloadURL();
                    imageUrl = url;
                  }
                      await recordService.updateRecord(
                          docId!,
                          dropDownCategory,
                          timeText!,
                          descriptionController.text,
                          dropDownValue,
                          relatedController.text,
                          amount: double.parse(moneyController.text),
                          imageUrl: imageUrl);

                      moneyController.clear();
                      descriptionController.clear();
                      relatedController.clear();

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
                            icon: Icon(Icons.error),
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
                child: createRecordButton(docId == null ? "Create" : "Edit",
                    CustomColor.primaryColor)),
          ],
        )));
  }

  Widget createRecordButton(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
      child: Container(
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
      ),
    );
  }

  Future<void> fetchData() async {
    // Make the function async
    Future<List?> docRecord = recordService.getRecord(docId!);

    List? list = await docRecord; // Wait for the future to complete

    if (list != null) {
      // Check if data exists
      moneyController.text = list[0].toString();
      dropDownCategory = list[1].toString();
      timeText =
          format.format(list[2]); // Assuming format is a DateFormat instance
      descriptionController.text = list[3].toString();
      relatedController.text = list[4].toString();
      dropDownValue = list[5].toString();
      imageUrl = list[6].toString();

      setState(() {
        if (imageUrl != "") {
          imageContainer = setImage();
        }
      });
    } else {
      // Handle no data case (e.g., show error message)
    }
  }

  Widget setImage() {
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(imageUrl,
              width: double.maxFinite.w, height: 200.h, fit: BoxFit.cover)),
      Padding(
        padding: const EdgeInsets.only(left: 330, top: 210),
        child: unselectImage(),
      ),
    ]);
  }

  Widget onPressedCamera() {
    pickImage(ImageSource.camera);
    if (_imageFile != null) {
      final file = File(_imageFile!.path);
      return Image.file(
        file,
        width: double.maxFinite.w,
        height: 200.h,
      );
    }
    return Container();
  }

  Future<Widget> onPressedGallery() async {
    await pickImage(ImageSource.gallery);
    if (_imageFile != null) {
      final file = File(_imageFile!.path);
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(file,
                width: double.maxFinite.w, height: 200.h, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 330, top: 210),
            child: unselectImage(),
          ),
        ],
      );
    }
    return Container();
  }

  Future<void> pickImage(ImageSource source) async {
    if (await Permission.camera.request().isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Widget imageContainerFuction() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
      width: double.maxFinite.w,
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageButton(() async {
            Widget widget = await onPressedCamera();
            if (widget.toString() != Container().toString()) {
              imageContainer = widget;
            }
          }, const Icon(Icons.camera_alt), "Camera", Colors.green[200]!),
          imageButton(() async {
            Widget widget = await onPressedGallery();
            if (widget.toString() != Container().toString()) {
              imageContainer = widget;
            }
          }, const Icon(Icons.photo), "Gallery", Colors.green[300]!)
        ],
      ),
    );
  }

  Widget unselectImage() {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
          color: Colors.red[400], borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
        onTap: () {
          setState(() {
            imageContainer = imageContainerFuction();
            _imageFile = null;
          });
        },
      ),
    );
  }
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

Widget imageButton(
    Function() function, Icon icon, String buttonName, Color color) {
  return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 100.w,
          height: 35.h,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [icon, Text(buttonName)],
          ),
        ),
      ));
}
