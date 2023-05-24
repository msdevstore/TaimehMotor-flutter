import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  const ReusableContainer({
    Key? key,
    required this.iconUrl,
    required this.title,
  }) : super(key: key);
  final String iconUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: const Color(0xFFD9D9D9))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: [
           Image.asset(
              iconUrl,
              height: 30,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(title,
                style: const TextStyle(
                    color: Color(0xFF31333E),
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
