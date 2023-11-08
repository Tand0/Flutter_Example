import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:async';
import 'root_data.dart';

class MyImageCanvasAsset extends StatefulWidget {
  const MyImageCanvasAsset({Key? key}) : super(key: key);

  @override
  createState() => _MyImageCanvasAsset();
}

class MyImages {
  ui.Image forAsset;
  ui.Image forWeb;
  MyImages(this.forAsset, this.forWeb);
}

class _MyImageCanvasAsset extends State<MyImageCanvasAsset> {
  Future<MyImages> _loadImage(
      String imageAssetPath, String imageWebPath) async {
    //
    final ByteData dataAsset = await rootBundle.load(imageAssetPath);
    Uint8List uint8ListAsset = dataAsset.buffer.asUint8List();
    final codecAsset = await ui.instantiateImageCodec(uint8ListAsset);
    var frameAsset = await codecAsset.getNextFrame();
    //
    //
    //
    Uri uriWeb = Uri.parse(imageWebPath);
    Uint8List uint8ListWeb = await http.readBytes(uriWeb);
    final codecWeb = await ui.instantiateImageCodec(uint8ListWeb);
    var frameWeb = await codecWeb.getNextFrame();
    //
    MyImages myImages = MyImages(frameAsset.image, frameWeb.image);
    //
    return myImages;
  }

  @override
  Widget build(BuildContext context) {
    var x = ModalRoute.of(context)!.settings.arguments;
    String title = "--";
    if (x is RouteData) {
      title = x.title;
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: FutureBuilder<MyImages>(
            future: _loadImage("images/1girl.png",
                "https://raw.githubusercontent.com/Tand0/Flutter_Example/main/graphic/imave_view/images/1girl.png"),
            builder: (BuildContext context, AsyncSnapshot<MyImages> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Image loading...');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(
                      child: CustomPaint(
                        painter: MyImagePainter(snapshot.data!),
                        child: const SizedBox(
                          width: 512,
                          height: 760,
                        ),
                      ),
                    );
                  }
              }
            }));
  }

  Widget getImage() {
    return Image.asset('./images/1girl.png');
  }
}

class MyImagePainter extends CustomPainter {
  MyImages? myImage;
  MyImagePainter(this.myImage);
  @override
  void paint(Canvas canvas, Size size) async {
    if (myImage != null) {
      canvas.drawImage(myImage!.forAsset, const Offset(0, 0), Paint());
      canvas.drawImage(myImage!.forAsset, const Offset(100, 0), Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
