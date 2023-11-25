import 'dart:convert';

import '../wrapper/mynai_client_wrapper.dart';
import 'my_response.dart';
import 'package:flutter/material.dart';
import 'my_login.dart';

import 'my_login_failed.dart';
import 'my_select.dart';

class RootData with ChangeNotifier {
  Map<String, WidgetBuilder> _route = {};

  RootData() {
    route[MyLogin.callName] = (BuildContext context) => MyLogin();
  }

  set route(s) {
    _route = s;
  }

  get route => _route;

  void pushNamed(BuildContext context, String callName, WidgetBuilder builder,
      String? title) {
    if (title != null) setTargetKey(title);
    route[callName] = builder;
    Navigator.of(context).pushNamed(callName, arguments: null);
  }

  static const String subscription = "Subscription";
  static const String genearteImage = "Genearte Image";
  static const String suggest = "Suggest";
  String targetKey = subscription;
  Map<String, dynamic> jsonStringData = {
    subscription: {},
    genearteImage: {
      "input":
          " solo, little girl , sofa, maid,  knees up, sitting,, best quality, amazing quality, very aesthetic, absurdres",
      "model": "nai-diffusion-3",
      "action": "generate",
      "parameters": {
        "width": 512,
        "height": 768,
        "scale": 5,
        "sampler": "k_euler",
        "steps": 28,
        "seed": 3231774193,
        "n_samples": 1,
        "ucPreset": 0,
        "qualityToggle": true,
        "sm": false,
        "sm_dyn": false,
        "dynamic_thresholding": false,
        "controlnet_strength": 1,
        "legacy": false,
        "add_original_image": false,
        "uncond_scale": 1,
        "cfg_rescale": 0,
        "noise_schedule": "native",
        "negative_prompt":
            "nsfw, lowres, {bad}, error, fewer, extra, missing, worst quality, jpeg artifacts, bad quality, watermark, unfinished, displeasing, chromatic aberration, signature, extra digits, artistic error, username, scan, [abstract]"
      }
    },
    suggest: {"model": "nai-diffusion-3", "prompt": "black buruma"}
  };
  void setTargetKey(String s) {
    targetKey = s;
  }

  String getTargetKey() {
    return targetKey;
  }

  String getJsonString() {
    var value = jsonStringData[getTargetKey()];
    return const JsonEncoder.withIndent('    ').convert(value);
  }

  dynamic _response;
  dynamic getResponse() {
    return _response;
  }

  void setResponse(dynamic x) {
    _response = x;
  }

  MyNAIClientWraper? wapper;
  void startLogin(BuildContext context, RootData rootData, String userName,
      String userCommuinity) {
    Future(() async {
      try {
        wapper = MyNAIClientWraper();
        await wapper!.loginWrapper(userName, userCommuinity);
        //
        if (!context.mounted) return;
        rootData.pushNamed(context, MySelect.callName,
            (BuildContext context) => const MySelect(), null);
      } catch (e) {
        if (!context.mounted) return;
        rootData.pushNamed(context, MyLoginFailed.callName,
            (BuildContext context) => const MyLoginFailed(), null);
      }
    });
  }

  void nextAction(BuildContext context, String title, String jsonText) {
    setResponse("Unkown commommand");
    Future(() async {
      try {
        if (wapper == null) {
          throw Exception("wapper != null");
        }
        switch (title) {
          case subscription:
            String res = await wapper!.userSubscriptionWrapper();
            var jsonDict = json.decode(res);
            String jsonText =
                const JsonEncoder.withIndent('    ').convert(jsonDict);
            setResponse(jsonText);
            break;
          case suggest:
            var jsonData = json.decode(jsonText);
            String model = "nai-diffusion-3";
            if (jsonData.containsKey("model")) {
              model = jsonData["model"];
            }
            String prompt = "black buruma";
            if (jsonData.containsKey("prompt")) {
              prompt = jsonData["prompt"];
            }
            String res =
                await wapper!.aiGenerateImageSuggestTagsWrapper(model, prompt);
            var jsonDict = json.decode(res);
            jsonText = const JsonEncoder.withIndent('    ').convert(jsonDict);
            setResponse(jsonText);
            break;
          case genearteImage:
            var body = json.decode(jsonText);
            Image res = await wapper!.aiGenerateImageWrapper(body);
            setResponse(res);
            break;
          default:
            break;
        }
      } catch (e) {
        setResponse("Error:$e");
      }
      //
      if (!context.mounted) return;
      pushNamed(context, MyResponse.callName,
          (BuildContext context) => const MyResponse(), null);
    });
  }

  String userName = "";
  String userCommuinity = "";
}
