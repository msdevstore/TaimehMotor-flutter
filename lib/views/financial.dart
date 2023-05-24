import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arionmotor/widgets/widget.dart';
import 'package:arionmotor/tools/firebase_service.dart';

class Financial extends StatefulWidget {
  @override
  _FinancialState createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      appBar: const baseAppBar(title: "Financial"),
      body: Container(

      ),
    );
  }
}