import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(initialRoute: "/", routes: {
    "/": (BuildContext context) => const MyApp(),
    "/next": (BuildContext context) => const MyAppNext(),
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Text('next'),
      onTap: () {
        Navigator.of(context).pushNamed("/next");
      },
    );
  }
}

class MyAppNext extends StatelessWidget {
  const MyAppNext({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Text('back'),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
