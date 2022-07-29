import 'package:flutter/material.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/models/validationmodels/countries.dart';
import 'package:guavapay/screens/dashboard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/screens/landing.dart';
import '../models/walletModel.dart';
import '../models/walletfunds/listTransactions.dart';
import '../utilities/sharedprefernce.dart';
import '../utilities/variables.dart';

class Loading extends StatefulWidget {
  var _wallet;

  Loading(this._wallet, {Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var walletid;
  @override
  void initState() {
    super.initState();

    rWallet(widget._wallet).then(
      (read) async {
        await meetdetails([
          "${read.data.lastName} ${read.data.firstName}",
          (read.data.contacts.data[0].country)
        ]);

        await loaddata().then((value) async {
          setState(() {
            myWalletId = value.toString();
          });
        });

        // if (v.data.verificationStatus != "verified") {
        //   print("null");

        //   //  Navigator.pushReplacement(
        //   //   context,
        //   //   MaterialPageRoute(builder: (context) => Validate(widget._wallet , isback, nation, idname) ),
        //   // );
        //   return;
        // }

        await walletTransactions(widget._wallet).then((value) async {
          // print(1.toString());
          await getCountries().then((val) async {
            // print(2.toString());
            await getUsers().then((v) async {
              // print(3.toString());
              await savedata(widget._wallet);
              // print(4.toString());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
              );
            });
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitWave(
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
