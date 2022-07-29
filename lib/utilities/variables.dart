import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:overlay_support/overlay_support.dart';

var adminwallet = "ewallet_41e7e61d1381f6e95c9d5e922d3ea071";

Widget inputFeild(String label, String hint, _controller,
    {bool obsc = false,
    bool enable = true,
    TextInputType keyboard = TextInputType.name,
    len = 500,
    lineheight = 1}) {
  return TextField(
    enabled: enable,
    cursorColor: Colors.black,
    style: GoogleFonts.urbanist(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w300,
    ),
    decoration: InputDecoration(
      labelText: label,
      border: InputBorder.none,
      hintText: hint,
      counterText: "",
    ),
    keyboardType: keyboard,
    controller: _controller,
    obscureText: obsc,
    maxLength: len,
    maxLines: lineheight,
    // controller: _controller,
  );
}

var themedata = ThemeData(
  brightness: Brightness.light,
  // accentColor: Colors.orange,
  // primarySwatch: Colors.orange,
  colorScheme: ColorScheme.light(primary: pcolor),

  inputDecorationTheme: InputDecorationTheme(
    fillColor: Color.fromARGB(255, 241, 245, 248),
    filled: true,
    floatingLabelStyle: const TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: pcolor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1.0,
      ),

      // color: Color.fromARGB(255, 240, 240, 240),
      // width: 2.0,
    ),
    prefixIconColor: const Color.fromARGB(255, 27, 24, 24),
    hintStyle: GoogleFonts.urbanist(
      fontSize: 12,
      color: Colors.grey,
    ),
    labelStyle: GoogleFonts.urbanist(
      fontSize: 12,
      color: const Color.fromARGB(255, 49, 48, 48),
    ),
  ),
);

loader() {
  return const CircularProgressIndicator(
    strokeWidth: 2,
    color: Colors.black,
  );
}

List<String> currencies = [
  "USD",
  "SGD",
  "MXN",
  "EUR",
  "GBP",
  "AED",
  "AUD",
  "CAD",
  "CHF",
  "CZK",
  "DKK",
  "HKD",
  "HRK",
  "HUF",
  "ILS",
  "JPY",
  "NOK",
  "NZD",
  "PLN",
  "RON",
  "SAR",
  "SEK",
  "TRY",
  "ZAR"
];

List<double> conversion = [
  1.0,
  1.40,
  20.41,
  0.97,
  0.83,
  3.67,
  1.47,
  1.29,
  0.96,
  24.03,
  7.22,
  7.85,
  7.31,
  393.68,
  3.53,
  135.95,
  20.41,
  1.62,
  4.60,
  4.80,
  3.75,
  10.48,
  16.98,
  16.42
];

Map<String, List<String>> basecountries = {
  "United Kingdom": ["GBP"],
  "Germany": ["EUR"],
  "Denmark": [
    "AED",
    "AUD",
    "CAD",
    "CHF",
    "CZK",
    "DKK",
    "HKD",
    "HRK",
    "HUF",
    "ILS",
    "JPY",
    "MXN",
    "NOK",
    "NZD",
    "PLN",
    "RON",
    "SAR",
    "SEK",
    "SGD",
    "TRY",
    "USD",
    "ZAR"
  ],
  "Mexico": ["MXN"],
  "Singapore": ["SGD", "USD"]
};

void displayDialog(
  BuildContext context,
  title,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: const Text("You are awesome!"),
        actions: <Widget>[
          MaterialButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

overlaySuccess(text, {Color color = Colors.green}) {
  return showSimpleNotification(title(text, color: Colors.white),
      background: color);
}

overlayError(text, {Color color = Colors.red}) {
  return showSimpleNotification(title(text, color: Colors.white),
      background: color);
}

errormsg() {
  return showSimpleNotification(
      title("connection error", color: Colors.black54),
      background: Colors.white60);
}

 var myWalletId = "";
int currentIndex = 0;