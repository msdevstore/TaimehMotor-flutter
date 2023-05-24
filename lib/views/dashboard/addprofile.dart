import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:uuid/uuid.dart';

class AddProfile extends StatefulWidget {
  @override
  State<AddProfile> createState() => _AddProfileState();
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class _AddProfileState extends State<AddProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController thirdNameController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String userId = '';
  String displayName = '';
  String photoURL = '';
  bool loading = true;
  String featuredImage = '';
  String idFrontImage = '';
  String idBackImage = '';
  late SharedPreferences preferences;

  AddProfile(userId, fname, secondName, thirdName, lastName, dateBirth, email,
      nationalNumber, phoneNumber, address) async {
    late final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('uid')!;
    displayName = prefs.getString('displayName')!;
    photoURL = prefs.getString('photoURL')!;
    final storageRef = FirebaseStorage.instance.ref();
    var imgUrl = '';
    var idFront = '';
    var idBack = '';
    var uuid = const Uuid();
    var uuidIdFront = const Uuid();
    var uuidIDBack = const Uuid();
    final avatarImgRef = storageRef.child("avatar/${uuid.v1()}.jpg");
    final idFrontRef = storageRef.child("ID/${uuidIdFront.v1()}.jpg");
    final idBackRef = storageRef.child("ID/${uuidIDBack.v1()}.jpg");

    if (_imageFile == null && featuredImage.isEmpty) {
      Fluttertoast.showToast(msg: "You must select the photo.");
      return;
    }
    if (_idFrontFile == null && idFrontImage.isEmpty) {
      Fluttertoast.showToast(msg: "You must select the ID Front Image.");
      return;
    }
    if (_idBackFile == null && idBackImage.isEmpty) {
      Fluttertoast.showToast(msg: "You must select the ID Back Image.");
      return;
    }

    File file = File(_imageFile?.path ?? '');
    File idFrontFile = File(_idFrontFile?.path ?? '');
    File idBackFile = File(_idBackFile?.path ?? '');

    try {
      if (_imageFile != null) {
        await avatarImgRef.putFile(file);
        imgUrl = await avatarImgRef.getDownloadURL();
        prefs.setString('imgUrl', imgUrl);
      } else {
        imgUrl = featuredImage;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Uploading Failure!");
    }

    try {
      if (_idFrontFile != null) {
        print(idFrontFile);
        await idFrontRef.putFile(idFrontFile);
        idFront = await idFrontRef.getDownloadURL();
      } else {
        idFront = idFrontImage;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Uploading Failure1!");
      return;
    }

    try {
      if (_idBackFile != null) {
        await idBackRef.putFile(idBackFile);
        idBack = await idBackRef.getDownloadURL();
      } else {
        idBack = idBackImage;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Uploading Failure2!");
      return;
    }

    if (fname.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Name field");
      return;
    }
    if (secondName.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Second Name field");
      return;
    }
    if (thirdName.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Third Name field");
      return;
    }
    if (lastName.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Last Name field");
      return;
    }
    if (dateBirth.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Date of Birth field");
      return;
    }
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Email field");
      return;
    }
    if (nationalNumber.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter National Number field");
      return;
    }
    if (phoneNumber.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Phone Number field");
      return;
    }
    if (address.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Address field");
      return;
    }

    await users.doc(userId).set({
      'userId': userId,
      'name': fname,
      'secondName': secondName,
      'thirdName': thirdName,
      'lastName': lastName,
      'dateBirth': dateBirth,
      'email': email,
      'nationalNumber': nationalNumber,
      'phoneNumber': phoneNumber,
      'address': address,
      'idFront': idBack,
      'idBack': idFront,
      'featuredImage': imgUrl,
      'displayName': displayName,
      'photoURL': photoURL
    }).then((value) => {
          Navigator.pushNamedAndRemoveUntil(
              context, '/DashBoard', (route) => true),
          Fluttertoast.showToast(
              msg: "User Information is submitted successfully!"),
        });
  }

  String? _retrieveDataError;
  XFile? _imageFile;
  XFile? _idFrontFile;
  XFile? _idBackFile;
  bool imgSelected = false;
  bool idFrontSelected = false;
  bool idBackSelected = false;

  void _setImageFileListFromFile(XFile? value) {
    print(_imageFile?.path);
    _imageFile = value;
  }

  void _setIdFrontFileListFromFile(XFile? value) {
    print(_idFrontFile?.path);
    _idFrontFile = value;
  }

  void _setIdBackFileListFromFile(XFile? value) {
    print(_idBackFile?.path);
    _idBackFile = value;
  }

  dynamic _pickImageError;
  dynamic _pickIdBackError;
  dynamic _pickIdFrontError;

  final ImagePicker _picker = ImagePicker();
  final ImagePicker _idBackPicker = ImagePicker();
  final ImagePicker _idFrontPicker = ImagePicker();

  double progress = 0;
  @override
  void initState() {}

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null || featuredImage.isNotEmpty) {
      if (_imageFile != null) {
        return kIsWeb
            ? Image.network(
                _imageFile!.path,
                fit: BoxFit.fill,
              )
            : Image.file(
                File(
                  _imageFile!.path,
                ),
                fit: BoxFit.fill,
              );
      } else {
        return Image.network(featuredImage, fit: BoxFit.fill);
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      imgSelected = false;
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewIdFront() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_idFrontFile != null || idFrontImage.isNotEmpty) {
      if (_idFrontFile != null) {
        return kIsWeb
            ? Image.network(
                _idFrontFile!.path,
                fit: BoxFit.fill,
              )
            : Image.file(
                File(
                  _idFrontFile!.path,
                ),
                fit: BoxFit.fill,
              );
      } else {
        return Image.network(idFrontImage, fit: BoxFit.fill);
      }
    } else if (_pickIdFrontError != null) {
      return Text(
        'Pick image error: $_pickIdFrontError',
        textAlign: TextAlign.center,
      );
    } else {
      idFrontSelected = false;
      return const Text(
        'You have not yet picked an IDCard Front Face.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewIdBack() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_idBackFile != null || idBackImage.isNotEmpty) {
      if (_idBackFile != null) {
        return kIsWeb
            ? Image.network(
                _idBackFile!.path,
                fit: BoxFit.fill,
              )
            : Image.file(
                File(
                  _idBackFile!.path,
                ),
                fit: BoxFit.fill,
              );
      } else {
        return Image.network(idBackImage, fit: BoxFit.fill);
      }
    } else if (_pickIdBackError != null) {
      return Text(
        'Pick image error: $_pickIdBackError',
        textAlign: TextAlign.center,
      );
    } else {
      idBackSelected = false;
      return const Text(
        'You have not yet picked an ID card Back Face.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFile = response.file;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<void> retrieveLostFrontData() async {
    final LostDataResponse response = await _idFrontPicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setIdFrontFileListFromFile(response.file);
        } else {
          _idFrontFile = response.file;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<void> retrieveLostBackData() async {
    final LostDataResponse response = await _idBackPicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setIdBackFileListFromFile(response.file);
        } else {
          _idBackFile = response.file;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    onPick(450, 450, 60);
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Future<void> _onFrontButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _idFrontPicker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _setIdFrontFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickIdFrontError = e;
        });
      }
    });
  }

  Future<void> _onBackButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _idBackPicker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _setIdBackFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickIdBackError = e;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.maxFinite,
              child: Row(),
            ),
            Positioned(
              left: 1,
              child: Row(
                children: [
                  const SizedBox(
                    width: 17.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/east.svg',
                      width: 20,
                      color: const Color(0xff3F3F3F),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  const Text(
                    "Complete your profile",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF33343C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.8,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: FutureBuilder(builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            loading == true) {
          return Center(
              child: Column(
            children: const [
              Text("Loading..."),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(),
            ],
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(width: 2, color: Colors.black)),
                        child: !kIsWeb &&
                                defaultTargetPlatform == TargetPlatform.android
                            ? FutureBuilder<void>(
                                future: retrieveLostData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot_img) {
                                  switch (snapshot_img.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      imgSelected = false;
                                      return const Text(
                                        'You have not yet picked an image.',
                                        textAlign: TextAlign.center,
                                      );
                                    case ConnectionState.done:
                                      imgSelected = true;
                                      return _previewImages();
                                    default:
                                      imgSelected = false;
                                      return const Text(
                                        'Please select a photo',
                                        textAlign: TextAlign.center,
                                      );
                                  }
                                },
                              )
                            : _previewImages(),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(top: 120),
                        padding: const EdgeInsets.all(10.0),
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            _onImageButtonPressed(ImageSource.gallery,
                                context: context);
                          },
                          tooltip: 'Select an Image',
                          child: const Icon(Icons.upload),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            child: !kIsWeb &&
                                    defaultTargetPlatform ==
                                        TargetPlatform.android
                                ? FutureBuilder<void>(
                                    future: retrieveLostData(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<void> snapshot_img) {
                                      switch (snapshot_img.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          idFrontSelected = false;
                                          return const Text(
                                            'You have not yet picked an image.',
                                            textAlign: TextAlign.center,
                                          );
                                        case ConnectionState.done:
                                          idFrontSelected = true;
                                          return _previewIdFront();
                                        default:
                                          idFrontSelected = false;
                                          return const Text(
                                            'Please select a photo',
                                            textAlign: TextAlign.center,
                                          );
                                      }
                                    },
                                  )
                                : _previewIdFront(),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 60,
                            margin: const EdgeInsets.only(top: 80),
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: Colors.orange,
                              onPressed: () {
                                _onFrontButtonPressed(ImageSource.gallery,
                                    context: context);
                              },
                              tooltip: 'Select an Image',
                              child: const Icon(Icons.upload),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            child: !kIsWeb &&
                                    defaultTargetPlatform ==
                                        TargetPlatform.android
                                ? FutureBuilder<void>(
                                    future: retrieveLostData(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<void> snapshot_img) {
                                      switch (snapshot_img.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          idBackSelected = false;
                                          return const Text(
                                            'You have not yet picked an image.',
                                            textAlign: TextAlign.center,
                                          );
                                        case ConnectionState.done:
                                          idBackSelected = true;
                                          return _previewIdBack();
                                        default:
                                          idBackSelected = false;
                                          return const Text(
                                            'Please select a photo',
                                            textAlign: TextAlign.center,
                                          );
                                      }
                                    },
                                  )
                                : _previewIdBack(),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 60,
                            margin: const EdgeInsets.only(top: 80),
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: Colors.orange,
                              onPressed: () {
                                _onBackButtonPressed(ImageSource.gallery,
                                    context: context);
                              },
                              tooltip: 'Select an Image',
                              child: const Icon(Icons.upload),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Name',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: 'Bella',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Second Name',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: secondNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: 'Mustache',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Third Name',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: thirdNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: 'Mustache',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Last Name',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: 'Alex',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: dateBirthController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: '2000-01-01',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Email',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: 'example@example.com',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'National Number',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: nationalNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: '1234567',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText: '+1234567890',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Address',
                    style: TextStyle(
                        color: Color(0xFF33343C),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Color(0xFF444444)),
                        hintText:
                            'Suzy Queue. 4455 Landing Lange, APT 4. Louisville, KY 40018-1234',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                    onTap: () {
                      AddProfile(
                        userId,
                        nameController.text,
                        secondNameController.text,
                        thirdNameController.text,
                        lastNameController.text,
                        dateBirthController.text,
                        emailController.text,
                        nationalNumberController.text,
                        phoneNumberController.text,
                        addressController.text,
                      );
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        'Submit Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
