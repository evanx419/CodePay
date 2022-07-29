import 'package:flutter/material.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:intl/intl.dart';
import '../utilities/appbar.dart';

class BalancePage extends StatefulWidget {
  var balance;
  var hold;
  var reserve;
  var rev;
  var currency;

  BalancePage(this.balance, this.rev, this.hold, this.reserve, this.currency,
      {Key? key})
      : super(key: key);

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatCurrency = NumberFormat.simpleCurrency(name: widget.currency);
    return Scaffold(
      appBar: otherAppBar("Balance", context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  blackMiddiumText("Available Balance"),
                  const SizedBox(height: 10),
                  blackMiddiumText(formatCurrency.format(widget.balance)),
                ],
              ),
            ),

            Center(
              child: Column(
                children: [
                  blackMiddiumText("Received Balance"),
                  const SizedBox(height: 10),
                  blackMiddiumText(formatCurrency.format(widget.rev)),
                ],
              ),
            ),
            const Divider(),
            Center(
              child: Column(
                children: [
                  blackMiddiumText("Reserve Balance"),
                  const SizedBox(height: 10),
                  blackMiddiumText(formatCurrency.format(widget.reserve)),
                ],
              ),
            ),
            const Divider(),
            Center(
              child: Column(
                children: [
                  blackMiddiumText("onHold Balance"),
                  const SizedBox(height: 10),
                  blackMiddiumText(formatCurrency.format(widget.hold)),
                ],
              ),
            ),

            // receivedBalance
          ],
        ),
      ),
    );
  }
}
