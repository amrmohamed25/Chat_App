import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;

  bool isLoading = false;

  void submitAuthForm(
      {required String email,
      required String password,
      required String username,
      required bool isLogin,
      required BuildContext ctx,
      required File? image}) async {
    UserCredential authResult;
    print("ya rb");
    print(isLogin);
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print("fo2 l 3zma");
      } else {
        print("here");
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image/${authResult.user!.uid}.jpg");
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        print(url);

        await FirebaseFirestore.instance
            .collection("chat_users")
            .doc(authResult.user!.uid)
            .set(
                {"password": password, "username": username, "image_url": url});
        print(authResult);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      String error = "Error occurred";
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
        print('The account already exists for that email.');
      } else if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
        print('Wrong password provided for that user.');
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink,
        body: AuthForm(submitAuthForm, isLoading));
  }
}
