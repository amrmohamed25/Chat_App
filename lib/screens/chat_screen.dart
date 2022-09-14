import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chat"),
        actions: [
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: "logout",
                  child: Row(
                children: const [
                  Icon(Icons.exit_to_app,color: Colors.white,),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Logout",style: TextStyle(color: Colors.white),),
                ],
              )),
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier=="logout"){
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
