import 'package:flutter/material.dart';
import 'package:guavapay/models/walletfunds/simulateTransfer.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';

import '../utilities/appText.dart';

class FundDialog extends StatefulWidget {
  var _getAcc, _currency;
  FundDialog(this._getAcc, this._currency, {Key? key}) : super(key: key);

  @override
  State<FundDialog> createState() => _FundDialogState();
}

class _FundDialogState extends State<FundDialog> {
  final _amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 300,
        height: 300,
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              whitesmallText("Fund Your Account", color: Colors.black),
              const SizedBox(height: 50),
              inputFeild("Enter Amount", "", _amount,
                  keyboard: TextInputType.number),
              RawMaterialButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await simulateTx(
                          widget._getAcc, widget._currency, _amount.text)
                      .then((v) {
                    overlaySuccess("Account Funding Successful!!!!!!!!!");
                  });
                },
                child: smallText("Fund", color: Colors.white),
                fillColor: pcolor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
