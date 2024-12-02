import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RecordService {
  late String userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference record;

  void setRecord() {
    record = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Record');
  }

  Stream<QuerySnapshot> getRecordStream() {
    final recordStream = record.snapshots();

    return recordStream;
  }

  List checkTime(List recordList, String type) {
    List newRecordList = [];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;

      DateTime recordTime = dateFormat.parse(data['Date']);

      if (recordTime.day == DateTime.now().day &&
          recordTime.month == DateTime.now().month &&
          recordTime.year == DateTime.now().year &&
          type == "today") {
        newRecordList.add(record);
      }
      if (recordTime.month == DateTime.now().month &&
          recordTime.year == DateTime.now().year &&
          type == "this_month") {
        newRecordList.add(record);
      }
      if (recordTime.year == DateTime.now().year && type == "this_year") {
        newRecordList.add(record);
      }
    }
    return newRecordList;
  }

  List checkMonth(List recordList,int month) {
    List newRecordList = [];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;

      DateTime recordTime = dateFormat.parse(data['Date']);

      if(recordTime.month == month && DateTime.now().year == recordTime.year){
        newRecordList.add(record);
      }
      }
    return newRecordList;
  }

List checkYear(List recordList,int year) {
    List newRecordList = [];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;

      DateTime recordTime = dateFormat.parse(data['Date']);

      if(recordTime.year == year){
        newRecordList.add(record);
      }
      }
    return newRecordList;
  }

  num sumTypeAmount(List recordList, String type) {
    num total = 0.00;
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
      num amount = data['Amount'];
      String recordType = data["Type"];
      if (recordType == type || type == "Total") {
        total += amount;
      }
    }
    return total;
  }

  num sumCategoryAmount(List recordList, String category) {
    num total = 0.00;
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
      num amount = data['Amount'];
      String recordCategory = data["Category"];
      if (recordCategory == category) {
        total += amount;
      }
    }
    return total;
  }

  List filttertype(List recordList, String field, String type) {
    List newRecordList = [];
    bool check = true;
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
      String recordField = data[field];
      String recordType = data['Type'];
      check = true;
      if (recordType == type || type == "Total") {
        for (var types in newRecordList) {
          if (types == recordField) {
            check = false;
          }
        }
        if (check) {
          newRecordList.add(recordField);
        }
      }
    }

    return newRecordList;
  }

  List filtterRecordType(List recordList, String type) {
    List newRecordList = [];
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
      String recordType = data["Type"];
      if (recordType == type || type == "Total") {
        newRecordList.add(record);
      }
    }

    return newRecordList;
  }

  List filtterRecordCategory(List recordList, String category) {
    List newRecordList = [];
    for (var record in recordList) {
      DocumentSnapshot doucument = record;
      Map<String, dynamic> data = doucument.data() as Map<String, dynamic>;
      String recordCategory = data["Category"];
      if (recordCategory == category) {
        newRecordList.add(record);
      }
    }

    return newRecordList;
  }

  double percentType(List recordList, String field, String type, String kind) {
    List filtterRecordList = field == "Category"
        ? filtterRecordCategory(recordList, type)
        : filtterRecordType(recordList, type);
    num totalTypeAmount = sumTypeAmount(filtterRecordList, kind);
    num totalAmount = sumTypeAmount(recordList, kind);
    double percent = totalTypeAmount / totalAmount;

    return percent * 100;
  }


  num calculatorAmountUser(List recordList) {
    List incomeList = filtterRecordType(recordList, "Income");
    List expenseList = filtterRecordType(recordList, "Expense");
    num totalIncome = sumTypeAmount(incomeList, "Income");
    num totalExpense = sumTypeAmount(expenseList, "Expense");
    return totalIncome - totalExpense;
  }

  Future<List?> getRecord(String docId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Record')
        .doc(docId);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    // Get the document data
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    if (documentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // Access specific fields
      num amount = data['Amount'];
      String category = data['Category'];
      DateTime date = dateFormat.parse(data['Date']);
      String description = data['Description'];
      String relatedPeople = data['Related People'];
      String type = data['Type'];
      String imageUrl = data['Image'];

      List newRecordList = [];
      newRecordList
          .addAll([amount, category, date, description, relatedPeople, type,imageUrl]);
      return newRecordList;
      // Use the data for your UI or logic
    }
    return null;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getDataRecord(
      String docId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Record')
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

  Future<void> addRecord(String category, String datetime,
      String type,
      {num? amount, String? description,String? related, dynamic imageUrl}) {
    return record.add({
      'Category': category,
      'Amount': amount ?? 0,
      'Date': datetime,
      'Description': description ?? "",
      'Related People': related ?? "",
      'Type': type,
      'Image': imageUrl ?? "",
    });
  }

  Future<void> updateRecord(String docId, String category, String datetime,
      String description, String type, String related,
      {num? amount,String? imageUrl}) {
    return record.doc(docId).update({
      'Category': category,
      'Amount': amount ?? 0,
      'Date': datetime,
      'Description': description,
      'Related People': related,
      'Type': type,
      'Image': imageUrl ?? ""
    });
  }
  Future<void> deleteRecord(String docId) {
    return record.doc(docId).delete();
  }

}
