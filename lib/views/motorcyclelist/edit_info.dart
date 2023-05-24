import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'motorcycleslist.dart';

TextStyle robotoStyle(
    FontWeight font, Color? col, double? size, TextDecoration? deco) {
  return GoogleFonts.roboto(
      fontWeight: font, color: col, fontSize: size, decoration: deco);
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class EditMotor extends StatefulWidget {
  final id ;
  const EditMotor({Key? key,this.id}) : super(key: key);
  @override
  State<EditMotor> createState() => _EditMotorState();
}

class _EditMotorState extends State<EditMotor> {

  TextEditingController frameNumberController = TextEditingController();
  TextEditingController productionYearController = TextEditingController();
  TextEditingController numPassengersController = TextEditingController();
  TextEditingController loadCapacitorController = TextEditingController();
  CollectionReference motors = FirebaseFirestore.instance.collection('motors');
  CollectionReference brands = FirebaseFirestore.instance.collection('brands');
  CollectionReference types = FirebaseFirestore.instance.collection('types');
  CollectionReference engineTypes = FirebaseFirestore.instance.collection(
      'engineTypes');
  CollectionReference specialRequirements = FirebaseFirestore.instance
      .collection('specialRequirements');
  CollectionReference mainColors = FirebaseFirestore.instance.collection(
      'mainColors');
  CollectionReference secondaryColors = FirebaseFirestore.instance.collection(
      'secondaryColor');

  List<String> brandObjects = [];
  List<String> typeObjects = [];
  List<String> engineTypeObjects = [];
  List<String> specialRequirementsObjects = [];
  List<String> mainColorObjects = [];
  List<String> secondaryColorObjects = [];

  String frameNumber = '1ES-2FS';
  String productionYear = '';
  String numPassenger = '';
  String loadCapacitor = '';
  String brand = 'Arion';
  String type = 'street bike';
  String engineType = 'single Cylinder';
  String specialRequirement = 'modeling power';
  String mainColor = 'RED';
  String secondaryColor = 'RED';
  String featuredImage = '';

  String user_id = '';
  bool loading = true;
  getInfo(id) async {
    if (loading == true) {
      await motors
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot){
            if (documentSnapshot.exists) {
              Map data = (documentSnapshot.data() as Map);
              (data).forEach((key, value) {
                  if(key == 'frameNumber'){
                    frameNumber = value;
                    frameNumberController = TextEditingController(text:value.toString());
                  }else if(key == 'productionYear'){
                    productionYear = value;
                    productionYearController = TextEditingController(text:value.toString());
                  }else if(key == 'numPassengers'){
                    numPassenger = value;
                    numPassengersController = TextEditingController(text: value.toString());
                  }else if(key == 'loadCapacitor'){
                    loadCapacitor = value;
                    loadCapacitorController = TextEditingController(text:value.toString());
                  }else if(key == 'brand'){
                    brand = value;
                  }else if(key == 'type'){
                    type = value;
                  }else if(key == 'engineType'){
                    engineType = value;
                  }else if(key == 'specialRequirement'){
                    specialRequirement = value;
                  }else if(key == 'mainColor'){
                    mainColor = value;
                  }else if(key == 'secondaryColor'){
                    secondaryColor = value;
                  }else if(key == 'featuredImage'){
                    featuredImage = value;
                    if(value.isNotEmpty) {
                      imgSelected = true;
                    }
                  }
              });
            }
            else{
              Fluttertoast.showToast(msg: 'Motor Data does not exist!');
            }
      });
    }
  }
  getBrands() async {
    if (loading == true) {
      List<String> tempList = [];
      await brands
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print(doc["value"]);
          tempList.add(doc["value"] ?? '',);
        });
      });
      setState(() {
        brandObjects = tempList;
      });
    }
  }

  getTypes() async {
    if (loading == true) {
      List<String> tempList = [];
      tempList = [];
      await types
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          tempList.add(doc["value"] ?? '',
          );
        });
        setState(() {
          typeObjects = tempList;
        });
      });
    }
  }

  getEngineTypes() async {
    if (loading == true) {
      List<String> tempList = [];
      tempList = [];
      await engineTypes
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          tempList.add(doc["value"] ?? '',
          );
        });
        setState(() {
          engineTypeObjects = tempList;
        });
      });
    }
  }

  getSpecialRequirements() async {
    if (loading == true) {
      List<String> tempList = [];
      tempList = [];
      await specialRequirements
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          tempList.add(doc["value"] ?? '',
          );
        });
        setState(() {
          specialRequirementsObjects = tempList;
        });
      });
    }
  }

  getSecondaryColors() async {
    if (loading == true) {
      List<String> tempList = [];
      tempList = [];
      await secondaryColors
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          tempList.add(doc["value"] ?? '',
          );
        });
        setState(() {
          secondaryColorObjects = tempList;
        });
      });
    }
  }

  getmainColors() async {
    if (loading == true) {
      List<String> tempList = [];
      tempList = [];
      await mainColors
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          tempList.add(doc["value"] ?? '',
          );
        });
        setState(() {
          mainColorObjects = tempList;
        });
      });
    }
  }

  EditMotor(frameNumber, produtionYear, brand, type, engineType,
      specialRequirement, mainColor, secondaryColor, numPassengers,
      loadCapacitor) async {

    var imgUrl = '';
    final storageRef = FirebaseStorage.instance.ref();
    var uuid = Uuid();
    final avatarImgRef = storageRef.child("motorImages/${uuid.v1()}.jpg");
    if (_imageFile == null && featuredImage.isEmpty) {
      Fluttertoast.showToast(msg: "You must select the photo.");
      return;
    }

    File file = File(_imageFile?.path?? '');

    try {
      if(_imageFile!= null) {
        await avatarImgRef.putFile(file);
        imgUrl = await avatarImgRef.getDownloadURL();
      }else{
        imgUrl = featuredImage;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Uploading Failure!");
    }



    if(frameNumber.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Frame Number field");
      return;
    }
    if(produtionYear.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Production Year field");
      return;
    }
    if(brand.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Brand field");
      return;
    }
    if(type.isEmpty){
      Fluttertoast.showToast(msg: "Please enter Type field");
      return;
    }
    if(engineType.isEmpty){
      Fluttertoast.showToast(msg: "Please enter EngineType field");
      return;
    }
    if(specialRequirement.isEmpty){
      Fluttertoast.showToast(msg: "Please enter specialRequirement field");
      return;
    }
    if(mainColor.isEmpty){
      Fluttertoast.showToast(msg: "Please enter mainColor field");
      return;
    }
    if(secondaryColor.isEmpty){
      Fluttertoast.showToast(msg: "Please enter secondaryColor field");
      return;
    }
    if(numPassengers.isEmpty){
      Fluttertoast.showToast(msg: "Please enter numPassengers field");
      return;
    }
    if(loadCapacitor.isEmpty){
      Fluttertoast.showToast(msg: "Please enter loadCapacitor field");
      return;
    }
    motors.doc(widget.id).update({
      'frameNumber': frameNumber,
      'productionYear': produtionYear,
      'brand': brand,
      'type': type,
      'engineType': engineType,
      'specialRequirement': specialRequirement,
      'mainColor': mainColor,
      'secondaryColor': secondaryColor,
      'numPassengers': numPassengers,
      'loadCapacitor': loadCapacitor,
      'status':'In Production',
      'featuredImage':imgUrl,
    }).then((value) =>
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const MortorCycleList(status: '',),
        ),
      ),
      Fluttertoast.showToast(msg: "Motor Information is updated successfully!"),
    });
  }

  Future<void> getItems() async {
    getInfo(widget.id);
    getBrands();
    getEngineTypes();
    getmainColors();
    getSecondaryColors();
    getSpecialRequirements();
    getTypes();
    setState(() {
      loading = false;
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
      if(_imageFile != null) {
        return
          kIsWeb
              ? Image.network(_imageFile!.path, fit: BoxFit.fill,)
              : Image.file(File(_imageFile!.path,), fit: BoxFit.fill,);
      }else{
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
  void initState() {
    super.initState();
  }

  Widget myDropDownButton(Icon icon, String title, List<String> list,
      String? defaultValue, void Function(Object? value) func) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                style: robotoStyle(FontWeight.w400,
                    const Color.fromARGB(255, 107, 107, 107), null, null),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: list
            .map(
              (item) =>
              DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    icon,
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: robotoStyle(FontWeight.w400,
                            const Color.fromARGB(255, 107, 107, 107), null,
                            null),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
        )
            .toList(),
        value: defaultValue,
        onChanged: (value) {
          func(value);
        },
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down_rounded,
          ),
          iconSize: 30,
          iconEnabledColor: Color.fromARGB(255, 49, 48, 54),
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 260,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 235, 235, 235),
          ),
          elevation: 0,
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(5),
            thumbVisibility: MaterialStateProperty.all<bool>(false),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
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
                      "Edit Motor Information",
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
        body:
        FutureBuilder(
            future: getItems(),
            builder: (context, AsyncSnapshot snapshot) {
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
                return
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
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
                            'Frame Number',
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
                              controller: frameNumberController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFF444444)),
                                hintText: '1FS-2ES',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Production Year',
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
                              controller: productionYearController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFF444444)),
                                hintText: '2023',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Brand',
                            style: TextStyle(
                                color: Color(0xFF33343C),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          myDropDownButton(
                              const Icon(
                                Icons.branding_watermark_outlined,
                                size: 25,
                                color: Colors.grey,
                              ),
                              "Default Brand",
                              brandObjects,
                              brand, (value) {
                            setState(() {
                              brand = value as String;
                            });
                          }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Type',
                            style: TextStyle(
                                color: Color(0xFF33343C),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          myDropDownButton(
                              const Icon(
                                Icons.merge_type,
                                size: 25,
                                color: Colors.grey,
                              ),
                              "Default Type",
                              typeObjects,
                              type, (value) {
                            setState(() {
                              type = value as String;
                            });
                          }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'engine Type',
                            style: TextStyle(
                                color: Color(0xFF33343C),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          myDropDownButton(
                              const Icon(
                                Icons.engineering_outlined,
                                size: 25,
                                color: Colors.grey,
                              ),
                              "Default EngineType",
                              engineTypeObjects,
                              engineType, (value) {
                            setState(() {
                              engineType = value as String;
                            });
                          }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Special Requirements',
                            style: TextStyle(
                                color: Color(0xFF33343C),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          myDropDownButton(
                              const Icon(
                                Icons.model_training_sharp,
                                size: 25,
                                color: Colors.grey,
                              ),
                              "Default EngineType",
                              specialRequirementsObjects,
                              specialRequirement, (value) {
                            setState(() {
                              specialRequirement = value as String;
                            });
                          }),

                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Main Color',
                            style: TextStyle(
                                color: Color(0xFF33343C),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          myDropDownButton(
                              const Icon(
                                Icons.color_lens_outlined,
                                size: 25,
                                color: Colors.grey,
                              ),
                              "Default Main Color",
                              mainColorObjects,
                              mainColor, (value) {
                            setState(() {
                              mainColor = value as String;
                            });
                          }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Secondary Color',
                            style: TextStyle(
                                color: Color(0xFF33343C),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          myDropDownButton(
                              const Icon(
                                Icons.color_lens_outlined,
                                size: 25,
                                color: Colors.grey,
                              ),
                              "Default Main Color",
                              secondaryColorObjects,
                              secondaryColor, (value) {
                            setState(() {
                              secondaryColor = value as String;
                            });
                          }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Number of Passengers',
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
                              controller: numPassengersController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFF444444)),
                                hintText: '10',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Text(
                            'Load Capacity',
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
                              controller: loadCapacitorController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFF444444)),
                                hintText: '10',
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: () {
                              EditMotor(
                                  frameNumberController.text,
                                  productionYearController.text,
                                  brand,
                                  type,
                                  engineType,
                                  specialRequirement,
                                  mainColor,
                                  secondaryColor,
                                  numPassengersController.text,
                                  loadCapacitorController.text
                              );
                            },
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                'Edit Motor',
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
            })
    );
  }
}
