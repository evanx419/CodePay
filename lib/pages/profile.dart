import 'package:flutter/material.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/utilities/appText.dart';

import '../utilities/appbar.dart';
import '../utilities/sharedprefernce.dart';

class Profile extends StatefulWidget {
  var wallet;

  Profile(this.wallet, {Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    loadchat();
  }

  @override
  Widget build(BuildContext context) {
    var _img = profilePix[userswallet.indexOf(widget.wallet)];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("User Profile", context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://cdn-wordpress-info.futurelearn.com/wp-content/uploads/24EA32A8-7C94-4956-A446-0E60C7226780.png"),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Color.fromARGB(255, 231, 230, 228),
                  // backgroundImage: NetworkImage(
                  //   _img,
                  // ),
                  child: Icon(
                    Icons.person,
                    size: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title("Name: ${chatid![0]}"),
                    title("Country: ${chatid![1]}"),
                    title("eWallet Id: ${widget.wallet}"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
