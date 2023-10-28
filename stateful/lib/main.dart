import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Scaffold(body: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: GestureDetector(
      child: Text('count=${_index.toString()}'),
      onTap: () {
        setState(() {
          _index++;
        });
      },
    ));
  }
}
