import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({required this.imageUrl, required this.title});

  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -1.9),
      horizontalTitleGap: -4,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 20),
        child: Padding(
          padding: const EdgeInsets.all(.0),
          child: SvgPicture.asset(
            imageUrl,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Color(0xFF343434),
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    );
  }
}
