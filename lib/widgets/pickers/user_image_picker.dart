import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) ImagePickFn;

  const UserImagePicker(this.ImagePickFn);
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;
  final ImagePicker picker=ImagePicker();
  void pickImage(ImageSource src) async{
    final pickedImageFile= await picker.pickImage(source: src,imageQuality: 50,maxWidth: 150);

    if(pickedImageFile!=null){
      print("ya rb");
      setState(() {
        pickedImage=File(pickedImageFile.path);
        widget.ImagePickFn(pickedImage!);
      });

    }else{
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: pickedImage!=null?FileImage(pickedImage!):null,
        ),
        SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            
            child: ElevatedButton.icon(style: ElevatedButton.styleFrom(
              primary: Colors.white
            ),onPressed: (){
              pickImage(ImageSource.gallery);
            },icon:Icon(Icons.photo_camera_outlined,color: Colors.pink,) , label: Text("Add image from gallery",style: TextStyle(color: Theme.of(context).primaryColor),),),
          ),
          SizedBox( width: 5,),
          Expanded(
            child: ElevatedButton.icon(style: ElevatedButton.styleFrom(
                primary: Colors.white
            ),onPressed: (){
              pickImage(ImageSource.camera);
            },icon:Icon(Icons.photo_camera_outlined,color: Colors.pink,) , label: Text("Add image from camera",style: TextStyle(color: Theme.of(context).primaryColor),),),
          ),

        ],
        )
      ],
    );
  }
}
