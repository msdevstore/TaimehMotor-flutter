import 'package:arionmotor/views/dashboard/dashboard.dart';
import 'package:arionmotor/views/shop/shop.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arionmotor/views/signin.dart';
import 'package:arionmotor/views/userslist/userslist.dart';
import 'firebase_options.dart';
late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  runApp(const FirebasePhoneAuthProvider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:MyApp())
  )
  );
}
class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}
class _MyApp extends State<MyApp> {
  CollectionReference  users = FirebaseFirestore.instance.collection('users');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(prefs.getBool('loggedin'));
    print(prefs.getString('accountType'));
    print(prefs.getString('firstname'));
    print(prefs.getString('photo'));
    print(prefs.getString('email'));
    print(prefs.getString('status'));
    return MaterialApp(
      title: 'Taimeh Motor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: SignIn(),
      initialRoute: prefs.getBool('loggedin') != true
          ? '/SignIn':'/DashBoard',
      routes: {
        '/SignIn': (context) => SignIn(),
        '/DashBoard': (context) => Shop(),
        '/usersList': (context) => const UserList(role:'')
      },
    );
  }
}