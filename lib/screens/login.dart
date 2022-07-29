import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/pages/loading.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/sharedprefernce.dart';
import 'package:guavapay/utilities/variables.dart';

import 'createwallet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool isVisible = true;
  List<String> _emaillist = [];
  List<String> _pwdlist = [];
  List<String> _id = [];

  final _email = TextEditingController(), _pwd = TextEditingController();

  _onSubmit() async {
    if (_email.text.isEmpty && _pwd.text.isEmpty) {
      overlayError("Empty fields ");
      return null;
    }

    _state(true);

    await getUsers().then((value) {
      value.data.forEach((e) {
        _emaillist.add(e.email.trim());
        _pwdlist.add(e.pwd.trim());
        _id.add(e.walletId.trim());
      });

      if (!_emaillist.contains(_email.text)) {
        overlayError("No matching Email address");
        return null;
      }

      var pos = _emaillist.indexOf(_email.text);

      if (_pwdlist[pos] == _pwd.text) {
        overlaySuccess("Success");
        savedata(_id[pos]);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Loading(_id[pos])));
      } else {
        overlayError("incorrect Password");
        return null;
      }
    });
    _state(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // #################################################
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              const SpinKitRotatingPlain(
                size: 50,
                color: Colors.black45,
              ),
              const SizedBox(height: 20),
              blackMiddiumText("CodePlus", color: pcolor.withOpacity(0.5)),
              const SizedBox(height: 40),
              Container(
                child: Column(
                  children: [
                    inputFeild("Email", "", _email),
                    const SizedBox(height: 10),
                    inputFeild("Password", "", _pwd, obsc: isVisible),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          child: smallText("Create Account?"),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Createwallet())),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          child: isVisible
                              ? smallText("Show Password", color: Colors.grey)
                              : smallText("Hide Password", color: Colors.grey),
                          onTap: () => setState(
                            () => isVisible = !isVisible,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: MaterialButton(
                        color: pcolor,
                        splashColor: Colors.white,
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: _isLoading ? null : () => _onSubmit(),
                        child: _isLoading
                            ? const SpinKitWave(
                                size: 15,
                                color: Colors.black45,
                              )
                            : whitesmallText("Login"),
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: )
              // ##########################################
            ],
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
