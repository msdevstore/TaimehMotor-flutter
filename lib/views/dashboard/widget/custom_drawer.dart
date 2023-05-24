import 'package:arionmotor/views/editinformation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import '../../../tools/firebase_service.dart';
import '../../mymotorcycles.dart';
import '../../signin.dart';
import '../userprofile.dart';
import 'custome_list_png_tile.dart';
import 'custome_list_tile.dart';
import 'package:flutter_svg/svg.dart';

User? user = FirebaseAuth.instance.currentUser;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late SharedPreferences preferences;
  // String photo= '';
  // String firstname = '';
  // String lastname = '';
  // String email = '';
  // String photoURL = '';
  String displayName = '';
  String email = '';
  String user_id = '';
  final FirebaseService _fireService = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  initShared() async {
    setState(() async {
      preferences = await SharedPreferences.getInstance();
      // photo = preferences.getString('photo')!;
      // firstname = preferences.getString('firstname')!;
      // lastname = preferences.getString('lastname')!;
      // photoURL = preferences.getString('imgUrl')!;
      // print('photoURL:${preferences.getString('imgUrl')}');
      displayName = preferences.getString('displayName')!;
      email = preferences.getString('email')!;
      user_id = preferences.getString('uid')!;
    });
  }

  logout() async {
    try {
      _fireService.signOut();
      log('logout successful');
      Fluttertoast.showToast(msg: 'Logout Success!');
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
    } catch (e) {
      print("Catch Error________________");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: Drawer(
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
              width: double.maxFinite,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 18.0,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 90,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FutureBuilder(
                        future: initShared(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Column(
                              children: const [
                                Text("Loading..."),
                                CircularProgressIndicator(),
                              ],
                            ));
                          } else {
                            return Column(
                              children: [
                                Text(
                                  user!.displayName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF343434),
                                      fontSize: 16.5),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  user!.email!,
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 87, 84, 84)
                                              .withOpacity(0.5),
                                      fontSize: 13),
                                )
                              ],
                            );
                          }
                        }),
                  ],
                ),
              ),
            )),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()));
                    },
                    child: const CustomListTile(
                      imageUrl: 'assets/icons/account_circle_black_24dp.svg',
                      title: 'Edit Profile',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyMotorcycles(
                                    user_id: user_id,
                                  )));
                    },
                    child: const CustomListPngTile(
                      imageUrl: 'assets/icons/motors.png',
                      title: 'MyMotorCycles',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      logout();
                    },
                    child: const CustomListTile(
                      imageUrl: 'assets/icons/Vector (4).svg',
                      title: 'Logout',
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'TAIMEH MOTOR',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
