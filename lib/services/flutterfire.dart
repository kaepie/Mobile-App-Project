import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile_app/models/appicon.dart';
import 'package:project_mobile_app/services/category_service.dart';
import 'package:project_mobile_app/widgets/colors.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> register(String username, String email, String password,
    BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("Users").doc(userId).set({
      "Email": email,
      "Username": username,
      "Amount": 0,
      "Image": "default"
    });
    CategoryService categoryService = CategoryService();
    categoryService.setCategory();
    for (int i = 0; i < 20; i++) {
      categoryService.addCategory(iconNameList[i], iconNameList[i]);
    }
    FirebaseAuth.instance.signOut();
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      _showErrorDialog(context, e.code);
    } else if (e.code == 'email-already-in-use') {
      _showErrorDialog(context, e.code);
    }
    return false;
  } catch (e) {
    return false;
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Sign In Error', style: Theme.of(context).textTheme.headlineMedium,),
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
              foregroundColor:
                  MaterialStatePropertyAll(CustomColor.primaryColor)),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<bool> changePassword(String currentPassword, String newPassword) async {
  bool success = false;

  var user = FirebaseAuth.instance.currentUser!;

  final cred = EmailAuthProvider.credential(
      email: user.email!, password: currentPassword);
  await user.reauthenticateWithCredential(cred).then((value) async {
    await user.updatePassword(newPassword).then((_) {
      success = true;
    }).catchError((error) {});
  }).catchError((err) {});

  return success;
}
