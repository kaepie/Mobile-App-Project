import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PlanService {
  late String userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference plan;
  var format = DateFormat("yyyy-MM-dd");
  void setPlan() {
    plan = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Plans");
  }

  Stream<QuerySnapshot> getPlans() {
    return plan.snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getDataPlan(
      String docId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Plans')
        .doc(docId);
    // Get the document data
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    if (documentSnapshot.exists) {
      // Get the data as a Map

      return documentSnapshot;
      // Use the data for your UI or logic
    }
    return null;
  }

  Future<void> addPlan(
      String name, num target, String description, String date) {
    return plan.add({
      "Name": name,
      "Target": target,
      "Description": description ,
      "EndDate": date,
      "StartDate": format.format(DateTime.now())
    });
  }

  Future<void> updatePlan(
      String docId, String name, num target, String description, String date) {
    return plan.doc(docId).update({
      "Name": name,
      "Target": target,
      "Description": description,
      "EndDate": date
    });
  }

  Future<void> deletePlan(String docId){
    return plan.doc(docId).delete();
  }

  List checkPlanTime(List recordList, DateTime startDate, DateTime endDate) {
    List newRecordList = [];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;

      DateTime date = dateFormat.parse(data['Date']);
      if (date.isAtSameMomentAs(startDate) ||(date.isAfter(startDate) && date.isBefore(endDate.add(const Duration(days: 1))))) {
        newRecordList.add(record);
      }
    }
    return newRecordList;
  }

  double percentPlan(
    List recordList, DateTime startDate, DateTime endDate, num target) {
    List newRecordList = checkPlanTime(recordList, startDate, endDate);
    num sumAmountRecord = sumTypeAmount(newRecordList, "Income");
    if (sumAmountRecord > target) {
      sumAmountRecord = target;
    }
    return sumAmountRecord / target;
  }

  num sumTypeAmount(List recordList, String type) {
    num total = 0.00;
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
      num amount = data['Amount'];
      String recordType = data["Type"];
      if (recordType == type) {
        total += amount;
      }
    }
    return total;
  }
}
