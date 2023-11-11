import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'root_data.dart';
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

  static Future<String?> getLocalStorageUrl() async {
    final localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(localStorageKeyUrl);
  }

  static Future<Object?> getHttpStrage(String urlString) async {
    Uri url = Uri.parse("$urlString/items");
    print("set" + url.toString());
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
    print("set" + url.toString());
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
  static Map? ipAdressData;

  static List<String> item = [
    "Local save",
    "Local load",
    "URL save",
    "URL load"
  ];

  static Future<Map?> getUrl() async {
    String loadIP = await rootBundle.loadString('./ip.json');
    ipAdressData = json.decode(loadIP);
    return ipAdressData;
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await getUrl();
      setState(() {});
    });
  }

  String? urlString;

  Future<void> goAction(
      BuildContext context, RootData rootData, int index) async {
    if (urlString == null) {
      return; // No not yet!
    }
    try {
      switch (index) {
        case 0:
          await StorageManagementService.setLocalStrageJson(rootData.lists);
          break;
        case 1:
          Object? obj = await StorageManagementService.getLocalStrageJson();
          rootData.clearList();
          if ((obj != null) && (obj is Map)) {
            obj.forEach((key, value) {
              rootData.addList(key, value);
            });
          }
          break;
        case 2:
          await StorageManagementService.setHttpStrage(
              urlString!, rootData.lists);
          break;
        case 3:
          Object? obj =
              await StorageManagementService.getHttpStrage(urlString!);
          if ((obj != null) && (obj is Map)) {
            rootData.clearList();
            obj.forEach((key, value) {
              rootData.addList(key, value);
            });
          }
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
    if (ipAdressData != null) {
      urlString = ipAdressData?['url'];
    } else {
      urlString = "http://127.0.0.1:3001";
    }

    List<Widget> rowList = List<Widget>.generate(
        item.length,
        (index) => Container(
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
