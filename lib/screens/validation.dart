import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/models/validationmodels/validationclass.dart';
import 'package:guavapay/pages/loading.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/color.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utilities/appbar.dart';
import '../utilities/sharedprefernce.dart';
import '../utilities/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class Validate extends StatefulWidget {
  var idname, isback, nation, wallet;

  Validate(this.wallet, this.isback, this.nation, this.idname, {Key? key})
      : super(key: key);

  @override
  State<Validate> createState() => _ValidateState();
}

class _ValidateState extends State<Validate> {
  final cloudinary = CloudinaryPublic('codeplus', 'tjlennli', cache: false);
  File? face;
  File? front;
  File? back;

  String? frontmime;
  String? facemime;
  String? backmime;

  String? frontbyte;
  String? facebyte;
  String? backbyte;
  String _dp = "";
  File? img;

  bool _isLoading = false;

  Future getFile(docType) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (img == null) return;

      final tmpImg = File(img.path);

      setState(() {
        this.img = tmpImg;

        if (docType == "face") {
          this.face = tmpImg;
          facemime = lookupMimeType(face!.path);
          facebyte = base64Encode(face!.readAsBytesSync());
        } else if (docType == "front") {
          this.front = tmpImg;
          frontmime = lookupMimeType(front!.path);
          frontbyte = base64Encode(front!.readAsBytesSync());
        } else {
          this.back = tmpImg;
          backmime = lookupMimeType(back!.path);
          backbyte = base64Encode(back!.readAsBytesSync());
        }
      });

      // print(tmpImg);
    } on PlatformException catch (e) {
      rethrow;
    }
  }

// ######################## WHERE THE MAGIC HAPPENS ###############################
  Future onSubmit() async {
    var uid = (Uuid().v4());
    var refId = ("success$uid").split("-")[0];

// ############################### is empty images ###################################
    if (face == null || front == null) {
      overlayError("Take picture of face and document");
      return null;
    }
    _state(true);

// ###################### UPLOAD FACE IMAGE TO CLOUDINARY #############################

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(face!.path,
            resourceType: CloudinaryResourceType.Image),
      );
      setState(() {
        _dp = response.secureUrl;
      });
    } on CloudinaryException catch (e) {
      _state(false);
      overlayError(e.request.toString());
      return null;
    }

// ############################# upload images to rapy database ###########################
    await verification(widget.nation, widget.idname, widget.wallet, facebyte,
            frontbyte, backbyte, frontmime, refId)
        .then((value) async {
      // print(value.status.message);

// ############################# upload dp to our database ###########################
      await updateUsers(widget.wallet, _dp).then((value) async {
        overlaySuccess("Account Verification Successful!!!!!!!!!!!!");
        await savedata(widget.wallet);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Loading(widget.wallet)));
        _state(false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Verify Wallet", context),
      body: Theme(
        data: themedata,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: 10),
              width: MediaQuery.of(context).size.width,
              // color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        image: face == null
                            ? null
                            : DecorationImage(
                                image: FileImage(
                                  File(
                                    face!.path,
                                  ),
                                ),
                                fit: BoxFit.fitWidth),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              smallText("Frontal Face Image"),
                              Expanded(child: Container()),
                              const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.photo_camera_outlined),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () => getFile("face"),
                  ),
                  const SizedBox(height: 10),
                  smallText("Upload Document"),
// ##################################################
                  widget.isback
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2.4,
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  image: front == null
                                      ? null
                                      : DecorationImage(
                                          image: FileImage(
                                            File(
                                              front!.path,
                                            ),
                                          ),
                                          fit: BoxFit.fitWidth),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    smallText("Front"),
                                    Expanded(child: Container()),
                                    const CircleAvatar(
                                      radius: 20,
                                      child: Icon(Icons.photo_camera_outlined),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () => getFile("front"),
                            ),

                            // #############################################################
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2.4,
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  image: back == null
                                      ? null
                                      : DecorationImage(
                                          image: FileImage(
                                            File(
                                              back!.path,
                                            ),
                                          ),
                                          fit: BoxFit.fitWidth),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    smallText("Back"),
                                    Expanded(child: Container()),
                                    const CircleAvatar(
                                      radius: 20,
                                      child: Icon(Icons.photo_camera_outlined),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () => getFile("back"),
                            ),
                          ],
                        )
                      :
// ####################################################
                      InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4.5,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              image: front == null
                                  ? null
                                  : DecorationImage(
                                      image: FileImage(
                                        File(
                                          front!.path,
                                        ),
                                      ),
                                      fit: BoxFit.fitWidth),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                smallText("Front"),
                                Expanded(child: Container()),
                                const CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.photo_camera_outlined),
                                )
                              ],
                            ),
                          ),
                          onTap: () => getFile("front"),
                        ),

// ####################################################
                  const SizedBox(height: 20),
                  !_isLoading
                      ? SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: pcolor, // Background color
                              onPrimary:
                                  Colors.white, // Text Color (Foreground color)
                            ), // style: const ButtonStyle(backgroundColor: Color.fromRGBO(77, 99, 8, opacity)),
                            onPressed: () => onSubmit(),
                            child: whitesmallText(
                              "Verify",
                            ),
                          ),
                        )
                      : const SpinKitWave(
                          size: 30,
                          color: Colors.grey,
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
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
