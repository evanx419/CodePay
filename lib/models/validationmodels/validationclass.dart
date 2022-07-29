import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utilities/signature.dart';

class Verify {
  Verify({
    required this.status,
    required this.data,
  });

  final Status status;
  final Data data;

  factory Verify.fromRawJson(String str) => Verify.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Verify.fromJson(Map<String, dynamic> json) => Verify(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.referenceId,
  });

  final String id;
  final String referenceId;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        referenceId: json["reference_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference_id": referenceId,
      };
}

class Status {
  Status({
    required this.errorCode,
    required this.status,
    required this.message,
    required this.responseCode,
    required this.operationId,
  });

  final String errorCode;
  final String status;
  final String message;
  final String responseCode;
  final String operationId;

  factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        errorCode: json["error_code"],
        status: json["status"],
        message: json["message"],
        responseCode: json["response_code"],
        operationId: json["operation_id"],
      );

  Map<String, dynamic> toJson() => {
        "error_code": errorCode,
        "status": status,
        "message": message,
        "response_code": responseCode,
        "operation_id": operationId,
      };
}

Future<Verify> verification(nation, doc, ewallet, faceB,frontB,backB, mime, refid) async {
  String url = "https://sandboxapi.rapyd.net/v1/identities";

  var myBody = jsonEncode({
    "country": nation,
    "document_type": doc,
    "ewallet": ewallet,
    "face_image": faceB,
    "face_image_mime_type": mime,
    "front_side_image": frontB,
    "front_side_image_mime_type": mime,
    "back_side_image": backB,
    "back_side_image_mime_type": mime,
    "reference_id":refid,
  });

  await RequestInit().getSignature("/v1/identities", "post", bodyData: myBody);

  try {
    var resp = await post(
      Uri.parse(url),
      headers: header,
      body: myBody,
    );
 print(resp.body);
    if (resp.statusCode == 200) {
      return Verify.fromJson(json.decode(resp.body));
    } else {
     
      throw Exception(resp);
    }
  } on SocketException {
    throw Exception();
  }
}
