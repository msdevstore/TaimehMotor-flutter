import 'package:arionmotor/views/dashboard/maintenance.dart';
import 'package:arionmotor/views/shop/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'motorcyclelist/all_motorcycle_model.dart';

class MyMotorcycles extends StatefulWidget {
  final user_id;
  const MyMotorcycles({Key? key, this.user_id}) : super(key: key);
  @override
  State<MyMotorcycles> createState() => _MyMotorcyclesState();
}

class _MyMotorcyclesState extends State<MyMotorcycles> {
  var MyMotorcycles;
  bool loading = true;
  List<Widget> motorWidgetList = [];
  List<MyMotorCycleObject> motorList = [];
  CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  late final SharedPreferences prefs;
  getMyMotorcycles() async {
    print(widget.user_id);
    if (loading == true) {
      List<MyMotorCycleObject> tempList = [];
      List<Widget> tempWidgetList = [];
      prefs = await SharedPreferences.getInstance();
      await requests.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          try {
            print("userId:${doc['user_id']}");
            print(prefs.getString('uid'));
            if (doc["user_id"] == prefs.getString('uid')!) {
              tempList.add(MyMotorCycleObject(
                  id: doc.id,
                  frameNumber: doc["frameNumber"] ?? 0,
                  // productionYear: doc["productionYear"] ?? '2023',
                  mainColor: doc["mainColor"] ?? 'Red',
                  status: doc["status"] ?? '',
                  featuredImage: doc['motor_image'] ?? '',
                  // assignedDate: doc['requested_date'],
                  brand: doc['brand'],
                  price: doc['price'],
                  rating: doc['rating'],
                  // type: doc['type'],
                  loadCapacitor: doc['loadCapacitor']));
              print("tempList:${tempList}");
            }
            // ignore: empty_catches
          } catch (e) {}
        });
      });
      motorList = tempList;
      for (var motor in motorList) {
        tempWidgetList.add(GestureDetector(
            onTap: () {},
            child: Banner(
                message: motor.status == 'Maintenance Requested'
                    ? 'MR'
                    : motor.status == 'Purchase Requested'
                        ? 'PR'
                        : motor.status == 'Maintenance Assigned'
                            ? 'MA'
                            : 'PA',
                location: BannerLocation.topEnd,
                color: motor.status == 'Maintenance Requested'
                    ? Colors.redAccent
                    : motor.status == 'Purchase Requested'
                        ? Colors.redAccent
                        : motor.status == 'Maintenance Assigned'
                            ? Colors.blueAccent
                            : Colors.blueAccent,
                child: Column(children: [
                  const SizedBox(
                    height: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF3FC729),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 16),
                    child: Text(
                      "${motor.brand}  ${motor.frameNumber}  ${motor.mainColor}  ${motor.loadCapacitor}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: motor.featuredImage.isNotEmpty
                              ? Image.network(
                                  motor.featuredImage.toString(),
                                  width: 90,
                                  height: 70,
                                )
                              : const SizedBox(height: 50)),
                      const SizedBox(
                        width: 7,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price:   ${motor.price}\$',
                            style: const TextStyle(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                                fontSize: 22),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              const Text('Rating '),
                              RatingBarIndicator(
                                rating: double.parse(motor.rating),
                                direction: Axis.horizontal,
                                itemSize: 25,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color.fromRGBO(52, 202, 52, 1),
                                ),
                              ),
                              Text(
                                '(${motor.rating})',
                                style: const TextStyle(
                                    color: Color(0xFF707070),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  motor.status == 'Purchase Requested'
                      ? Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Requested"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Assigned"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Requested"),
                                    ],
                                  ),const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Assigned"),
                                    ],
                                  )
                                
                                ]),
                                
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 30,
                                  child: Text(
                                      'Verifying Payment...',
                                      style: TextStyle(fontSize: 16),
                                    ),),
                              ],
                            ),
                          ],
                        )
                      : motor.status == 'Purchase Assigned'
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                  crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Requested"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Assigned"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Requested"),
                                    ],
                                  ),const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Assigned"),
                                    ],
                                  )
                                
                                ])
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 230,
                                      height: 30,
                                      child: FloatingActionButton(
                                        heroTag: null,
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Maintenance()),
                                          );
                                        },
                                        child: const Text(
                                          'Request Maintenance',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : motor.status == 'Maintenance Requested'
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                  crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Requested"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Assigned"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Requested"),
                                    ],
                                  ),const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Assigned"),
                                    ],
                                  )
                                
                                ]),
                                      ],
                                    ),
                                    const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 30,
                                  child: Text(
                                      'Verifying Payment...',
                                      style: TextStyle(fontSize: 16),
                                    ),),
                              ],
                            ),
                                  ],
                                )
                              : motor.status == 'Maintenance Assigned'
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                  crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Requested"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Assigned"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Requested"),
                                    ],
                                  ),const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Assigned"),
                                    ],
                                  )
                                
                                ]),
                                          ],
                                        ),
                                        const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 230,
                                  height: 30,
                                  child: Text(
                                      'In Maintenance...',
                                      style: TextStyle(fontSize: 16),
                                    ),),
                              ],
                            ),
                                      ],
                                    )
                                  : motor.status == 'Maintenance Completed'
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                  crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Requested"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/shop.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Purchase Assigned"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Requested"),
                                    ],
                                  ),const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset('assets/icons/request.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Maintenance Assigned"),
                                    ],
                                  )
                                
                                ]),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            SizedBox(
                                              width: 230,
                                              height: 30,
                                              child: FloatingActionButton(
                                                heroTag: null,
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Maintenance()),
                                          );
                                                },
                                                child: const Text(
                                                  'Request Maintenance',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ):const SizedBox(width:100, height:100),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 10.0,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 1.0, end: 1.0),
                        height: 1.0,
                        color: const Color.fromARGB(255, 119, 119, 119),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ]))));
      }
      setState(() {
        motorWidgetList = tempWidgetList;
        loading = false;
      });
    } else {}
  }

  maintainRequest(id) async {
    requests.doc(id).update({'status': 'Maintenance Requested'}).then(
      (value) => Fluttertoast.showToast(msg: 'Successfully Requested!'),
    );
  }

  purchaseCancelRequest(id) async {
    requests.doc(id).update({'status': 'In Store', 'user_id': ''}).then(
      (value) => Fluttertoast.showToast(msg: 'Successfully Requested!'),
    );
  }

  maintainCancelRequest(id) async {
    requests.doc(id).update({'status': 'Assigned'}).then(
      (value) => Fluttertoast.showToast(msg: 'Successfully Requested!'),
    );
  }

  void initState() {
    getMyMotorcycles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Shop()),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/icons/east.svg',
                      width: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(
                    width: 14.0,
                  ),
                  const Text(
                    "MyMotorcycles",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3FC729),
        elevation: 0.8,
        shadowColor: Color.fromARGB(255, 75, 75, 75).withOpacity(0.3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  // showModalBottomSheet(
                  //     isScrollControlled: true,
                  //     shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(25),
                  //           topRight: Radius.circular(25)),
                  //     ),
                  //     context: context,
                  //     builder: (context) => SizedBox(
                  //           height: MediaQuery.of(context).size.height - 400,
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Stack(
                  //                 clipBehavior: Clip.none,
                  //                 children: [
                  //                   Container(
                  //                     width: double.maxFinite,
                  //                     height: 140,
                  //                     decoration: const BoxDecoration(
                  //                         borderRadius: BorderRadius.only(
                  //                             topLeft: Radius.circular(25),
                  //                             topRight: Radius.circular(25)),
                  //                         color: Colors.orange),
                  //                   ),
                  //                   Positioned(
                  //                     top: 34,
                  //                     left: 15,
                  //                     right: 15,
                  //                     child: Container(
                  //                       width: double.maxFinite,
                  //                       child: Column(
                  //                         mainAxisSize: MainAxisSize.min,
                  //                         children: [
                  //                           Text(
                  //                             'CDP Family Meeting',
                  //                             style: TextStyle(
                  //                                 color: Colors.white,
                  //                                 fontSize: 20,
                  //                                 fontWeight: FontWeight.w600),
                  //                           ),
                  //                           const SizedBox(
                  //                             height: 20,
                  //                           ),
                  //                           ClipRRect(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(1),
                  //                             child: Stack(
                  //                               children: [
                  //                                 Image.asset(
                  //                                   'assets/images/Map of Birmingham (City).png',
                  //                                 ),
                  //                                 Positioned(
                  //                                     top: 20,
                  //                                     left: 20,
                  //                                     right: 20,
                  //                                     bottom: 20,
                  //                                     child: Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(35.0),
                  //                                       child: SvgPicture.asset(
                  //                                         'assets/icons/location.svg',
                  //                                       ),
                  //                                     )),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           const SizedBox(
                  //                             height: 7,
                  //                           ),
                  //                           const SizedBox(
                  //                             width: 10.0,
                  //                           ),
                  //                           const SizedBox(
                  //                             height: 10.0,
                  //                           ),
                  //                           Container(
                  //                             child: Row(
                  //                               children: [
                  //                                 Column(
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .start,
                  //                                   children: const [
                  //                                     // Text(
                  //                                     //   'Venue',
                  //                                     //   style: TextStyle(
                  //                                     //       fontWeight:
                  //                                     //           FontWeight.w500,
                  //                                     //       fontSize: 13,
                  //                                     //       color: Color(
                  //                                     //           0xFF9D9D9D)),
                  //                                     // ),
                  //                                     // const SizedBox(
                  //                                     //   height: 13,
                  //                                     // ),
                  //                                     // Text(
                  //                                     //   'Categories',
                  //                                     //   style: TextStyle(
                  //                                     //       fontWeight:
                  //                                     //           FontWeight.w500,
                  //                                     //       fontSize: 13,
                  //                                     //       color: Color(
                  //                                     //           0xFF9D9D9D)),
                  //                                     // ),
                  //                                     // const SizedBox(
                  //                                     //   height: 13,
                  //                                     // ),
                  //                                     // Text(
                  //                                     //   'Date',
                  //                                     //   style: TextStyle(
                  //                                     //       fontWeight:
                  //                                     //           FontWeight.w500,
                  //                                     //       fontSize: 13,
                  //                                     //       color: Color(
                  //                                     //           0xFF9D9D9D)),
                  //                                     // ),
                  //                                     SizedBox(
                  //                                       height: 13,
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 Spacer(),
                  //                                 Spacer(),
                  //                                 Column(
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment.end,
                  //                                   children: const [
                  //                                     // Text(
                  //                                     //   'Head Office Training Room',
                  //                                     //   style: TextStyle(
                  //                                     //       fontWeight:
                  //                                     //           FontWeight.w500,
                  //                                     //       fontSize: 14.5,
                  //                                     //       color: Color(
                  //                                     //           0xFF444444)),
                  //                                     // ),
                  //                                     // const SizedBox(
                  //                                     //   height: 13,
                  //                                     // ),
                  //                                     // Text(
                  //                                     //   'Family Meeting',
                  //                                     //   style: TextStyle(
                  //                                     //       fontWeight:
                  //                                     //           FontWeight.w500,
                  //                                     //       fontSize: 14.5,
                  //                                     //       color: Color(
                  //                                     //           0xFF444444)),
                  //                                     // ),
                  //                                     // const SizedBox(
                  //                                     //   height: 13,
                  //                                     // ),
                  //                                     // Text(
                  //                                     //   '14 Oct 2022 8:30 am – 10:00 am',
                  //                                     //   style: TextStyle(
                  //                                     //       fontWeight:
                  //                                     //           FontWeight.w500,
                  //                                     //       fontSize: 14.5,
                  //                                     //       color: Color(
                  //                                     //           0xFF444444)),
                  //                                     // ),
                  //                                     SizedBox(
                  //                                       height: 13,
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Positioned(
                  //                     top: 10,
                  //                     left: 60,
                  //                     right: 60,
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       children: [
                  //                         Container(
                  //                           width: 50,
                  //                           height: 5,
                  //                           decoration: BoxDecoration(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10),
                  //                               color: Color(0xFF8C9DF6)),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ));
                },
                child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Color.fromARGB(255, 221, 231, 220))),
                    child: loading
                        ? Container(
                            child: Column(
                            children: const [
                              Text("Loading..."),
                              CircularProgressIndicator(),
                            ],
                          ))
                        : Column(
                            children: motorWidgetList,
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
