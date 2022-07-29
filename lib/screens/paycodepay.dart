// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:guavapay/models/businessmodel/payoutclass.dart';
// import 'package:guavapay/models/payout/setResponse.dart';
// import 'package:guavapay/models/userbdmodel/userdb.dart';
// import '../models/businessmodel/loadbusiness.dart';
// import '../models/businessmodel/pay.dart';
// import '../models/payout/createPayout.dart';
// import '../models/validationmodels/countries.dart';
// import '../models/walletModel.dart';
// import '../utilities/appText.dart';
// import '../utilities/appbar.dart';
// import '../utilities/variables.dart';
// import 'package:intl/intl.dart';

// class BusinessTransactions extends StatefulWidget {
//   var id, path;
//   var _wallet;

//   BusinessTransactions(this.path, this.id, this._wallet, {Key? key})
//       : super(key: key);

//   @override
//   State<BusinessTransactions> createState() => _BusinessTransactionsState();
// }

// class _BusinessTransactionsState extends State<BusinessTransactions> {
//   final _money = TextEditingController();
//   final _pwd = TextEditingController();
//   String? _name, _amount, _payoutcurrency, _method, _country;
//   String? _benecountry, _wallet, _mydata, _status, _mycountry;

//   var formatCurrency = NumberFormat.simpleCurrency(name: "USD");

//   bool _isLoading = false;
//   bool _isMe = false;
//   bool _pwdcheck = false;
//   String? _selectedcurrency;
//   var _total;
//   var _id;

//   double _payamount = 0;
//   List _senderdata = [];
//   List _postuserwallet = [];
//   List _postusermywallet = [];

//   int _count = 1;
//   int _loop = 0;
//   double? _rate;

//   int? _pos = 0;
//   var _remainder = 0.0;

// // @@@@@@@@@@@@@@@@@@@@@@@@@@@ On submit @@@@@@@@@@@@@@@@@@@@@@

//   _onSubmit() async {
//     // print(_pos);

//     DateTime _now = DateTime.now();
//     String _date = _now.toString();

// // ######################### set total to amount #########################

//     setState(() {
//       _total = _money.text;
//     });

// // ############################# if empty amount  ############################
//     if (_total!.isEmpty) {
//       setState(() {
//         _total = _payamount.toString();
//       });
//     }

//     _state(true);

// // ######################## get balance in dollar ####################

//     var _balance = (_payamount - double.parse(_total!)) / _rate!;

// // ################### Check over payment #############################

//     if (_balance.isNegative) {
//       overlayError("Check amount");
//       // print("check amount");
//       _state(false);

//       return null;
//     }

// // ################## unpack my data ################################
//     List _listdata =
//         _mydata!.replaceAll("[", "").replaceAll("]", "").split(",");

// // #############   WHERE THE MAGIC HAPPENS    ######################

//     // print(_payamount);
//     // print(_balance);

//     await createPayout(
//             _method,
//             widget._wallet,
//             _total,
//             _payoutcurrency,
//             _selectedcurrency,
//             _mycountry,
//             "individual",
//             "company",
//             _benecountry,
//             "${_listdata[2].toString().trim()} ${_listdata[1].toString().trim()}",
//             _listdata[0].toString().trim(),
//             _listdata[2].toString().trim(),
//             _listdata[1].toString().trim(),
//             "${_listdata[2].toString().trim()}.${_listdata[1].toString().trim()}",
//             _wallet,
//             _listdata[4].toString().trim(),
//             "bank")
//         .onError((error, stackTrace) => overlayError(error))
//         .then(
//       (v) async {
// // ##################### check if user already paid ###################

//         if (v["status"]["error_code"] != "") {
//           overlayError(v["status"]["error_code"].toString());
//           return;
//         }

//         await respondPayout(v["data"]["id"]).then((vl) {
//           print(vl);
//         });
// // ################ post on DB ########################
//         // print(widget.path.toString());
//         // print(bizlist);
// // ##################### check if user already paid ###################
//         if (bizlist.contains(widget.path.toString())) {
//           await deleteTransactons(
//                   widget._wallet.toString(), widget.path.toString())
//               .then((value) async {
//             print("1st deleting....................");

//             bizlist = [];
//             bizbal = [];
//             persons = [];
//             balcurrency = [];
//             await getuserpayout();

//             _userpos();
//             print(value);
//           });
//         } else {
// // ########################### if user hasn't paid before #####################################
//           await postuserpayout(
//                   widget._wallet,
//                   _wallet,
//                   _total.toString(),
//                   _balance.toString(),
//                   "",
//                   _selectedcurrency,
//                   _id.toString(),
//                   _count.toString())
//               .onError((error, stackTrace) => overlayError(error))
//               .then((result) async {
//             print("Uploading!!!!!!!!!!!!!!!!!");
//             bizlist = [];
//             bizbal = [];
//             persons = [];
//             balcurrency = [];

//             await getuserpayout().then((v) async {
//               _userpos();
//               print("Uploaded!!!!!!!!!!!!!!!!!");

// // ###############################if user pays off once#########################
//               print(v.data[_pos!].balance);
//               print(v.data[_pos!].balance.runtimeType);

//               if (v.data[_pos!].balance == "0.0") {
//                 await deleteTransactons(widget._wallet, widget.path.toString())
//                     .then((value) async {
//                   bizlist = [];
//                   bizbal = [];
//                   persons = [];
//                   balcurrency = [];
// // #################### Reload business list ########################
//                   await getuserpayout();
//                   _userpos();
//                   print("Deleted!!!!!!!!!!!!!!!!!!!");
//                 });
//               }
//             });
//           });
//         }
//       },
//     );

//     _state(false);
//   }

// // ###################### init ###########################

//   @override
//   void initState() {
//     super.initState();

//     _userpos();
//     // print(_pos);

//     rWallet(widget._wallet).then((v) async {
//       if (v.data.type == "person") {
//         _senderdata.add(v.data.email);
//         _senderdata.add(v.data.firstName);
//         _senderdata.add(v.data.lastName);
//         _senderdata.add(v.data.type);
//         _senderdata.add("1234567");
//       }

// // ################## IF BUSINESS HERE ###################
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: otherAppBar("Business Details", context),
//       body: SingleChildScrollView(
//         child: Theme(
//           data: themedata,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: FutureBuilder<BusinessClass>(
//               future: getbusiness(),
//               builder: (context, x) {
//                 if (x.hasData) {
//                   List l = x.data!.data[widget.id].senderCurrency
//                       .replaceAll("[", "")
//                       .replaceAll("]", "")
//                       .split(",");

//                   var _items = x.data!.data[widget.id];

//                   if (_loop < 1) {
//                     if (widget._wallet == _items.wallet) {
//                       _isMe = true;
//                     }

//                     _id = _items.id;
//                     _payamount = double.parse(_items.amount);

//                     if (bizlist.contains(widget.path.toString())) {
//                       _remainder = double.parse(bizbal[_pos!]);
//                       _payamount = double.parse(_remainder.abs().toString());
//                       // print(_
//                     }

//                     var i = currencies.indexOf(_items.payoutCurrency.trim());
//                     // var j = currencies.indexOf(_.trim());

//                     _rate = conversion[i];

//                     _payamount /= _rate!.toDouble();

//                     _rate = 1;
//                     _loop = 1;
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height / 3,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(_items.img),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       const Divider(),
//                       payText("Business Name:  ${_items.name}",
//                           color: Colors.black, size: 14),
//                       const Divider(),

//                       const SizedBox(height: 10),
//                       payText("Take-off  Date:  ${_items.date}",
//                           color: Colors.black, size: 14),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       payText("Beneficiary's Country:  ${_items.country}",
//                           color: Colors.black, size: 14),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       payText(
//                           "Beneficiary's Currency:  ${_items.payoutCurrency}",
//                           color: Colors.black,
//                           size: 14),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       payText(
//                           "Amount:  ${_items.amount}", // ########### Currency sign here
//                           color: Colors.black,
//                           size: 13),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       payText("eWallet Id:  ${_items.wallet}",
//                           color: Colors.black, size: 13),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       payText("Description:  ${_items.description}",
//                           color: Colors.black, size: 14),
//                       const Divider(),
//                       // const SizedBox(height: 10),
//                       !_isMe ? smallText("Country") : Container(),
//                       const SizedBox(height: 10),
//                       !_isMe
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width / 3,
//                                   child: Autocomplete(
//                                       optionsBuilder: (TextEditingValue value) {
//                                     if (value.text.isEmpty) {
//                                       return const Iterable<String>.empty();
//                                     } else {
//                                       return countryName
//                                           .where((element) => element
//                                               .toLowerCase()
//                                               .contains(value.text))
//                                           .toList();
//                                     }
//                                   }, onSelected: (String value) async {
//                                     setState(() {
//                                       var i = countryName.indexOf(value);
//                                       _mycountry = countryiso[i];
//                                     });
//                                   }),
//                                 ),
//                                 smallText("Seats:", color: Colors.black),
//                                 !bizlist.contains(widget.path.toString())
//                                     ? IconButton(
//                                         onPressed: () async {
//                                           setState(() {
//                                             if (_count != 1) {
//                                               _payamount /= _count;
//                                               _count -= 1;
//                                             }
//                                           });
//                                         },
//                                         icon: const Icon(
//                                             (FontAwesomeIcons.minus),
//                                             size: 20))
//                                     : Container(),
//                                 !bizlist.contains(widget.path.toString())
//                                     ? listtext(_count.toString())
//                                     : listtext(persons[_pos!]),
//                                 !bizlist.contains(widget.path.toString())
//                                     ? IconButton(
//                                         onPressed: () async {
//                                           setState(() {
//                                             _count += 1;
//                                             _payamount *= _count;
//                                           });
//                                           print(_pos);
//                                         },
//                                         icon: const Icon(
//                                           (FontAwesomeIcons.plus),
//                                           size: 20,
//                                         ),
//                                       )
//                                     : Container(),
//                               ],
//                             )
//                           : Container(),

//                       const SizedBox(height: 10),

// // ####################### CHECK IF ITS THE USER'S POST #################################

//                       !_isMe //################ check here
//                           ? Row(
//                               children: [
//                                 payText("Select Payment Currency",
//                                     color: Colors.black, size: 14),
//                                 Expanded(child: Container()),
//                                 whitesmallText(
//                                     formatCurrency.format(_payamount.floor()),
//                                     color: Colors.black)
//                               ],
//                             )
//                           : Container(),
//                       const SizedBox(height: 10),

//                       !_isMe
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                   SizedBox(
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     child: DropdownButtonFormField<String>(
//                                       isExpanded: true,
//                                       menuMaxHeight: 400,
//                                       value: _selectedcurrency,
//                                       decoration: const InputDecoration(
//                                         isDense: true,
//                                         hintText: "Currency",
//                                       ),
//                                       items: l.map((value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Text(value),
//                                         );
//                                       }).toList(),
//                                       onChanged: (setValue) {
//                                         setState(() {
//                                           _payamount =
//                                               _payamount / _rate!.toDouble();
//                                           // print(_rate);

//                                           _selectedcurrency =
//                                               setValue.toString();

//                                           var i = currencies.indexOf(
//                                               _selectedcurrency
//                                                   .toString()
//                                                   .trim());
//                                           _rate = conversion[i];
//                                           formatCurrency =
//                                               NumberFormat.simpleCurrency(
//                                                   name: _selectedcurrency);
//                                           // print(_rate);

//                                           _payamount =
//                                               _payamount * _rate!.toDouble();
//                                           // print(_payamount);
//                                         });
//                                         // getStates();
//                                       },
//                                     ),
//                                   ),
//                                   _pos == 0
//                                       ? SizedBox(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2.5,
//                                           child: inputFeild(
//                                             "Amount",
//                                             "",
//                                             _money,
//                                             keyboard: TextInputType.number,
//                                           ),
//                                         )
//                                       : Container()
//                                 ])
//                           : Container(),

//                       const SizedBox(height: 20),

//                       !_isMe
//                           ? SizedBox(
//                               child: !_isLoading
//                                   ? SizedBox(
//                                       height: 60,
//                                       child: MaterialButton(
//                                         color: Colors.black,
//                                         splashColor: Colors.white,
//                                         minWidth:
//                                             MediaQuery.of(context).size.width,
//                                         onPressed: () async {
// // ##################### Set state of some neccesary data ###############################

//                                           setState(() {
//                                             _name = _items.name;
//                                             _amount = _items.amount;
//                                             _payoutcurrency =
//                                                 _items.payoutCurrency;
//                                             _method = _items.method;
//                                             _country = _items.country;
//                                             _wallet = _items.wallet;
//                                             _mydata = _items.mydata;
//                                             _status = _items.status;
//                                             _benecountry = _items.country;
//                                           });

//                                           if (_selectedcurrency == null ||
//                                               countryiso.isEmpty) {
//                                             overlayError("Empty fields");
//                                             return;
//                                           }

//                                           await _auth();
//                                           //
//                                         },
//                                         child: whitesmallText("Pay Now"),
//                                       ),
//                                     )
//                                   : const SpinKitWave(
//                                       color: Colors.grey, size: 35),
//                             )
//                           : Container(),
//                     ],
//                   );
//                 } else {
//                   return const Center(
//                     child: SpinKitCircle(
//                       size: 50,
//                       color: Color.fromARGB(255, 114, 81, 79),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _auth() {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) => FractionallySizedBox(
//         heightFactor: 0.8,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               inputFeild("Enter Password", "", _pwd,
//                   obsc: true, keyboard: TextInputType.number),
//               RawMaterialButton(
//                 onPressed: _pwdcheck
//                     ? null
//                     : () async {
//                         if (_pwd.text.isEmpty) {
//                           print("Enter Account Password");
//                           return;
//                         }
//                         await getUsers().then((value) async {
//                           List<String> _pwdlist = [];
//                           List<String> _id = [];

//                           _pwdchecker(true);

//                           value.data.forEach((e) {
//                             _pwdlist.add(e.pwd.trim());
//                             _id.add(e.walletId.trim());
//                           });

//                           var pos = _id.indexOf(widget._wallet);

//                           if (_pwdlist[pos] == _pwd.text) {
// // ############# POst ###########################
//                             Navigator.of(context).pop();
//                             await _onSubmit();
//                             _pwdchecker(false);
//                           } else {
//                             overlayError("Incorrect Password");
//                             _pwdchecker(false);
//                             return null;
//                           }
//                         });
//                       },
//                 child: smallText("Proceed", color: Colors.white),
//                 fillColor: Colors.black,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _userpos() {
//     if (bizlist.contains(widget.path.toString())) {
//       setState(() {
//         print(bizlist);
//         _pos = bizlist.indexOf(widget.path.toString());
//       });
//     }
//   }

//   _state(val) {
//     return setState(() {
//       _isLoading = val;
//     });
//   }

//   _pwdchecker(val) {
//     return setState(() {
//       _pwdcheck = val;
//     });
//   }
// }
