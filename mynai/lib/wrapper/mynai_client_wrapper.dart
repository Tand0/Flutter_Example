import 'dart:convert';
import "dart:io";
import 'package:http/http.dart' as http;
import "for_argon2.dart" as fa2;
import "for_blake2b.dart" as fb2;
import 'package:archive/archive_io.dart' as arc;
import 'package:flutter/material.dart';

class MyNAIException implements Exception {
  int statusCode;

  String message;

  MyNAIException({this.statusCode = HttpStatus.badRequest, this.message = ""});

  @override
  String toString() {
    return "Error: ($statusCode) $message";
  }
}

class MyNAIClientWraper {
  String baseURL;

  MyNAIClientWraper({this.baseURL = "https://api.novelai.net"});

  void setBaseURL(String url) {
    baseURL = url;
  }

  String getBaseURL() {
    return baseURL;
  }

  Future<String> getAKey(String email, String originalPassword) async {
    fb2.MyBlake2b myBlake2b = fb2.MyBlake2b();
    String password = myBlake2b.getPassword(email, originalPassword);
    List<int> sault = await myBlake2b.getAKey(password);
    String result = await fa2.MyArgon2().hash(originalPassword, sault);
    return result;
  }

  static const String authorizationHeader = "Bearer ";
  static const String authorization = "Authorization";
  static const String accessToken1 = "accessToken";
  String? authorizationKey;

  static const String loginUrl = "/user/login";

  static const String subscriptionUrl = "/user/subscription";

  static const String suggestTagsUrl = "/ai/generate-image/suggest-tags";

  static const String imageUrl = "/ai/generate-image";

  static const String upscaleUrl = "/ai/upscale";

  Future<String?> loginWrapper(String email, String originalPassword) async {
    String key = await getAKey(email, originalPassword);
    dynamic body = {"key": key};
    String bodyText = json.encode(body);
    //
    Uri url = Uri.parse(getBaseURL() + loginUrl);
    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: bodyText);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw MyNAIException(
          statusCode: response.statusCode, message: response.body);
    }
    //
    String resultJson = response.body;
    dynamic result = json.decode(resultJson);
    if (result is Map) {
      if (result.containsKey(accessToken1)) {
        authorizationKey = authorizationHeader + result[accessToken1];
      }
    }
    return authorizationKey;
  }

  Future<String> userSubscriptionWrapper() async {
    if (authorizationKey == null) {
      throw MyNAIException(
          statusCode: HttpStatus.unauthorized,
          message: "authorizationKey is null");
    }
    Uri url = Uri.parse(getBaseURL() + subscriptionUrl);
    http.Response response =
        await http.get(url, headers: {authorization: authorizationKey!});
    if (response.statusCode >= HttpStatus.badRequest) {
      throw MyNAIException(
          statusCode: response.statusCode, message: response.body);
    }
    return response.body;
  }

  Future<String> aiGenerateImageSuggestTagsWrapper(
      String model, String prompt) async {
    Uri url = Uri.parse(
        "${getBaseURL()}$suggestTagsUrl?model=${Uri.encodeFull(model)}&prompt=${Uri.encodeFull(prompt)}");

    http.Response response =
        await http.get(url, headers: {authorization: authorizationKey!});
    if (response.statusCode >= HttpStatus.badRequest) {
      throw MyNAIException(
          statusCode: response.statusCode, message: response.body);
    }
    return response.body;
  }

  Future<Image> aiGenerateImageWrapper(dynamic body) async {
    String bodyText = json.encode(body);

    Uri url = Uri.parse(getBaseURL() + imageUrl);
    http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          authorization: authorizationKey!
        },
        body: bodyText);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw MyNAIException(
          statusCode: response.statusCode, message: response.body);
    }
    String? mime = response.headers["content-type"];
    if (mime == null) {
      throw MyNAIException(
          statusCode: response.statusCode, message: "content-type is null");
    }
    if (mime != "application/x-zip-compressed") {
      throw MyNAIException(
          statusCode: response.statusCode,
          message: "file is not zip type=$mime");
    }
    final archive = arc.ZipDecoder().decodeBytes(response.bodyBytes);
    for (final file in archive) {
      if (file.isFile) {
        return Image.memory(file.content);
      }
    }
    throw MyNAIException(
        statusCode: response.statusCode, message: "Zip file empty");
  }
}
