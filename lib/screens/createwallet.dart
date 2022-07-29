import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/validationmodels/countries.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/models/walletModel.dart';
import 'package:guavapay/pages/error.dart';
import 'package:guavapay/screens/validation.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/validationmodels/identityDocuments.dart';
import '../utilities/variables.dart';

class Createwallet extends StatefulWidget {
  const Createwallet({Key? key}) : super(key: key);

  @override
  State<Createwallet> createState() => _CreatewalletState();
}

class _CreatewalletState extends State<Createwallet> {
  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: 'ACa4f2b780aaa07e8c5e70f8903e5c50ca',
      authToken: '45f8ada92e656880b601a4c8005b2807',
      twilioNumber: '+19705405230');

  late String refid;
  late String country;
  String? currentIdtype;
  bool? isBack;
  String? idname;
  late String nation;

  List<String> newDoc = [];
  bool _isLoading = false;
  String type = "person";
  String contacttype = "personal";
  List registered = [];
  int currentStep = 0;

  var fname = TextEditingController(),
      lname = TextEditingController(),
      phone = TextEditingController(),
      city = TextEditingController();
  var state = TextEditingController(),
      dd = TextEditingController(),
      mm = TextEditingController(),
      yy = TextEditingController(),
      address = TextEditingController(),
      zip = TextEditingController();
  var email = TextEditingController(),
      canton = TextEditingController(),
      ditrict = TextEditingController(),
      mothers = TextEditingController(),
      idNo = TextEditingController(),
      pin = TextEditingController(),
      pin2 = TextEditingController();

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: text("Personal Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              inputFeild("First Name", "", fname),
              const SizedBox(height: 10),
              inputFeild("Last Name", "", lname),
              const SizedBox(height: 10),
              inputFeild("Email", "", email),
              const SizedBox(height: 10),
              inputFeild("Phone Number", "Hint: +2348189765432", phone,
                  keyboard: TextInputType.phone),
              const SizedBox(height: 10),

              smallText("Date of Birth"),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: inputFeild("Day", "dd", dd,
                        keyboard: TextInputType.datetime),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: inputFeild("Month", "mm", mm,
                        keyboard: TextInputType.datetime),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: inputFeild("Year", "yyyy", yy,
                        keyboard: TextInputType.datetime),
                  ),
                ],
              ),

              const SizedBox(height: 5),

// #################################################
            ],
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: text("Address Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              smallText("Country"),
              Autocomplete(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    return countryName
                        .where((element) =>
                            element.toLowerCase().contains(value.text))
                        .toList();
                  }
                },
                onSelected: (String value) => setState(
                  () {
                    var i = countryName.indexOf(value);

                    country = countryiso[i];
                    // print(country);
                  },
                ),
              ),
              const SizedBox(height: 10),
              inputFeild("Home Address", "", address),
              const SizedBox(height: 10),
              inputFeild("State", "", state),
              const SizedBox(height: 10),
              inputFeild("City", "", city),
              const SizedBox(height: 10),
              inputFeild("Zip Code", "", zip, keyboard: TextInputType.number),
              const SizedBox(height: 10),
              inputFeild("Canton", "", canton),
              const SizedBox(height: 10),
              inputFeild("District", "", ditrict),
            ],
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: text("Others Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              smallText("Nationality"),
              const SizedBox(height: 5),
              Autocomplete(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    return countryName
                        .where((element) =>
                            element.toLowerCase().contains(value.text))
                        .toList();
                  }
                },
                onSelected: (String value) async {
                  setState(() {
                    var i = countryName.indexOf(value);
                    nation = countryiso[i];
                    currentIdtype = null;
                  });

                  await getDocuments(country).then((v) {
                    setState(() {
                      newDoc = documentName;
                    });
                  });
                },
              ),

              // ################################
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                hint: text("Identification_type"),
                value: currentIdtype,
                items: newDoc.map(
                  (value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (setValue) => setState(
                  () {
                    currentIdtype = setValue.toString();
                    var i = documentName.indexOf(setValue!);
                    // isBack = documentBack[i];
                    idname = documentType[i];
                    isBack = documentBack[i];
                    // print("$isBack $idname");
                  },
                ),
              ),

              const SizedBox(height: 10),

              inputFeild("Identification_number", "", idNo,
                  keyboard: TextInputType.number),
              const SizedBox(height: 10),

              inputFeild("Enter Mother's Name", "", mothers),
              const SizedBox(height: 10),

              const SizedBox(height: 30),
// #############################################
              text(
                "This Pin would be requied to login and confirm transactions",
              ),
              const SizedBox(height: 10),
              inputFeild("Enter 4 digit PIN", "", pin, obsc: true),
              const SizedBox(height: 10),
              inputFeild("Confirm Pin", "", pin2, obsc: true),
            ],
          ),
        )
      ];

  Future onSubmit() async {
// ########################## if not emplty feilds & pin ###############################
    if (pin.text != pin2.text) {
      overlayError("incorrect pin");
      _state(false);
      return null;
    }
    if (lname.text.isEmpty &&
        email.text.isEmpty &&
        fname.text.isEmpty &&
        phone.text.isEmpty &&
        city.text.isEmpty &&
        state.text.isEmpty &&
        mm.text.isEmpty &&
        dd.text == null &&
        yy.text.isEmpty &&
        idNo.text.isEmpty &&
        idname == null &&
        nation.isEmpty &&
        address.text.isEmpty &&
        zip.text.isEmpty &&
        country.isEmpty &&
        mothers.text.isEmpty &&
        pin.text.isEmpty) {
// ################################### enter complusory feilds found empty ############################
      overlayError("Empty feilds");
      _state(false);
      return null;
    }
    _state(true);
//############################# check if user register already ##################################
    await getUsers()
        .timeout(const Duration(seconds: 60),
            onTimeout: () => callTimeOut(context))
        .then((value) async {
      // print(value.data[0]);
      value.data.forEach((e) {
        registered.add(e.email);
      });

//######################################### check if user already registered ########################
      if (registered.contains(email.text)) {
        overlayError("User already exit with the Email,");
        _state(false);
        return null;
      }
// print("${mm.text}/${dd.text}/${yy.text}");
// ########################## create wallet ########################################
      await cWallet(
              fname.text,
              lname.text,
              refid,
              type,
              phone.text,
              email.text.trim(),
              mothers.text,
              address.text,
              city.text,
              state.text,
              country,
              zip.text,
              "${mm.text}/${dd.text}/${yy.text}",
              nation,
              idname,
              idNo.text,
              contacttype)
          .timeout(const Duration(seconds: 60),
              onTimeout: () => callTimeOut(context))
          .then((response) async {
// display error message
        if (response.status.message.isNotEmpty) {
          overlayError(response.status.errorCode.toString());
          _state(false);
          return null;
        }

// ########################## move date to user db ########################
        await postUsers(email.text, response.data.id, refid, "", pin.text)
            .timeout(const Duration(seconds: 60),
                onTimeout: () => callTimeOut(context))
            .then(
          (v) async {
            await twilioFlutter.sendSMS(
                // toNumber: phone.text,
                toNumber: "+2349163469426", //this is a free twilio account
                messageBody:
                    "Account Creation successful, your eWallet id is ${response.data.id}");
            overlaySuccess("registration successful!!!!!!!!!!!!!!!!!!!!!");
            _state(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Validate(response.data.id, isBack, nation, idname),
              ),
            );
            _state(false);
          },
        );
      });
    });

    setState(() {
      registered = [];
    });
  }

  @override
  void initState() {
    super.initState();
    getCountries().then((value) {
      // print("done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: blackMiddiumText("Create Wallet"),
      ),
      body: SafeArea(
        child: Stepper(
          currentStep: currentStep,
          type: StepperType.vertical,
          onStepTapped: (step) => setState(() => currentStep = step),
          steps: getSteps(),
          controlsBuilder: (context, details) {
            return Container(
              margin: const EdgeInsets.only(top: 15),
              child: !_isLoading
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: currentStep == 0
                                ? null
                                : () => setState(() => currentStep -= 1),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: currentStep == (getSteps().length - 1)
                                ? () {
                                    refid = Uuid().v4();
                                    onSubmit();
                                    // print(ref_id);
                                  }
                                : () => setState(() => currentStep += 1),
                            child: currentStep == (getSteps().length - 1)
                                ? const Text("Submit")
                                : const Text("Next"),
                          ),
                        )
                      ],
                    )
                  : const SpinKitWave(
                      size: 20,
                      color: Colors.grey,
                    ),
            );
          },
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


// _isLoading
//                     ? const Center(
//                         child: SpinKitWave(
//                         size: 25,
//                         color: Colors.grey,
//                       ))
//                     : Container(),