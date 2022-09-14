import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat").orderBy("createdAt",descending: true)
            .snapshots(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final user=FirebaseAuth.instance.currentUser;
          final docs = snapShot.data?.docs;
          return ListView.builder(
            reverse: true,
            itemCount: docs?.length,
            itemBuilder: (ctx, index) {
              // FirebaseAuth.instance.currentUser.uid;
              return MessageBubble(docs![index]["text"],docs[index]["username"],docs[index]["userImage"],docs[index]["userId"]==user!.uid,key:ValueKey(docs[index].id));
            },
          );
        });
  }
}
