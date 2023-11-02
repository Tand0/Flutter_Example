import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'RootData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManagementService {
  static const String localStorageKey = "graphic_client_url_data";
  static const String localStorageKeyUrl = "graphic_client_url";

  static Future<Object?> getLocalStrageJson() async {
    String? jsonText = await getLocalStorage();
    return json.decode(jsonText!);
  }

  static Future<void> setLocalStrageJson(var message) async {
    await setLocalStorage(jsonEncode(message));
  }

  static Future<void> setLocalStorage(String value) async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setString(localStorageKey, value);
  }

  static Future<String?> getLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(localStorageKey);
  }

  static Future<void> removeLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.remove(localStorageKey);
  }

  static Future<void> setLocalStorageUrl(String value) async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setString(localStorageKeyUrl, value);
  }

  static Future<String?> getLocalStorageUrl() async {
    final localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(localStorageKeyUrl);
  }

  static Future<Object?> getHttpStrage(String urlString) async {
    Uri url = Uri.parse("$urlString/items");
    Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).timeout(const Duration(milliseconds: 10));
    int statusCode = response.statusCode;
    // print("Statsu code=$statusCode");
    if (statusCode != 200) {
      throw MyException("Statsu code=$statusCode");
    }
    return json.decode(response.body);
  }

  static Future<void> setHttpStrage(String urlString, var body) async {
    Uri url = Uri.parse("$urlString/items");
    Response result = await http
        .post(url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body))
        .timeout(const Duration(milliseconds: 10));
    int statusCode = result.statusCode;
    // print("Statsu code=$statusCode");
    if (statusCode != 200) {
      throw MyException("Statsu code=$statusCode");
    }
  }
}

class MyException implements IOException {
  String cause;
  MyException(this.cause);
}

class MySave extends StatefulWidget {
  const MySave({Key? key}) : super(key: key);

  static const String callName = "/Save";
  @override
  // ignore: library_private_types_in_public_api
  _MySave createState() => _MySave();
}

class _MySave extends State<MySave> {
  static String urlName = "URL";

  static List<String> item = [
    "Local save",
    "Local load",
    urlName,
    "URL save",
    "URL load"
  ];

  final myController = TextEditingController();

  Future<void> goAction(
      BuildContext context, RootData rootData, int index) async {
    try {
      switch (index) {
        case 0:
          await StorageManagementService.setLocalStorageUrl(myController.text);
          await StorageManagementService.setLocalStrageJson(rootData.lists);
          break;
        case 1:
          myController.text =
              (await StorageManagementService.getLocalStorageUrl())!;
          Object? obj = await StorageManagementService.getLocalStrageJson();
          rootData.clearList();
          if ((obj != null) && (obj is Map)) {
            obj.forEach((key, value) {
              rootData.addList(key, value);
            });
          }
          break;
        case 3:
          await StorageManagementService.setHttpStrage(
              myController.text, rootData.lists);
          break;
        case 4:
          Object? obj =
              await StorageManagementService.getHttpStrage(myController.text);
          if ((obj != null) && (obj is Map)) {
            rootData.clearList();
            obj.forEach((key, value) {
              rootData.addList(key, value);
            });
          }
          break;
        case 2: // empty
        default:
          break;
      }
    } catch (e) {
      String errorMessage = "Exception : $e";
      AlertDialog(
        title: const Text('Exception happend'),
        content: Text(errorMessage),
        actions: <Widget>[
          GestureDetector(
            child: const Text('OK'),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    myController.text = "http://192.168.1.1:3001";

    List<Widget> rowList = List<Widget>.generate(
        item.length,
        (index) => item[index] == urlName
            ? Container(
                alignment: Alignment.centerLeft,
                width: 800,
                child: TextField(controller: myController))
            : Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    goAction(context, rootData, index);
                  },
                  child: Text(item[index]),
                )));

    return Scaffold(
        appBar: AppBar(
          title: const Text("Save/Load"),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(children: rowList));
  }
}
