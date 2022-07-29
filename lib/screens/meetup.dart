import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guavapay/models/meetup/getpost.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';
import '../utilities/sharedprefernce.dart';

class Meetup extends StatefulWidget {
  Meetup({Key? key}) : super(key: key);

  @override
  State<Meetup> createState() => _MeetupState();
}

class _MeetupState extends State<Meetup> {
  final _message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var _text;
  var myWalletId = "";

  @override
  void initState() {
    loadchat();
    if (_scrollController.hasClients) {
      // WidgetsBinding.instance?.addPostFrameCallback((_) {
      //   //code will run when widget rendering complete
      //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // });
    }

    loaddata().then((value) {
      setState(() {
        myWalletId = value.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: pageAppBar("Meet-up", context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<Meetupclass>(
                      stream: streammeeting(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data!.data.length,
                            itemBuilder: (contect, i) {
                              var content = snapshot.data!.data;
                              // print(myWalletId);
                              if (content[i].eWallet == myWalletId) {
                                return Container(
                                  color:
                                      const Color.fromARGB(255, 255, 250, 232)
                                          .withOpacity(0.5),
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 25),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          smallText(content[i].name,
                                              color: Colors.black54),
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors
                                                .primaries[Random().nextInt(
                                                    Colors.primaries.length)]
                                                .withOpacity(0.5),
                                            child: whitesmallText(
                                                content[i].country,
                                                size: 20),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      title(content[i].message),
                                      const SizedBox(height: 10),
                                      text(content[i].date, color: pcolor)
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  color:
                                      const Color.fromARGB(255, 247, 236, 248)
                                          .withOpacity(0.5),
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 25),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors
                                                .primaries[Random().nextInt(
                                                    Colors.primaries.length)]
                                                .withOpacity(0.5),
                                            child: whitesmallText(
                                                content[i].country,
                                                size: 20),
                                          ),
                                          smallText(content[i].name,
                                              color: Colors.black54)
                                        ],
                                      ),
                                      const Divider(),
                                      title(content[i].message),
                                      const SizedBox(height: 10),
                                      text(content[i].date, color: pcolor)
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        } else if (snapshot.hasError) {
                          return text("error");
                        } else {
                          return text("none");
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: inputFeild("Enter Message", "", _message,
                            lineheight: 1),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_message.text.isEmpty) {
                            return;
                          }
                          setState(() {
                            _text = _message.text;
                          });
                          _message.clear();
                          await sendpost(
                            myWalletId,
                            _text,
                            chatid![0],
                            chatid![1],
                            DateTime.now().toString(),
                          );
                        },
                        icon: Icon(
                          Icons.send,
                          color: pcolor,
                        ),
                      )
                    ],
                  )
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
