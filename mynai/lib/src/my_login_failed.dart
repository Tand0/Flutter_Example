import 'package:flutter/material.dart';

class MyLoginFailed extends StatelessWidget {
  const MyLoginFailed({Key? key}) : super(key: key);

  static const callName = "/login_failed";
  static const title = "Login failed";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: const Text("Login Failed"));
  }
}
