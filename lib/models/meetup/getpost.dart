import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Meetupclass {
  Meetupclass({
    required this.error,
    required this.errmsg,
    required this.data,
  });

  final bool error;
  final String? errmsg;
  final List<Datum> data;

  factory Meetupclass.fromRawJson(String str) =>
      Meetupclass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meetupclass.fromJson(Map<String, dynamic> json) => Meetupclass(
        error: json["error"],
        errmsg: json["errmsg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "errmsg": errmsg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.eWallet,
    required this.message,
    required this.name,
    required this.country,
    required this.date,
  });

  final String id;
  final String eWallet;
  final String message;
  final String name;
  final String country;
  final String date;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        eWallet: json["eWallet"],
        message: json["message"],
        name: json["name"],
        country: json["country"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eWallet": eWallet,
        "message": message,
        "name": name,
        "country": country,
        "date": date,
      };
}

Stream<Meetupclass> streammeeting() =>
    Stream.periodic(const Duration(microseconds: 1))
        .asyncMap((event) => getpost());

Future<Meetupclass> getpost() async {
  try {
    var meetList = await get(
      Uri.parse("https://codepay.guavacodeplus.tech/getpost.php"),
    );

    // print(meetList.body);

    if (meetList.statusCode == 200) {
      var meet = Meetupclass.fromJson(json.decode(meetList.body));

      return meet;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}

Future sendpost(eWallet, message, name, country, date) async {
  try {
    var meet = await post(
      Uri.parse("https://codepay.guavacodeplus.tech/createpost.php"),
      body: {
        "eWallet": eWallet,
        "message": message,
        "name": name,
        "country": country,
        "date": date,
      },
    );
    // print(meet.body);
    if (meet.statusCode == 200) {
      return json.decode(meet.body);
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}
