import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';

class UserInformation extends StatefulWidget {
  @override
  _EditInformationState createState() => _EditInformationState();
}
final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2Fw22zm2tl6XvxtOsHD1rdzMbQbY.png?alt=media&token=707dffc2-c8ef-47bf-a212-076bb6657cd0',
  'https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2F2tfE0TpMODPHWRvfOLyn238.png?alt=media&token=a58ad572-6fdb-4810-b115-19645307aa11',
  'https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2Fw22zm2tl6XvxtOsHD1rdzMbQbY.png?alt=media&token=707dffc2-c8ef-47bf-a212-076bb6657cd0',
];

class _EditInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.maxFinite,
              child: Row(),
            ),
            Positioned(
              left: 1,
              child: Row(
                children: [
                  const SizedBox(
                    width: 17.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/east.svg',
                      width: 20,
                      color: const Color(0xff3F3F3F),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  const Text(
                    "Edit User Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF33343C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.8,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8), // Border width
                      width: MediaQuery.of(context).size.width*0.5,
                      height: MediaQuery.of(context).size.width*0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.network('https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2F2tfE0TpMODPHWRvfOLyn238.png?alt=media&token=a58ad572-6fdb-4810-b115-19645307aa11', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Container(
                        child: CarouselSlider(
                          options: CarouselOptions(),
                          items: imgList
                              .map((item) => Container(
                            child: Center(
                                child:
                                Image.network(item, fit: BoxFit.cover, width: 1000)),
                          ))
                              .toList(),
                        )),
                    Container(
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Name *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Second Name *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter second name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Third Name"
                        ),
                        style: TextStyle(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Last Name *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "National Number *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter national number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Phone Number *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Date of Birth *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10),
                      padding: EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Address *"
                        ),
                        style: TextStyle(),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                            width: MediaQuery.of(context).size.width*0.46,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          side: BorderSide(color: Colors.white)
                                      )
                                  )
                              ),
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                // if (_formKey.currentState!.validate()) {
                                //   // If the form is valid, display a snackbar. In the real world,
                                //   // you'd often call a server or save the information in a database.
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(content: Text('Processing Data')),
                                //   );
                                // }
                              },
                              child: const Text('Edit information'),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          side: BorderSide(color: Colors.white)
                                      )
                                  )
                              ),
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                // if (_formKey.currentState!.validate()) {
                                //   // If the form is valid, display a snackbar. In the real world,
                                //   // you'd often call a server or save the information in a database.
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(content: Text('Processing Data')),
                                //   );
                                // }
                              },
                              child: const Text('Edit Authority'),
                            ),
                          ),
                        ],
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                            width: MediaQuery.of(context).size.width*0.46,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          side: const BorderSide(color: Colors.white)
                                      )
                                  )
                              ),
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                // if (_formKey.currentState!.validate()) {
                                //   // If the form is valid, display a snackbar. In the real world,
                                //   // you'd often call a server or save the information in a database.
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(content: Text('Processing Data')),
                                //   );
                                // }
                              },
                              child: const Text('View Log'),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          side: const BorderSide(color: Colors.white)
                                      )
                                  )
                              ),
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                // if (_formKey.currentState!.validate()) {
                                //   // If the form is valid, display a snackbar. In the real world,
                                //   // you'd often call a server or save the information in a database.
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(content: Text('Processing Data')),
                                //   );
                                // }
                              },
                              child: const Text('View motorcycles'),
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
        ),
      ),
    );
  }
}