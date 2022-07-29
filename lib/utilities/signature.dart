import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

var header;

class RequestInit {

  
  Future<String> getSignature(String urlPath, String httpMethod,{String bodyData = ""}) async {
    int unixTimetamp = DateTime.now().millisecondsSinceEpoch;
    String timestamp = (unixTimetamp / 1000).round().toString();

// salt
    var salt = (100000000 + Random().nextInt(999999999 - 100000000)).toString();
    var _accessKey = "25FD5C25BC1510981C58";
    var _secretKey =
        "850a5d43c2bc93b4e69bc92d696f9c0c8c28818ba211d9e5947043c57b371bd5e2c9519d2ec1dea9";


    var toSign = httpMethod +
        urlPath +
        salt +
        timestamp +
        _accessKey +
        _secretKey +
        bodyData;

    // print(toSign);

    var key = ascii.encode(_secretKey);
    var toSignEncoded = ascii.encode(toSign);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256

    var hashSign = hmacSha256.convert(toSignEncoded);

    var ss = HEX.encode(hashSign.bytes);

    var tt = ss.codeUnits;

    var signatureData = base64.encode(tt);

    header = {
      'Content-Type': 'application/json',
      'access_key': _accessKey,
      'salt': salt,
      'timestamp': timestamp,
      'signature': signatureData,
    };

    return signatureData;
  }
}
