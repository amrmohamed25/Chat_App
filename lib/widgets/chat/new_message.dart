import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final controller = TextEditingController();
  String enteredMessage = "";

  sendMessage() async{
    FocusScope.of(context).unfocus();
    final user= FirebaseAuth.instance.currentUser;
    final userData=await FirebaseFirestore.instance.collection("chat_users").doc(user!.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      "text":enteredMessage,
      "createdAt":Timestamp.now(),
      "username":userData["username"],
      "userId":user.uid,
      "userImage":userData["image_url"],
    });
    controller.clear();
    setState((){enteredMessage="";});

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Send a message ....",

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                hintStyle: TextStyle(color: Theme.of(context).primaryColor)
              ),
              onChanged: (val) {
                setState(() {
                  enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(disabledColor: Colors.white,color: Theme.of(context).primaryColor,onPressed:enteredMessage.trim().isEmpty?null:sendMessage, icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
