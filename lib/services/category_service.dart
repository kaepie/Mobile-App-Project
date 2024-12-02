import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService{
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference categories;

  void setCategory(){
      categories = FirebaseFirestore.instance.collection("Users").doc(uid).collection("Categories");
    }

  Stream<QuerySnapshot> getCategories(){
    return categories.snapshots();
  }

  void addCategory(String categoryName, String iconName){
    categories.add({
      "CategoryName": categoryName,
      "IconName": iconName
    });
  }

  String getIconNameWithCategoryName(List catagoryList,String categoryRecord){
    String sendIconName = "";
    for (var doc in catagoryList){
      DocumentSnapshot doucument = doc;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;

      String category = data['CategoryName'];
      String iconName = data['IconName'];
      if(category == categoryRecord){
        sendIconName = iconName;
      }
    }
    return sendIconName;
  }
}