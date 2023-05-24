import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arionmotor/widgets/widget.dart';
import 'package:arionmotor/tools/firebase_service.dart';

class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseService service = FirebaseService();
  @override
  void initState() {
    super.initState();
    service.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      appBar: baseAppBar(title: "Error"),
      body: Container(

      ),
    );
  }
}