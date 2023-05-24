import 'package:arionmotor/views/userslist/userslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'user_model.dart';

class ApplyFilter extends StatefulWidget {
  const ApplyFilter({Key? key, this.roleText}) : super(key: key);
  final String? roleText;
  @override
  State<ApplyFilter> createState() => _ApplyFilterState();
}
class _ApplyFilterState extends State<ApplyFilter> {
  String roleValue = '';
  var roleList = [
    '',
    'admin',
    'editor',
    'viewer',
  ];
  bool loading = false;
  UserObject allEmployees = UserObject();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Apply Filter",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF33343C),
          ),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              'assets/icons/east.svg',
              width: 20,
              color: const Color(0xff3F3F3F),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.8,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'role',
              style: TextStyle(
                  color: Color(0xFF33343C),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5),
            ),
            const SizedBox(
              height: 5.9,
            ),
            DropdownButton(
              isExpanded: true,
              value: roleValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: roleList.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  roleValue = newValue!;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserList(role: roleValue,)));
              },
              child: Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 16),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

