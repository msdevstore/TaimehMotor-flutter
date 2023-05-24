import 'package:flutter/material.dart';
import 'package:arionmotor/widgets/widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}
final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2Fw22zm2tl6XvxtOsHD1rdzMbQbY.png?alt=media&token=707dffc2-c8ef-47bf-a212-076bb6657cd0',
  'https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2F2tfE0TpMODPHWRvfOLyn238.png?alt=media&token=a58ad572-6fdb-4810-b115-19645307aa11',
  'https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2Fw22zm2tl6XvxtOsHD1rdzMbQbY.png?alt=media&token=707dffc2-c8ef-47bf-a212-076bb6657cd0',
];
class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const baseAppBar(title: "User Information"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/img/background2.jpg',
            ).image,
            alignment: Alignment.topCenter,
          ),
        ),
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
                      padding: const EdgeInsets.all(8), // Border width
                      width: MediaQuery.of(context).size.width*0.5,
                      height: MediaQuery.of(context).size.width*0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(48), // Image radius
                          child: Image.network('https://firebasestorage.googleapis.com/v0/b/arionmotor-7d22b.appspot.com/o/avatar%2F2tfE0TpMODPHWRvfOLyn238.png?alt=media&token=a58ad572-6fdb-4810-b115-19645307aa11', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Container(
                      child: CarouselSlider(
                        options: CarouselOptions(),
                        items: imgList
                            .map((item) => Center(
                                child:
                                Image.network(item, fit: BoxFit.cover, width: 1000)))
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
                        style: const TextStyle(),
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
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Second Name *"
                        ),
                        style: const TextStyle(),
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
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Third Name"
                        ),
                        style: const TextStyle(),
                      ),
                    ),
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
                            labelText: "Last Name *"
                        ),
                        style: const TextStyle(),
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
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "National Number *"
                        ),
                        style: const TextStyle(),
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
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Phone Number *"
                        ),
                        style: const TextStyle(),
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
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Date of Birth *"
                        ),
                        style: const TextStyle(),
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
                      margin: const EdgeInsets.only(top:10),
                      padding: const EdgeInsets.only(left:10, right:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Address *"
                        ),
                        style: const TextStyle(),
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