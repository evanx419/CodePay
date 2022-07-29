import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/walletModel.dart';
import 'package:guavapay/screens/dashboard.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../models/businessmodel/loadbusiness.dart';
import '../models/validationmodels/countries.dart';

class RegsiterBusiness extends StatefulWidget {
  var _wallet;

  RegsiterBusiness(this._wallet, {Key? key}) : super(key: key);

  @override
  State<RegsiterBusiness> createState() => _RegsiterBusinessState();
}

class _RegsiterBusinessState extends State<RegsiterBusiness> {
  var _currency;
  var _country;

  List<String> _countrylist = [];
  List<String> _currencylist = [];

  String? _selectedcurrency = '';
  String? _selectedcountry;
  var _sign, _code, _name;
  DateTime? calender;
  DateTime date = DateTime.now();
  String? _mydata;

  bool _isLoading = false;
  final cloudinary = CloudinaryPublic('codeplus', 'tjlennli', cache: false);

  File? img;
  File? file;
  String logo = "";
  bool? _status = false;
  String currencydata = "";

  final _description = TextEditingController(),
      _businessname = TextEditingController(),
      _amount = TextEditingController(),
      _phone = TextEditingController();

  Future _getFile() async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (img == null) return;
      final tmpImg = File(img.path);

      setState(() {
        this.img = tmpImg;
        this.file = tmpImg;
      });
    } on PlatformException catch (e) {
      rethrow;
    }
  }

  _onSubmit() async {
    if (_description.text.isEmpty ||
        _businessname.text.isEmpty ||
        _amount.text.isEmpty ||
        file!.path.isEmpty) {
      overlayError("Empty feilds ");
      return null;
    }

    _state(true);
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file!.path,
            resourceType: CloudinaryResourceType.Image),
      );
      setState(() {
        logo = response.secureUrl;
      });
    } on CloudinaryException catch (e) {
      _state(false);

      return null;
    }

    uploadBuiness(
            _businessname.text,
            _description.text,
            _amount.text,
            _phone.text,
            _selectedcurrency,
            date.toString(),
            logo.toString(),
            widget._wallet,
            _status.toString())
        .onError((error, stackTrace) {
      errormsg();
      _state(false);
    }).then(
      (upload) async {
        overlaySuccess("Business Created Successgfully");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
            (route) => false);
      },
    );

// #####################
    _state(false);
  }

  @override
  void initState() {
    super.initState();

    getcountry();
    getCountries();
    rWallet(widget._wallet).then((v) async {
      setState(() {
        _mydata = v.data.email;
      });

// ################## IF BUSINESS HERE ###################
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Register a Business", context),
      body: SingleChildScrollView(
        child: Theme(
          data: themedata,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                inputFeild("Business Name", "", _businessname),
                const SizedBox(height: 10),
                inputFeild("Description", "", _description),
                const SizedBox(height: 10),
                inputFeild("Phone Number", "Hint: +2348189765432", _phone,
                    keyboard: TextInputType.phone),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        menuMaxHeight: 400,
                        value: _selectedcountry,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Select Country",
                        ),
                        items: _countrylist.map((stateList) {
                          return DropdownMenuItem<String>(
                            value: stateList,
                            child: Text(stateList),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          _selectedcurrency = null;

                          setState(() {
                            // localGovtList = [];
                            _selectedcountry = newValue.toString();
                            getcurrency(newValue.toString());
                            var i = countryName.indexOf(_selectedcountry!);

                            _country = countryiso[i];
                            _code = currencycode[i];
                            _sign = currencysign[i];
                            _name = currencyname[i];
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.4,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        menuMaxHeight: 400,
                        value: _selectedcurrency,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Select Currency",
                        ),
                        items: _currencylist.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (setValue) {
                          setState(() {
                            _selectedcurrency = setValue.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // _selectedcurrency == ''
                // ? redText("Enter Currency in USD")
                // : Container(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: inputFeild(
                        "Amount",
                        "",
                        _amount,
                        keyboard: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 245, 248),
                        border: Border.all(color: pcolor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: MaterialButton(
                        onPressed: () async {
                          calender = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: date,
                            lastDate: DateTime(2023),
                          );
                          if (calender == null) return;
                          setState(() {
                            date = calender!;
                          });
                        },
                        child: Row(
                          children: [
                            calender == null
                                ? title("pick date", color: pcolor)
                                : title(date.toString().substring(0, 11),
                                    color: pcolor),
                            Icon(
                              Icons.calendar_month_outlined,
                              color: pcolor,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      // width: 40,
                      child: MaterialButton(
                        onPressed: () => _getFile(),
                        child: Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              text("Upload Company Logo", color: Colors.black),
                              const SizedBox(width: 10),
                              const Icon(Icons.camera),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    text("Auto Respond", color: pcolor),
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: pcolor,
                      value: _status,
                      onChanged: (val) {
                        setState(() {
                          _status = val;
                        });
                        // print(_status);
                      },
                    )
                  ],
                ),
                logo.isNotEmpty
                    ? redText(img!.uri.toString(), color: pcolor)
                    : Container(),
                const SizedBox(height: 20),
                redText("5% Charges on Every Transactions"),
                const SizedBox(height: 5),
                !_isLoading
                    ? SizedBox(
                        height: 60,
                        child: MaterialButton(
                          color: pcolor,
                          splashColor: Colors.white,
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () async => await _onSubmit(),
                          child: whitesmallText("Register"),
                        ),
                      )
                    : const SpinKitWave(color: Colors.grey, size: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getcountry() {
    basecountries.forEach((k, v) {
      setState(() {
        _countrylist.add(k);
      });
    });
  }

  getcurrency(String selected) {
    _currencylist = [];
    basecountries.forEach((k, v) {
      if (k == selected) {
        setState(() {
          _currencylist = v;
        });
      }
    });
  }

  _state(val) {
    return setState(() {
      _isLoading = val;
    });
  }
}
