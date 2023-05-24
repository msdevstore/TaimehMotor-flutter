import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arionmotor/views/dashboard/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/payment.dart';
import '../motorcyclelist/all_motorcycle_model.dart';
import 'search.dart';
import 'shop.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late final SharedPreferences prefs;
  var motorcycleLength = 0;
  var statusText = '';
  bool loading = true;
  List<MotorInStoreObject> motorObjects = [];
  List<MotorInStoreObject> tempList = [];
  CollectionReference motors = FirebaseFirestore.instance.collection('motors');
  CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  int _selectedIndex = 2;
  List<String> carts = [];
  String userId = '';
  String motorId = '';
  String username = '';
  String motorImage = '';
  String brand = '';
  String frameNumber = '';
  String mainColor = '';
  String loadCapacitor = '';
  String price = '';
  String rating = '';

  getCarts() async {
    prefs = await SharedPreferences.getInstance();
    carts = prefs.getStringList('carts')!;
    // userId = prefs.getString('uid')!;
    // username = prefs.getString('displayName')!;
    // motorId = prefs.getString('motorId')!;
    // motorImage = prefs.getString('motorImage')!;
    // brand = prefs.getString('brand')!;
    // frameNumber = prefs.getString('frameNumber')!;
    // mainColor = prefs.getString('mainColor')!;
    // loadCapacitor = prefs.getString('loadCapacitor')!;
    // price = prefs.getString('price')!;
    // rating = prefs.getString('rating')!;

    // print("aaaaaaaaaaaaaaaaaa:${userId}");
  }

  getMotorInStoreCycles() async {
    if (loading) {
      tempList = [];
      await motors.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (carts.any((element) => element == doc.id)) {
            print("king:${userId}");
            tempList.add(MotorInStoreObject(
                id: doc.id,
            frameNumber: doc["frameNumber"] ?? 0,
            productionYear: doc["productionYear"] ?? '2023',
            mainColor: doc["mainColor"] ?? 'Red',
            LastUpdate: doc["LastUpdate"] ?? '',
            // status: doc["status"] ?? '',
            featuredImage: doc['featuredImage'] ?? '',
            price: doc['price'] ?? '',
            rating: doc['rating'] ?? '',
            brand: doc['brand'] ?? '',
            loadCapacitor: doc['loadCapacitor'] ?? '',
            type: doc['type'] ?? '',
            EngineNumber: doc['EngineNumber'] ?? '',
            plate_number: doc['plate_number'] ?? '',
            location: doc['location'] ?? ''));
          }
        });
      });
      setState(() {
        motorObjects = tempList;
        loading = false;
        motorcycleLength = motorObjects.length;
      });
    }
  }

  purchaseRequest() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print("motor:${motorId}");
    userId = prefs.getString('uid')!;
    username = prefs.getString('displayName')!;
    motorId = prefs.getString('motorId')!;
    motorImage = prefs.getString('motorImage')!;
    brand = prefs.getString('brand')!;
    frameNumber = prefs.getString('frameNumber')!;
    mainColor = prefs.getString('mainColor')!;
    loadCapacitor = prefs.getString('loadCapacitor')!;
    price = prefs.getString('price')!;
    rating = prefs.getString('rating')!;
    requests.add({
      'status': 'Purchase Requested',
      'user_id': userId,
      'requested_date': formattedDate,
      'motor_id': motorId,
      'username': username,
      'motor_image': motorImage,
      'brand': brand,
      'frameNumber': frameNumber,
      'mainColor': mainColor,
      'loadCapacitor': loadCapacitor,
      'price': price,
      'rating': rating,
      'paymentImage':''
    }).then((value) => {
      print(value.id),
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Payment()),
      ),prefs.setString('requestId', value.id)},);
  }

  @override
  void initState() {
    super.initState();
    getCarts();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Search()),
      );
    } else if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Shop()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 50),
        child: AppBar(
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
                        _key.currentState!.openDrawer();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/menu.svg',
                        width: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 14.0,
                    ),
                    const Text(
                      'Cart',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF3FC729),
          elevation: 0.8,
          shadowColor: Colors.grey.withOpacity(0.3),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16.0,
            ),
            FutureBuilder(
                future: getMotorInStoreCycles(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      loading == true) {
                    return Center(
                        child: Column(
                      children: const [
                        Text("Loading..."),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ));
                  } else {
                    return Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 2,
                                  mainAxisSpacing: 10),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            print("length:${motorObjects.length}");
                            if (motorObjects.length > index) {
                              var data = motorObjects[index];
                              if (data != null) {
                                if (true) {
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25)),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  350,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        width: double.maxFinite,
                                                        height: 90,
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25)),
                                                            color: Color(
                                                                0xFF3FC729)),
                                                      ),
                                                      Container(
                                                        width: double.maxFinite,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            data.featuredImage
                                                                    .isNotEmpty
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            26),
                                                                    child: Image
                                                                        .network(
                                                                      data.featuredImage
                                                                          .toString(),
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          200,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                            const SizedBox(
                                                              height: 7,
                                                            ),
                                                            Text(
                                                              'Production Year:  ${data.productionYear}',
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF333333),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            const SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            const SizedBox(
                                                              height: 10.0,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.6,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            data.brand != false
                                                                                ? 'Brand:  ${data.brand}'
                                                                                : 'Brand:  ',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.frameNumber != false
                                                                                ? 'Frame Number: ${data.frameNumber}'
                                                                                : 'Frame Number',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.loadCapacitor != false
                                                                                ? 'Load Capacitor: ${data.loadCapacitor}'
                                                                                : 'Load Capacitor',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.type != false
                                                                                ? 'Type: ${data.type}'
                                                                                : 'Type',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.EngineNumber != false
                                                                                ? 'Engine Number: ${data.EngineNumber}'
                                                                                : 'Engine Number',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.plate_number != false
                                                                                ? 'Plate Number: ${data.plate_number}'
                                                                                : 'Plate Number',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.location != false
                                                                                ? 'Location: ${data.location}'
                                                                                : 'Location',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data.LastUpdate != false
                                                                                ? 'Last Update: ${data.LastUpdate}'
                                                                                : 'Last Update',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15,
                                                                                color: Color(0xFF444444)),
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
                                                      Positioned(
                                                        top: 10,
                                                        left: 60,
                                                        right: 60,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 5,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: const Color(
                                                                      0xFF8C9DF6)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10,left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 190, 189, 189),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 16),
                                          child: carts.contains(data.id)
                                              ? Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: const Color(
                                                            0xFF3FC729),
                                                      ),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0,
                                                          horizontal: 16),
                                                      child: Text(
                                                        "${data.brand}  ${data.frameNumber}  ${data.mainColor}  ${data.loadCapacitor}",
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: data
                                                                    .featuredImage
                                                                    .isNotEmpty
                                                                ? Image.network(
                                                                    data.featuredImage
                                                                        .toString(),
                                                                    width: 90,
                                                                    height: 70,
                                                                  )
                                                                : const SizedBox(
                                                                    height:
                                                                        50)),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Price:   ${data.price}\$',
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF555555),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 22),
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                    'Rating '),
                                                                RatingBarIndicator(
                                                                  rating: double
                                                                      .parse(data
                                                                          .rating),
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  itemSize: 25,
                                                                  itemCount: 5,
                                                                  itemPadding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          0.0),
                                                                  itemBuilder:
                                                                      (context,
                                                                              _) =>
                                                                          const Icon(
                                                                    Icons.star,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            52,
                                                                            202,
                                                                            52,
                                                                            1),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '(${data.rating})',
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF707070),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          18),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            List<String>
                                                                temp_carts = [];
                                                            temp_carts = carts;
                                                            temp_carts.remove(
                                                                data.id);
                                                            setState(() {
                                                              carts =
                                                                  temp_carts;
                                                            });
                                                            prefs.setStringList(
                                                                'carts', carts);
                                                          },
                                                          child: Image.asset(
                                                              'assets/icons/cart_minus.png'),
                                                        ),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            List<String>
                                                                temp_carts = [];
                                                            List<MotorInStoreObject>
                                                                tempList = [];
                                                            temp_carts = carts;
                                                            temp_carts.remove(
                                                                data.id);
                                                            motorObjects
                                                                .forEach(
                                                                    (element) {
                                                              if (temp_carts
                                                                  .contains(
                                                                      element
                                                                          .id)) {
                                                                tempList.add(
                                                                    element);
                                                              }
                                                            });
                                                            setState(() {
                                                              carts =
                                                                  temp_carts;
                                                              motorObjects =
                                                                  tempList;
                                                            });
                                                            prefs.setStringList(
                                                                'carts', carts);
                                                            prefs.setString(
                                                                'motorId',
                                                                data.id);
                                                            prefs.setString(
                                                                'motorImage',
                                                                data.featuredImage);
                                                            prefs.setString(
                                                                'brand',
                                                                data.brand);
                                                            prefs.setString(
                                                                'frameNumber',
                                                                data.frameNumber);
                                                            prefs.setString(
                                                                'mainColor',
                                                                data.mainColor);
                                                            prefs.setString(
                                                                'loadCapacitor',
                                                                data.loadCapacitor);
                                                            prefs.setString(
                                                                'price',
                                                                data.price);
                                                            prefs.setString(
                                                                'rating',
                                                                data.rating);
                                                            
                                                            purchaseRequest();
                                                            
                                                          },
                                                          child: Image.asset(
                                                              'assets/icons/pay_btn.png'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              : Container()),
                                    ),
                                  );
                                // ignore: dead_code
                                } else {
                                }
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          })
                    ]);
                  }
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
