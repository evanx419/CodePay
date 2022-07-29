import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

String username = 'everistusnwogo@yahoo.com';
String password = '@evan5050';

Future sendMail() async {
  final smtpServer = yahoo(username, password);
  final message = Message()
    ..from = const Address("everistusnwogo@yahoo.com", 'codePay')
    ..recipients.add('everistusnwogo@gmail.com')
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    print(e);
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart';

// // var emailurl = ';

// Future sendMail(subject, message, name, userEmail) async {
//   try {
//     final postmail = await post(
//       Uri.parse("https://api.emailjs.com/api/v1.0/email/send"),
//       headers: {
//         'contentType': 'application/json',
//       },
//       body: json.encode(
//         {
//           "user_id": 'Bt5m8vr3mnL9i4ObH',
//           'service_id': 'service_pabikhl',
//           'template_id': 'template_x1jdjyw',
//           'template_params': {
//             'user_subject': subject,
//             'user_message': message,
//             'user_name': name,
//             'user_email': userEmail,
//           },
//         },
//       ),
//     );
//     print(postmail.body);

//     if (postmail.statusCode == 200) {
//       return 'successs';
//     } else {
//       return postmail.body;
//     }
//   } on SocketException {}
// }
