import 'dart:convert';
import 'dart:typed_data';
import 'package:blake2b/blake2b.dart' as b2;

class MyBlake2b {
  final String domain = "novelai_data_access_key";
  final int digestSize = 16;

  String getPassword(String email, String originalPassword) {
    String shortPassword;
    if (6 <= originalPassword.length) {
      shortPassword = originalPassword.substring(0, 6);
    } else {
      shortPassword = originalPassword;
    }
    return shortPassword + email + domain;
  }

  Future<List<int>> getAKey(password) async {
    //
    Uint8List uint8ListPassword = Uint8List.fromList(password.codeUnits);
    Uint8List uint8ListSalt = Uint8List(digestSize);
    final b2.Blake2b blake2b = b2.Blake2b.blake2b(null, digestSize, null, null);
    blake2b.update(uint8ListPassword, 0, uint8ListPassword.length);
    blake2b.digest(uint8ListSalt, 0);
    //
    /*
    print("email= " + email);
    print("password= " + password);
    print("domain= " + domain);

    print("         password=" + password);
    print("uint8ListPassword=" + myToRadixString(uint8ListPassword));
    print("uint8ListPassword=" + myToString(uint8ListPassword));
    print("    uint8ListSalt=" + myToRadixString(uint8ListSalt));
    print("       targetSalt=0xb01228e5d8758813eae9aad4e9bdf2e");
    print("    uint8ListSalt=" + myToString(uint8ListSalt));
    */
    //
    //
    List<int> result = [];
    for (int i = 0; i < uint8ListSalt.length; i++) {
      result.add(uint8ListSalt[i]);
    }
    return result;
  }

  String myToRadixString(Uint8List list) {
    String ans = "0x";
    for (int i = 0; i < list.length; i++) {
      ans += list[i].toRadixString(16);
    }
    return ans;
  }

  String myToString(Uint8List object) {
    return base64.encode(object.toList());
  }
}
