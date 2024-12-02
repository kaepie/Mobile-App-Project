import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final uid = FirebaseAuth.instance.currentUser!.uid;
  static final DocumentReference documentReference = _firestore.collection('Users').doc(uid);


  Future<DocumentSnapshot> getUserData() async {
    final docSnapshot = await documentReference.get();
    return  docSnapshot;
  }
}