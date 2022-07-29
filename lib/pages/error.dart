import 'package:flutter/material.dart';
import 'package:guavapay/utilities/appText.dart';

class DialogPage extends StatelessWidget {
  var _getText;
  DialogPage(this._getText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        color: Colors.white,
        child: Center(
          child: Container(
            child: whitesmallText(_getText, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

callTimeOut(context) async {
  showDialog(
    context: context,
    builder: (_) => DialogPage("Connection Timeout"),
  );
  return null;
}
