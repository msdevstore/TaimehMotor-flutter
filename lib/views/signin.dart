import 'package:arionmotor/views/dashboard/addprofile.dart';
import 'package:arionmotor/views/verification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'package:arionmotor/tools/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

bool isPhoneNumber(String value) {
  String patttern = r'(^(?:[+0])?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (value.isEmpty) {
    return false;
  }
  else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String phoneNumber;
  late String countryCode, partNumber;
  bool textChanged = false;
  late final SharedPreferences prefs ;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseService service = FirebaseService();
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget phoneSection = Center(
        child:Align(
          alignment: Alignment.bottomCenter,
          child: Column(
              children: <Widget>[
                IntlPhoneField(
                  dropdownTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'US',
                  onChanged: (phone) {
                    textChanged = true;
                    phoneNumber = phone.completeNumber;
                    partNumber = phone.number;
                    countryCode = phone.countryCode;
                  },
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.08,
                  margin: const EdgeInsets.only(top:10, bottom: 20),
                  child:ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(52, 204, 52, 1),
                      textStyle: const TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: const BorderSide(color:  Color.fromRGBO(52, 204, 52, 1),),
                      ),
                    ),
                    onPressed: () {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      if (textChanged) {
                        if (isPhoneNumber(phoneNumber)) {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: VerifyPhoneNumberScreen(
                                phoneNumber: phoneNumber,
                                countryCode: countryCode,
                                partNumber: partNumber,
                              ),
                              isIos: true,
                              duration: const Duration(milliseconds: 400),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Sign In', style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w700)),
                  ),
                ),
              ]
          ),
        )
    );
    Widget continueSection = Center(
        child:Align(
          alignment: Alignment.bottomCenter,
          child: Column(
              children: <Widget>[
                phoneSection,
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.06,
                  margin: const EdgeInsets.only(bottom:10),
                  child: ElevatedButton.icon(
                    icon:Platform.isIOS? const Icon(Icons.apple_sharp):Image.asset('assets/img/google-icon.png'),
                    label: const Text(
                        'Google SignIn',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 22.0,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                    ),
                    style:ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color:  Colors.white,),
                      ),
                    ),
                    onPressed: () async {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      if (Platform.isIOS) {

                      } else {
                        service.signInWithGoogle().then((result) {
                          if (result == 'SUCCESS') {
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/DashBoard', (route) => true
                              );
                            }
                          } else if (result == "NOT_REGISTERED") {
                            //showSnackBar("Your account is not registered. Please contact Saib Taimeh Alla Makhamreh or visit our authorized dealers.");
                            // showMessage(context, result.toString(
                            //
                            //
                            //
                            // ));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProfile()));
                          }
                          else{
                            Navigator.pushNamedAndRemoveUntil(context, '/SignIn', (route) => true);
                          }
                        });
                      }
                    },
                  ),
                )
              ]
          ),
        )
    );
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/img/background.jpg',
            ).image,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const  EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 25, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/img/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Taimeh \n       Motor',
                            style: GoogleFonts.inter(
                              color: Colors.black87,
                              fontSize: 36,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Welcome!',
                          style: GoogleFonts.inter(
                            color: Colors.black87,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow( // bottomLeft
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.white
                              ),
                              Shadow( // bottomRight
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white
                              ),
                              Shadow( // topRight
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.white
                              ),
                              Shadow( // topLeft
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.white
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // phoneSection,
                    continueSection,
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(33, 0, 43, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              'If you do not have a registered account, please contact Saib Taimeh Alla Makhamreh or visit our authorized dealers.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );

  }
}