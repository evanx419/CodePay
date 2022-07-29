import 'package:flutter/material.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/pages/intro.dart';
import 'package:guavapay/pages/profile.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/sharedprefernce.dart';

AppBar mainAppBar(wallet, context) {
  // if (userswallet.indexOf(wallet).isFinite) {
  var _img = profilePix[userswallet.indexOf(wallet)];
  // }

  return AppBar(
    elevation: 0.5,
    shadowColor: Colors.grey[300],
    backgroundColor: Colors.white,
    // centerTitle: true,

    title: blackMiddiumText("Dashboard"),
    actions: [
      Padding(
        padding: const EdgeInsets.all(5),
        child: PopupMenuButton(
          onSelected: (value) async {
            if (value == 3) {
              removedata("name");
              removedata("list");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => IntroPage()),
              );
            } else if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(wallet)),
              );
            }
          },
          offset: const Offset(0, 50),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black12,
            backgroundImage: _img.isNotEmpty ? NetworkImage(_img) : null,
            // child: Icon(Icons.person),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: text("Profile"),
              value: 1,
            ),

// not yet implemented
            // PopupMenuItem(
            //   child: text("Delete Wallet"),
            //   value: 1,
            // ),
            // PopupMenuItem(
            //   child: text("Hold/Onhold Funds"),
            //   value: 2,
            // ),
            // PopupMenuItem(
            //   child: text("Add/Delete Limit"),
            //   value: 3,
            // ),
            PopupMenuItem(
              child: text("Logout"),
              value: 3,
            ),
          ],
        ),
      )
    ],
  );
}

AppBar otherAppBar(text, context) {
  return AppBar(
    elevation: 0.5,
    shadowColor: Colors.grey[300],
    backgroundColor: Colors.white,
    // centerTitle: true,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Color(0xff22277a),
        size: 30,
      ),
    ),
    title: blackMiddiumText(text),
  );
}

AppBar pageAppBar(text, context) {
  return AppBar(
    elevation: 0.5,
    shadowColor: Colors.grey[300],
    backgroundColor: Colors.white,
    title: blackMiddiumText(text),
  );
}
