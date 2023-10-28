import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Center(
          child: ElevatedButton(
            child: const Text("push me and get greeting"),
            onPressed: () async {
              try {
                Uri url = Uri.parse("http://192.168.1.1:3002");
                var response = await http.get(url, headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'text/plain',
                });
                print(response.body);
                //
                url = Uri.parse("http://192.168.1.1:3002/token");
                response = await http.post(url,
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded',
                      'Accept': 'text/plain',
                      // 'Authorization': 'Bearer $token',
                    },
                    body:
                        "grant_type=&username=root&password=root&scope=&client_id=&client_secret=");
                Map<String, dynamic> responceBody = json.decode(response.body);
                String accessToken = responceBody["access_token"];
                //
                print(accessToken);
              } catch (e) {
                debugPrint("error");
                print(e);
              }
            },
          ),
        ));
  }
}
