import "dart:convert";
import "package:dargon2_flutter/dargon2_flutter.dart";

class MyArgon2 {
  final int size = 64;
  final int iterations = 2;
  final int memory = 2000000 ~/ 1024;
  final int parallelism = 1;
  Argon2Type type = Argon2Type.id;
  Argon2Version version = Argon2Version.V13;
  Future<String> hash(String password, List<int> saultByte) async {
    //
    //
    DArgon2Flutter.init();
    await Future.delayed(const Duration(seconds: 1));
    // If you do not include the above wait, the following error will occur
    //    Error: [DArgon2ErrorCode.ARGON2_UNKNOWN_ERROR]
    //    TypeError: Cannot read properties of undefined (reading 'argon2i')
    //
    //
    Salt salt = Salt(saultByte);
    DArgon2Result result = await argon2.hashPasswordString(password,
        salt: salt,
        iterations: iterations,
        memory: memory,
        parallelism: parallelism,
        length: size,
        type: type,
        version: version);

    /*
    String base64Hash = result.base64String;
    String hexHash = result.hexString;
    String encodedString = result.encodedString;
    */

    List<int> rawBytes = result.rawBytes;
    String base64Hash = base64Url.encode(rawBytes);
    //
    // Call the compute hash
    return base64Hash.substring(0, size);
  }
}
