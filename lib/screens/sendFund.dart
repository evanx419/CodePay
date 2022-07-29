import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guavapay/pages/qrcodeScanner.dart';
import 'package:guavapay/pages/sendewallet.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import '../utilities/appText.dart';
import '../utilities/variables.dart';

class SendFund extends StatefulWidget {
  var wallet;

  SendFund(this.wallet, {Key? key}) : super(key: key);

  @override
  State<SendFund> createState() => _SendFundState();
}

class _SendFundState extends State<SendFund> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: pageAppBar("Send Funds", context),
          // bottomNavigationBar: BottomNav(widget.wallet),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 216, 216, 216),
                      ),
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.qrcode,
                            color: pcolor,
                          ),
                          const SizedBox(width: 30),
                          whitesmallText("QrCode Payment Scanner",
                              color: Colors.black),
                        ],
                      ),
                    ),
                    onTap: () async => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Qrsend())),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 216, 216, 216),
                      ),
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.wallet, color: pcolor),
                          const SizedBox(width: 30),
                          whitesmallText("Send With eWallet Id",
                              color: Colors.black),
                        ],
                      ),
                    ),
                    onTap: () async => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => walletsend(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          setState(() {
            currentIndex = 0;
          });
          return false;
        });
  }
}
