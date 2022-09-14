import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  void Function(
      {required String email,
      required String password,
      required String username,
      required bool isLogin,
      required File? image,
      required BuildContext ctx}) submitForm;
  bool isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = "";
  String password = "";
  String username = "";
  File? userImageFile;

  void submit() {
    final isValid = formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    // print(userImageFile!.path);
    if (userImageFile == null && isLogin == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please Pick An Image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid!) {
      formKey.currentState?.save();
      widget.submitForm(
          email: email.trim(),
          password: password.trim(),
          username: username.trim(),
          ctx: context,
          isLogin: isLogin,
          image: userImageFile);
    }
  }

  void pickImage(File pickedImage) {
    print("ya yay");
    userImageFile = pickedImage;
    if (userImageFile == null) {
      print("sad");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLogin) UserImagePicker(pickImage),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey("email"),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains("@")) {
                      return "Please Enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (val) => email = val!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                if (!isLogin)
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
                    key: const ValueKey("username"),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return "Please Enter at least 4 characters";
                      }
                      return null;
                    },
                    onSaved: (val) => username = val!,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: const ValueKey("password"),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 7) {
                      return "Password must be at least 7 characters";
                    }
                    return null;
                  },
                  onSaved: (val) => password = val!,
                  // keyboardType: TextInputType.pas,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading == true) const CircularProgressIndicator(),
                if (widget.isLoading == false)
                  ElevatedButton(
                    onPressed: submit,
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ))),
                    child: Text(isLogin ? "Login" : "Sign Up"),
                  ),
                if (widget.isLoading == false)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? "Create new account"
                          : "I already have an account")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
