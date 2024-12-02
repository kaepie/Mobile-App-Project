import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeService{
    late String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async{
    final docRef = FirebaseFirestore.instance.collection("Users").doc(userId);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();
    return documentSnapshot;
  }

  Future<num> getUserAmount() async {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    // Get the document data
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    if (documentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // Access specific fields
      num amount = data['Amount'];
      return amount;
      // Use the data for your UI or logic
    } else {
      // The document does not exist
      return 0;
    }
  }

  Future<void> updateAmount(num amount) async{
    final docRef = FirebaseFirestore.instance.collection("Users").doc(userId);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    if (documentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // Access specific fields
      String email = data['Email'];
      String username = data['Username'];
      String imageUrl = data['Image'];
    return await docRef.update({'Amount': amount, 'Email': email, 'Username': username, 'Image': imageUrl});
    }
    return;
  }

  Future<void> updateImage(String imageUrl) async{
    final docRef = FirebaseFirestore.instance.collection("Users").doc(userId);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await docRef.get();
    if (documentSnapshot.exists) {
      // Get the data as a Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // Access specific fields
      String email = data['Email'];
      String username = data['Username'];
      num amount = data['Amount'];
    return await docRef.update({'Amount': amount, 'Email': email, 'Username': username, 'Image': imageUrl});
    }
    return;
  }
  
}