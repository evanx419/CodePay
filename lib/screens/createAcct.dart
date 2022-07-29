import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/createVAmodel.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';
import 'package:uuid/uuid.dart';
import '../models/validationmodels/countries.dart';
import '../pages/error.dart';
import '../utilities/appText.dart';

class CreateUserAccout extends StatefulWidget {
  var wallet;
  CreateUserAccout(this.wallet, {Key? key}) : super(key: key);

  @override
  State<CreateUserAccout> createState() => _CreateUserAccoutState();
}

class _CreateUserAccoutState extends State<CreateUserAccout> {
  final _description = TextEditingController();
  var _sign, _code, _name, _country;
  var currencyvalue;
  String? countryShort;
  bool _isLoading = false;

  List<String> countrylist = [];
  List<String> currencylist = [];

  String? selectedcurrency;
  String? selectedcountry;

  onSubmit() async {
    if (selectedcurrency == null || selectedcountry == null) {
      overlayError("Empty fields");
      _state(false);
      return null;
    }
    // print(_sign);

    var uid = (Uuid().v4());
    var id = ("${uid.split("-")[0]}discription");
    String wallet = widget.wallet;

    _state(true);
    await createvAccount(
      selectedcurrency.toString(),
      _country.toString(),
      _description.text.toString(),
      wallet,
      id.toString(),
    )
        .timeout(const Duration(seconds: 30),
            onTimeout: () => callTimeOut(context))
        .then((v) {
      overlaySuccess("Account Created Successfully!!!!!!!!!!!!");
      Navigator.of(context).pop();
      _state(true);
    });

    _state(true);
  }

  @override
  void initState() {
    super.initState();
    getcountry();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Create Account", context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  menuMaxHeight: 400,
                  value: selectedcountry,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Select Country",
                  ),
                  items: countrylist.map((stateList) {
                    return DropdownMenuItem<String>(
                      value: stateList,
                      child: Text(stateList),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedcurrency = null;

                    setState(() {
                      // localGovtList = [];
                      selectedcountry = newValue.toString();
                      getcurrency(newValue.toString());
                      var i = countryName.indexOf(selectedcountry!);

                      _country = countryiso[i];
                      _code = currencycode[i];
                      _sign = currencysign[i];
                      _name = currencyname[i];
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  menuMaxHeight: 400,
                  value: selectedcurrency,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Select Currency",
                  ),
                  items: currencylist.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (setValue) {
                    setState(() {
                      selectedcurrency = setValue.toString();
                    });
                    // getStates();
                  },
                ),
// ################################################

                const SizedBox(height: 10),
                inputFeild("Description", "", _description),
                const SizedBox(height: 20),
                !_isLoading
                    ? SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: pcolor,
                            onPrimary:
                                Colors.white, // Text Color (Foreground color)
                          ), // style: const ButtonStyle(backgroundColor: Color.fromRGBO(77, 99, 8, opacity)),
                          onPressed: _isLoading ? null : () => onSubmit(),
                          child: whitesmallText(
                            "Submit",
                          ),
                        ),
                      )
                    : const SpinKitWave(
                        color: Colors.grey,
                        size: 35,
                      ),
                const SizedBox(height: 10),
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
        countrylist.add(k);
      });
    });
  }

  getcurrency(String selected) {
    currencylist = [];
    basecountries.forEach((k, v) {
      if (k == selected) {
        setState(() {
          currencylist = v;
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
