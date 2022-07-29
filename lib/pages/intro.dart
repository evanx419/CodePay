import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/screens/createwallet.dart';
import 'package:guavapay/screens/login.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/color.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
// #################################################
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              const SpinKitRotatingPlain(
                size: 50,
                color: Colors.black45,
              ),
              const SizedBox(
                height: 20,
              ),
              blackMiddiumText("CodePlus", color: pcolor.withOpacity(0.7)),
              Expanded(child: Container()),
              SizedBox(
                height: 60,
                child: MaterialButton(
                  color: pcolor.withOpacity(0.7),
                  splashColor: Colors.white,
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () async => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())),
                  child: whitesmallText("Login"),
                ),
              ),
              const SizedBox(height: 10),
              !state
                  ? SizedBox(
                      height: 60,
                      child: MaterialButton(
                        color: pcolor.withOpacity(0.7),
                        splashColor: Colors.white,
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () => setState(
                          () => state = !state,
                        ),
                        child: whitesmallText("Create Wallet"),
                      ),
                    )
                  : SizedBox(
                      height: 60,
                      child: smallText("Select Acount Type",
                          color: Color.fromARGB(255, 248, 148, 141)),
                    ),

// ##########################################
              state
                  ? Padding(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        height: 140,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              child: MaterialButton(
                                splashColor: Colors.white,
                                color: pcolor.withOpacity(0.2),
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Createwallet())),
                                child: whitesmallText("Personal",
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 60,
                              child: MaterialButton(
                                splashColor: Colors.white,
                                color: pcolor.withOpacity(0.2),
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Createwallet())),
                                child: whitesmallText(
                                  "Business",
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 140,
                    ),
            ],
          )),
        ),
      ),
    );
  }
}
