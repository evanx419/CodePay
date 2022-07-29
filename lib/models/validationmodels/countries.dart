import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';


class Country {
  Country({
    required this.status,
    required this.data,
  });

  final Status status;
  final List<Datum> data;

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
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
    required this.id,
    required this.name,
    required this.isoAlpha2,
    required this.isoAlpha3,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySign,
    required this.phoneCode,
  });

  final int id;
  final String name;
  final String isoAlpha2;
  final String isoAlpha3;
  final String currencyCode;
  final String currencyName;
  final String currencySign;
  final String phoneCode;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        isoAlpha2: json["iso_alpha2"],
        isoAlpha3: json["iso_alpha3"],
        currencyCode: json["currency_code"],
        currencyName: json["currency_name"],
        currencySign: json["currency_sign"],
        phoneCode: json["phone_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso_alpha2": isoAlpha2,
        "iso_alpha3": isoAlpha3,
        "currency_code": currencyCode,
        "currency_name": currencyName,
        "currency_sign": currencySign,
        "phone_code": phoneCode,
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

List<String> countryName = [];
List<String> countryiso = [];
List<String> currencyname = [];
List<String> currencycode = [];
List<String> currencysign = [];
List<String> countrynum = [];

Future<Country> getCountries() async {
  RequestInit().getSignature("/v1/data/countries", "get");

  List cname = [];
  List ciso = [];
  List cycode = [];
  List cyname = [];
  List cysign = [];
  List cnum = [];
  try {
    var getAccess = await get(
        Uri.parse("https://sandboxapi.rapyd.net/v1/data/countries"),
        headers: header);

    if (getAccess.statusCode == 200) {
      var result = Country.fromJson(json.decode(getAccess.body));
      // print(result.data[7].name.toString());

      result.data.forEach((element) {
        cname.add(element.name);
        ciso.add(element.isoAlpha2.toUpperCase());
        cycode.add(element.currencyCode);
        cyname.add(element.currencyName);
        cysign.add(element.currencySign);
        cnum.add(element.phoneCode);
      });

      countryName = cname.cast<String>();
      countryiso = ciso.cast<String>();
      countrynum = cnum.cast<String>();
      currencycode = cycode.cast<String>();
      currencysign = cysign.cast<String>();
      currencyname = cyname.cast<String>();
      // print(result.data[1].);
      return result;
    } else {
      throw Exception(getAccess.statusCode);
    }
  } on SocketException {
    throw Exception();
  }

  // print(result);
}
