import 'package:arionmotor/views/mymotorcycles.dart';
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
import 'package:intl/intl.dart';

class Maintenance extends StatefulWidget {
  @override
  State<Maintenance> createState() => _MaintenanceState();
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class _MaintenanceState extends State<Maintenance> {
  late final SharedPreferences prefs;
  CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');

  String userId = '';
  bool loading = true;
  String paymentImage = '';
  String requestId = '';
  // prefs.getString('requestId');

  Maintenance() async {
    late final SharedPreferences prefs;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('uid')!;
    await requests.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        try {
          print("status:${doc['status']}");
          if (doc["status"] == 'Purchase Assigned' ||
              doc["status"] == 'Maintenanc Completed') {
            prefs.setString(
              'requestId', doc.id
            );
          }
          // ignore: empty_catches
        } catch (e) {}
      });
    });
    requestId = prefs.getString('requestId')!;
    final storageRef = FirebaseStorage.instance.ref();
    var imgUrl = '';
    var uuid = const Uuid();
    final avatarImgRef = storageRef.child("avatar/${uuid.v1()}.jpg");

    if (_imageFile == null && paymentImage.isEmpty) {
      Fluttertoast.showToast(msg: "You must select the photo.");
      return;
    }

    File file = File(_imageFile?.path ?? '');

    try {
      if (_imageFile != null) {
        await avatarImgRef.putFile(file);
        imgUrl = await avatarImgRef.getDownloadURL();
      } else {
        imgUrl = paymentImage;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Uploading Failure!");
    }

    await requests.doc(requestId).update({
      'paymentImage': imgUrl,
      'status': 'Maintenance Requested',
      'requested_date': formattedDate
    }).then((value) => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyMotorcycles()),
          ),
          Fluttertoast.showToast(
              msg: "Your request is submitted successfully!"),
        });
  }

  String? _retrieveDataError;
  XFile? _imageFile;
  bool imgSelected = false;

  void _setImageFileListFromFile(XFile? value) {
    print(_imageFile?.path);
    _imageFile = value;
  }

  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();

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
    if (_imageFile != null || paymentImage.isNotEmpty) {
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
        return Image.network(paymentImage, fit: BoxFit.fill);
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
                    "Upload an Image for Payment.",
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
                                        'Please select an image.',
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                    onTap: () {
                      Maintenance();
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        'Submit',
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
