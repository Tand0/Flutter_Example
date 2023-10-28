import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RootData.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    return MaterialApp(
        home: GestureDetector(
      child: Text('count=${rootData.index}'),
      onTap: () {
        rootData.updateIndex();
      },
    ));
  }
}
