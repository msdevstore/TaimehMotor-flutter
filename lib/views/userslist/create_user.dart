import 'package:arionmotor/views/userslist/userslist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:uuid/uuid.dart';

class CreateUser extends StatefulWidget {
  @override
  State<CreateUser> createState() => _CreateUserState();
}
typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class _CreateUserState extends State<CreateUser> {

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

  String user_id = '';
  bool loading = false;

  CreateUser(fname, secondName, thirdName, lastName, dateBirth, email, nationalNumber, phoneNumber, address, job, role, imgUrl) async {

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // user_id = (await preferences.getString('user_id'))!;
    // print(user_id);
    final storageRef = FirebaseStorage.instance.ref();
    var imgUrl='';
    var uuid = Uuid();
    final avatarImgRef = storageRef.child("avatar/${uuid.v1()}.jpg");
    if (_imageFile == null) {
      Fluttertoast.showToast(msg: "You must select the photo.");
      return;
    }

    File file = File(_imageFile?.path?? '');   try {
      await avatarImgRef.putFile(file);
      imgUrl = await  avatarImgRef.getDownloadURL();
    } catch (e) {
      Fluttertoast.showToast(msg: "Uploading Failure!");
    }
    if(fname.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Name field");
      return;
    }
    if(secondName.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Second dName field");
      return;
    }
    if(thirdName.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Third Name field");
      return;
    }
    if(lastName.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Last Name field");
      return;
    }
    if(dateBirth.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Date of Birth field");
      return;
    }
    if(email.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Email field");
      return;
    }
    if(nationalNumber.isEmpty){
      Fluttertoast.showToast(msg: "Please enter National Number field");
      return;
    }
    if(phoneNumber.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Phone Number field");
      return;
    }
    if(address.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Address field");
      return;
    }
    users.add({
          'name':fname,
          'secondName':secondName,
          'thirdName':thirdName,
          'lastName':lastName,
          'dateBirth':dateBirth,
          'email':email,
          'nationalNumber':nationalNumber,
          'phoneNumber':phoneNumber,
          'Address':address,
          'jobTitle':job,
          'role':role,
          'featuredImage':imgUrl
    }).then((value) => {
      print(value),
    Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/Dashboard', (route) => true
                            ),
      Fluttertoast.showToast(msg: "User Information is added successfully!"),
    });
  }
  String? _retrieveDataError;
  XFile? _imageFile;
  String? message = "";
  bool imgSelected = false ;
  void _setImageFileListFromFile(XFile? value) {
    print(_imageFile?.path);
    _imageFile = value;
  }
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  double progress = 0;
  @override

  void initState() {

  }

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
    if (_imageFile != null) {
      return
        kIsWeb
            ? Image.network(_imageFile!.path,fit: BoxFit.fill,)
            : Image.file(File(_imageFile!.path,),fit: BoxFit.fill,);
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
                    "Create a User",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                              width: 2,
                              color: Colors.black
                          )
                      ),
                      child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                          ? FutureBuilder<void>(
                        future: retrieveLostData(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
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
                      alignment:Alignment.bottomLeft,
                      margin: const EdgeInsets.only(top:120),
                      padding: const EdgeInsets.all(10.0),
                      child: FloatingActionButton(
                        backgroundColor: Colors.orange,
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.gallery, context: context);
                        },
                        tooltip: 'Select an Image',
                        child: const Icon(Icons.upload),
                      ),
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
                      hintText: 'Suzy Queue. 4455 Landing Lange, APT 4. Louisville, KY 40018-1234',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: (){
                    CreateUser(
                        nameController.text,
                        secondNameController.text,
                        thirdNameController.text,
                        lastNameController.text,
                        dateBirthController.text,
                        emailController.text,
                        nationalNumberController.text,
                        nationalNumberController.text,
                        nationalNumberController.text,
                        'engineer',
                        'viewer',
                        ''
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
                      'Create User',
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
      ),
    );
  }
}
