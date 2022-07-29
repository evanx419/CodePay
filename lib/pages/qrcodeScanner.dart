import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guavapay/screens/dashboard.dart';
import 'package:guavapay/screens/landing.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../models/userbdmodel/userdb.dart';
import '../models/walletfunds/respond.dart';
import '../models/walletfunds/transfer.dart';
import '../utilities/appText.dart';
import '../utilities/variables.dart';

class Qrsend extends StatefulWidget {
  Qrsend({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrsendState();
}

class _QrsendState extends State<Qrsend> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _pwd = TextEditingController();
  bool _pwdcheck = false;
  int k = 0;
  List qr = [];

  _onSubmit() async {
    await transferFund(myWalletId, qr[2].toString().trim(),
            qr[1].toString().trim(), qr[3].toString().trim())
        .then((value) async {
      if (value.status.errorCode != "") {
        overlayError(value.status.errorCode);
        return;
      }
      await txRespond(value.data.id, "accept", "accepted").then((val) {
        if (val.status.errorCode != "") {
          overlayError(value.status.errorCode);
          return;
        }
      });
      overlaySuccess("Transaction Successful");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
          (route) => false);
    });

// ###############################
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherAppBar("Scan Payment QRcode", context),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        setState(() {
          qr = result!.code!.replaceAll("[", "").replaceAll("]", "").split(",");
        });
        print(qr);
        if (qr.contains("codepay")) {
          if (k < 1) {
            _auth();
            print(result!.code);
          }
          setState(() {
            k = 2;
          });

          // Navigator.pop(context);
        }
        // print("close");
      }
    });
  }

  _auth() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              smallText(
                  "You're about Tranferring ${qr[1].toString()} ${qr[3].toString()} to ${qr[2].toString()} "),
              const SizedBox(height: 10),
              inputFeild("Enter Password", "", _pwd,
                  obsc: true, keyboard: TextInputType.number),
              RawMaterialButton(
                onPressed: _pwdcheck
                    ? null
                    : () async {
                        if (_pwd.text.isEmpty) {
                          print("Enter Account Password");
                          return;
                        }
                        await getUsers().then((value) async {
                          List<String> _pwdlist = [];
                          List<String> _id = [];

                          _pwdchecker(true);

                          value.data.forEach((e) {
                            _pwdlist.add(e.pwd.trim());
                            _id.add(e.walletId.trim());
                          });

                          var pos = _id.indexOf(myWalletId).abs();

                          if (_pwdlist[pos] == _pwd.text) {
// ############# POst ###########################
                            Navigator.of(context).pop();
                            await _onSubmit();
                            _pwdchecker(false);
                          } else {
                            overlayError("Incorrect Password");
                            _pwdchecker(false);
                            return null;
                          }
                        });
                      },
                child: smallText("Proceed", color: Colors.white),
                fillColor: Color(0xff22277a),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  _pwdchecker(val) {
    return setState(() {
      _pwdcheck = val;
    });
  }
}
