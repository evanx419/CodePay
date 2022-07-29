import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget blackMiddiumText(
  String text, {
  Color color = const Color(0xff22277a),
}) {
  return Text(
    text,
    style: GoogleFonts.kanit(
      fontSize: 24,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget whitesmallText(String text,
    {Color color = Colors.white, double size = 16}) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget payText(String text, {Color color = Colors.white, double size = 23}) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget guavaText(String text, {double size = 20, Color color = Colors.white}) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget balance(String text) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: 25,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget greyText(String? text, double size) {
  return Text(
    text!,
    style: GoogleFonts.urbanist(
      fontSize: size,
      color: const Color.fromARGB(255, 214, 211, 211),
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget smallText(String? text, {Color color = Colors.black}) {
  return Text(
    text!,
    style: GoogleFonts.urbanist(
      fontSize: 15,
      color: color,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget customText(String text, double size, Color color) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget title(String? text, {Color color = Colors.black}) {
  return Text(
    text!,
    style: GoogleFonts.urbanist(
      fontSize: 13,
      color: color,
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget text(
  String text, {
  Color color = Colors.black,
}) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget redText(String? text, {Color color = Colors.red}) {
  return Text(
    text!,
    style: GoogleFonts.urbanist(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w200,
    ),
  );
}

Widget listtext(
  String text, {
  Color color = Colors.black,
}) {
  return Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: 15,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );
}
