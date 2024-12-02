import 'package:flutter_svg/svg.dart';

class AppIcon {
  String iconName;
  String iconPath;

  AppIcon(this.iconName, this.iconPath);
  void icon(String iconName) {
    SvgPicture.asset("assets/icons/${iconName}.svg");
  }
}

List iconNameList = [
  "Accessories",
  "Borrowed",
  "Clothes",
  "Collect",
  "Cure",
  "Donate",
  "Education",
  "Entertainment",
  "Food",
  "Groceries",
  "Hobby",
  "Insurance",
  "Mobile",
  "Other",
  "Pet",
  "Service",
  "Sport",
  "Tax",
  "Transport",
  "Vechicle"
];
