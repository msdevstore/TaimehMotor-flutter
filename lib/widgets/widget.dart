import 'package:flutter/material.dart';

class baseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const baseAppBar({Key? key, required this.title}) : super(key: key);

  static final _appBar = AppBar();
  @override
  Size get preferredSize => _appBar.preferredSize;

  @override
  _baseAppBarState createState() => _baseAppBarState();
}

class _baseAppBarState extends State<baseAppBar> {
  Color _color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: Colors.black,
    );
  }
}