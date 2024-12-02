import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_mobile_app/services/category_service.dart';
import 'package:project_mobile_app/services/firestore_service.dart';
import 'package:project_mobile_app/services/home_service.dart';
import 'package:project_mobile_app/widgets/colors.dart';
import 'package:project_mobile_app/services/flutterfire.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final categoryNameController = TextEditingController();

  late List categoryList;
  late String userImgae;
  late final userdoc;

  XFile? _imageFile;
  late Widget imageContainer;
  late final Reference imageReference;
  late String imageUrl = "";

  final CategoryService categoryService = CategoryService();
  final UserService userService = UserService();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final HomeService homeService = HomeService();

  @override
  initState() {
    categoryService.setCategory();
    imageReference = firebaseStorage
        .ref()
        .child("$uid/${DateTime.now().millisecondsSinceEpoch}.png");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: homeService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String username = data["Username"];
            userImgae = data["Image"];
            return ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 125.w,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 90),
                        child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 3.h,
                                      spreadRadius: 0.5.h,
                                      offset: Offset(0, -5.h))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    username,
                                    style: TextStyle(
                                        color: CustomColor.primaryColor),
                                  ),
                                ),
                                settingButton(
                                    "Password", const Icon(Icons.chevron_right), () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return changePasswordDialog();
                                      });
                                }),
                                settingButton("Category", const Icon(Icons.chevron_right), () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return showCategoryDialog();
                                      });
                                }),
                                settingButton("App info", const Icon(Icons.chevron_right), () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return appInfoDialog();
                                      });
                                }),
                                SizedBox(
                                  height: 200.h,
                                ),
                                GestureDetector(
                                  child: logoutButton(
                                      "Logout", CustomColor.primaryColor),
                                  onTap: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushNamed(context, "login");
                                  },
                                ),
                                Container(
                                  height: 100,
                                  color: Colors.transparent,
                                )
                              ],
                            )),
                      ),
                      Transform.translate(
                        offset: Offset(0, 30.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profileImage(),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ]);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<void> onPressedGallery() async {
    await pickImage(ImageSource.gallery);
    if (_imageFile != null) {
      final file = File(_imageFile!.path);
      await imageReference.putFile(file);
      final url = await imageReference.getDownloadURL();
      imageUrl = url;
      await homeService.updateImage(imageUrl);
    }
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

  Widget textFieldSetting(String text, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColor.primaryColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColor.primaryColor)),
          hintText: text,
        ),
        obscureText: true,
      ),
    );
  }

  Future<String> getUsername() async {
    // Reference to the document you want to retrieve
    final docRef = FirebaseFirestore.instance.collection('Users').doc(uid);

// Get the document data
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();

// Check if the document exists
    if (documentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      // Access specific fields
      String name = data['Username'];
      return '$name\n';
      // Use the data for your UI or logic
    } else {
      // The document does not exist
      return 'Document does not exist';
    }
  }

  Future<String> getImage() async {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(uid);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    if (documentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      // Access specific fields
      String image = data["Image"];
      return image;
      // Use the data for your UI or logic
    } else {
      // The document does not exist
      return 'Document does not exist';
    }
  }

  Widget profileImage() {
    if (userImgae.toString() != "default") {
      return GestureDetector(
        onTap:(){
          onPressedGallery();
        },
        child: CircleAvatar(
          radius: 45,
          child: ClipOval(
            child: Image.network(
              userImgae,
              width: 120.w,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap:() {
          onPressedGallery();
        },
        child: CircleAvatar(
          radius: 45,
          child: ClipOval(
            child: Image.asset("assets/images/logo.png",
                width: 120.w, height: 120.h, fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

  Widget appInfoDialog() {
    return Theme(
        data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: CustomColor.primaryColor))),
        child: const AboutDialog(
            applicationName: "Project Mobile App",
            applicationVersion: "version: 0.0.1",
            children: [
              Column(
                children: [
                  Text("Developed By"),
                  Text("Thanawat Potidet "),
                  Text("Chutipong Triyasith")
                ],
              )
            ]));
  }

  Widget showCategoryDialog() {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Category", style: Theme.of(context).textTheme.headlineMedium,),
                  smallButton(
                      () => Navigator.pop(context),
                      Colors.red,
                      Colors.white,
                      Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            StreamBuilder(
              stream: categoryService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  categoryList = snapshot.data!.docs ?? [];
                  return Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                categoryList[index];
                            Map<String, dynamic> data =
                                documentSnapshot.data() as Map<String, dynamic>;
                            String categoryName = data["CategoryName"];
                            String categoryIcon = data["IconName"];
                            return GestureDetector(
                              child: categoryCard(categoryName, categoryIcon),
                              onTap: () {},
                            );
                          }));
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: smallButton(() {
                    Navigator.pushNamed(context, "create_category");
                  },
                      CustomColor.primaryColor,
                      Colors.white,
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget changePasswordDialog() {
    return Dialog(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Change Password"),
            textFieldSetting("Old Password", oldPasswordController),
            textFieldSetting("New Password", newPasswordController),
            textFieldSetting("Confirm Password", confirmPasswordController),
            ElevatedButton(
                onPressed: () async {
                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                    Future<bool> changePasswordPass = changePassword(
                        oldPasswordController.text, newPasswordController.text);
                    bool passwordChangeSuccess =
                        await changePasswordPass; // Wait for result
                    if (passwordChangeSuccess) {
                      Navigator.pop(context); // Close dialog

                      // Show successful password change dialog
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                "Change Password Successful",
                              ),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CustomColor.primaryColor,
                                        foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close AlertDialog
                                    },
                                    child: const Text("OK"),
                                  ),
                                )
                              ],
                            );
                          });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Confirm Password")),
          ],
        ),
      ),
    );
  }
}

Widget settingButton(String text, Icon icon, Function() function) {
  return GestureDetector(
    onTap: function,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(children: [
        SizedBox(
          width: 325.w,
          height: 50.h,
          // color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(text),
              ),
              icon
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            height: 1,
          ),
        )
      ]),
    ),
  );
}

Widget logoutButton(String text, Color color) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    width: 275.w,
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
  );
}

Widget smallButton(
    Function() function, Color containerColor, Color iconColor, Icon icon) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: containerColor),
    child: IconButton(
      icon: icon,
      onPressed: function,
    ),
  );
}

Widget categoryCard(String categoryName, String categoryIcon) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      decoration: BoxDecoration(
          // border: Border.all(width: 1, color: Colors.green),
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/$categoryIcon.svg",
              width: 30.w,
              height: 28.h,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                categoryName,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        )),
      ),
    ),
  );
}
