import 'package:flutter/material.dart';
import 'package:guavapay/models/walletfunds/respond.dart';
import 'package:guavapay/utilities/sharedprefernce.dart';

import '../utilities/appText.dart';
import '../utilities/appbar.dart';
import '../utilities/variables.dart';

class Respond extends StatefulWidget {
  const Respond({Key? key}) : super(key: key);

  @override
  State<Respond> createState() => _RespondState();
}

class _RespondState extends State<Respond> {
  var _id = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Respond", context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                inputFeild("Payment Id", "", _id),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: MaterialButton(
                        color: Colors.green,
                        onPressed: () async {
                          if (_id.text.isEmpty) {
                            print("Empty");
                            return;
                          }

                          await txRespond(_id.text, "accept", "Accepted");
                        },
                        child: whitesmallText("Accept"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: MaterialButton(
                        color: Colors.red,
                        onPressed: () async {
                          
                          if (_id.text.isEmpty) {
                            print("Empty");
                            return;
                          }
// savedata("ewallet_2750605599629c1178da78a4800c7467");
                          await txRespond(_id.text, "decline", "Decline");
                        },
                        child: whitesmallText("Decline"),
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _state(val) {
    return setState(() {
      _isLoading = val;
    });
  }
}
