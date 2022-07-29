import 'dart:convert';
import 'utilities/urls.dart';
import 'package:guavapay/utilities/signature.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Future getRequest() async {
    RequestInit().getSignature("/v1/data/countries", "get");

    var getAccess = await get(
      Uri.parse(fetchusers),
    );

    print(getAccess.body);
  }




  Future postRequest() async {
    RequestInit().getSignature("/v1/data/countries", "get");

    var getAccess = await get(
      Uri.parse(fetchusers),
    );

    print(getAccess.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MaterialButton(
        onPressed: () {
          getRequest();
        },
        child: Text("press!!!!!!!!!!!!!!!"),
      ),
    );
  }
}