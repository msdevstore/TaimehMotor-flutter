import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
// import 'signup.dart';
import '../utils/helpers.dart';
import '../widgets/custom_loader.dart';
import '../widgets/pin_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;
  final String countryCode;
  final String partNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
    required this.partNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;
  bool isShowLoadingWidget = true;
  late final ScrollController scrollController;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late final SharedPreferences prefs;

  // Future<void> setUserId(String _uid) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('uid', _uid);
  // }

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    await Future.delayed(const Duration(milliseconds: 250));
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 0),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {
          log(VerifyPhoneNumberScreen.id, msg: 'OTP sent!');
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          log(
            VerifyPhoneNumberScreen.id,
            msg: autoVerified
                ? 'OTP was fetched automatically!'
                : 'OTP was verified manually!',
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setString('uid', userCredential.user!.uid);
          // await setUserId(userCredential.user!.uid);
          var userData;
          bool userExist = false;
          //

          // var user = await users
          //     .where('phoneNumber', isEqualTo: '+11234567890')
          //     .get()
          //     .then((QuerySnapshot querySnapshot) {
          //   if (querySnapshot.docs.isEmpty) {
          //     print('not registered');
          //     // text =  'NOT_REGISTERED';
          //     userExist = false;
          //   } else {
          //     print('registered');
          //     userExist = true;
          //   }
          // });
          prefs = await SharedPreferences.getInstance();
          await prefs.setString('phoneNumber', widget.phoneNumber);
          await users.get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              try {
                // print("phoneNumber:${doc['phoneNumber']}");
                // print('displayName:${doc['displayName']}');
                // print('email:${doc.id}');
                // print('pref:${prefs.getString('phoneNumber')}');
                if (doc["phoneNumber"] == prefs.getString('phoneNumber')) {
                  prefs.setString('uid', doc['userId']);
                  print('uid:${prefs.getString('uid')}');
                  print(doc.id);
                  print('exist:true');
                  prefs.setString('displayName', doc['displayName']);
                  prefs.setString('useremail', doc['email']);
                  // prefs.setString(key, value)
                }
                if (doc.id == prefs.getString('uid')!){
                    userExist = true;
                }
                // ignore: empty_catches
              } catch (e) {}
            });
          });
          // print('user:${user}'); // var user = await (userCredential.user!.uid);
          if (userExist) {
            // print(userData);
            // print(userData['email']);
            // print(userData['name']);
            // print(userData['phoneNumber']);
            // print(userData['profileCompleted']);
            await prefs.setBool('loggedin', true);
            // await prefs.setString('name', userData['name']??'');
            // await prefs.setString('email', userData['email']??'');
            // await prefs.setString('mobile', userData['phoneNumber']??'');
            // await prefs.setString(
            //     'status', userData['status'] ?? 'uncompleted');
            // await prefs.setString(
            //     'accountType', userData['accountType'] ?? 'user');
            // print(prefs.getBool('profileCompleted'));
            Fluttertoast.showToast(
              msg: "Login Sucessfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_LEFT,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
              textColor: Colors.white,
              fontSize: 16.0,
            );
            // Fluttertoast.showToast(
            //   msg: "Phone number verified successfully!",
            //   toastLength: Toast.LENGTH_SHORT,
            //   gravity: ToastGravity.TOP_LEFT,
            //   timeInSecForIosWeb: 1,
            //   backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
            //   textColor: Colors.white,
            //   fontSize: 16.0,
            // );
            Navigator.pushNamedAndRemoveUntil(
                context, '/DashBoard', (route) => true);
          } else {
            // prefs = await SharedPreferences.getInstance();
            // await prefs.setString('phoneNumber', widget.phoneNumber);
            // await prefs.setString('uid', userCredential.user!.uid);
            Fluttertoast.showToast(
              msg: "Please Sign In with Google!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP_LEFT,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context);
          }
          showSnackBar('Phone number verified successfully!');
          log(
            VerifyPhoneNumberScreen.id,
            msg: 'Login Success UID: ${userCredential.user?.uid}',
          );
        },
        onLoginFailed: (authException, stackTrace) {
          switch (authException.code) {
            case 'invalid-phone-number':
              // invalid phone number
              setState(() {
                isShowLoadingWidget = false;
              });
              Navigator.pop(context);
              // Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Invalid phone number!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_LEFT,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                textColor: const Color.fromRGBO(52, 204, 52, 1),
                fontSize: 16.0,
              );
              return showSnackBar('Invalid phone number!');
            case 'invalid-verification-code':
              // invalid otp entered
              setState(() {
                isShowLoadingWidget = false;
              });
              Fluttertoast.showToast(
                msg:
                    "The entered OTP is invalid! Please input correct otp code.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_LEFT,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                textColor: Colors.white,
                fontSize: 16.0,
              );
              // showMessage(context,'The entered OTP is invalid! Please input correct otp code.');
              // Navigator.pop(context);
              return showSnackBar('The entered OTP is invalid!');
            // handle other error codes
            default:
              setState(() {
                isShowLoadingWidget = false;
              });
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Something went wrong! Please try again.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP_LEFT,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
                textColor: Colors.white,
                fontSize: 16.0,
              );
            // showMessage(context,'Something went wrong! Please try again.');
            // Navigator.pop(context);
            // showSnackBar('Something went wrong! ');
            // handle error further if needed
          }
          // Navigator.pop(context);
        },
        onError: (error, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            error: error,
            stackTrace: stackTrace,
          );
          setState(() {
            isShowLoadingWidget = false;
          });
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Something went wrong! Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_LEFT,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromRGBO(50, 50, 50, 1),
            textColor: Colors.white,
            fontSize: 16.0,
          );
          // showMessage(context,'Something went wrong! Please try again.');
          showSnackBar('An error occurred!');
          // Navigator.pop(context);
        },
        builder: (context, controller) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
            body: controller.isSendingCode
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CustomLoader(),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Please Wait...',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat-SemiBold',
                              fontSize: 18),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    children: [
                      Container(
                        child: Image.asset('assets/img/logo.png'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          "We've sent an SMS with a verification code to ${widget.phoneNumber}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Montserrat-Medium', fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      // if (controller.isListeningForOtpAutoRetrieve)
                      //   Column(
                      //     children: const [
                      //       CustomLoader(),
                      //       SizedBox(height: 20),
                      //       Text(
                      //         'Listening for OTP',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //           fontSize: 25,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //       SizedBox(height: 15),
                      //       Divider(),
                      //       Text('OR', textAlign: TextAlign.center),
                      //       Divider(),
                      //     ],
                      //   ),
                      const SizedBox(height: 15),
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat-SemiBold',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinInputField(
                        length: 6,
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                        },
                        onSubmit: (enteredOtp) async {
                          final verified =
                              await controller.verifyOtp(enteredOtp);
                          if (verified) {
                            // number verify success
                            // will call onLoginSuccess handler
                          } else {
                            // phone verification failed
                            // will call onLoginFailed or onError callbacks with the error
                          }
                        },
                      ),
                      if (controller.codeSent)
                        TextButton(
                          onPressed: controller.isOtpExpired
                              ? () async {
                                  log(VerifyPhoneNumberScreen.id,
                                      msg: 'Resend OTP');
                                  await controller.sendOTP();
                                }
                              : null,
                          child: Text(
                            controller.isOtpExpired
                                ? 'Resend'
                                : '${controller.otpExpirationTimeLeft.inSeconds}s',
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat-SemiBold',
                                fontSize: 18),
                          ),
                        ),
                      const SizedBox(width: 5),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
