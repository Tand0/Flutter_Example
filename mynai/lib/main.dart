import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/my_login.dart';
import 'src/root_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  RootData data = RootData();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<RootData>(
          create: (context) => data,
        ),
      ],
      child: MaterialApp(localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ], supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ], initialRoute: MyLogin.callName, routes: data.route)));
}
