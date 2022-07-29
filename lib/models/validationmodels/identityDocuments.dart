import 'package:guavapay/utilities/signature.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Documents {
  Documents({
    required this.status,
    required this.data,
  });

  final Status status;
  final List<Datum> data;

  String toRawJson() => json.encode(toJson());

  factory Documents.fromJson(Map<String, dynamic> json) => Documents(
        status: Status.fromJson(json["status"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.country,
    required this.type,
    required this.name,
    required this.isBackRequired,
    required this.isAddressExtractable,
  });

  final String country;
  final String type;
  final String name;
  final bool isBackRequired;
  final bool isAddressExtractable;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        country: json["country"],
        type: json["type"],
        name: json["name"],
        isBackRequired: json["is_back_required"],
        isAddressExtractable: json["is_address_extractable"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "type": type,
        "name": name,
        "is_back_required": isBackRequired,
        "is_address_extractable": isAddressExtractable,
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

// Request URL: GET https://sandboxapi.rapyd.net/v1/identities/types?country=US

// Message body absent

List<String> documentName = [];
List<String> documentType = [];
List<bool> documentBack = [];

Future<Documents> getDocuments(country) async {
  await RequestInit()
      .getSignature('/v1/identities/types?country=$country', "get");

  try {
    var docList = await get(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/identities/types?country=$country"),
      headers: header,
    );

    if (docList.statusCode == 200) {
      var result = Documents.fromJson(json.decode(docList.body));
      result.data.forEach((e) {
        documentName.add(e.name);
        documentType.add(e.type);
        documentBack.add(e.isBackRequired);
      });

      // print(documentName);
      return result;
    } else {
      throw Exception();
    }
  } catch (e) {
    print(e);
    throw Exception(e);
  }
}
