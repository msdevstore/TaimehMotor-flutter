import 'dart:async';
import 'package:arionmotor/views/motorcyclelist/add_motor.dart';
import 'package:arionmotor/views/motorcyclelist/edit_info.dart';
import 'package:arionmotor/views/motorcyclelist/produce_motor.dart';
import 'package:arionmotor/views/motorcyclelist/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'all_motorcycle_model.dart';
import 'apply_filter.dart';

class MortorCycleList extends StatefulWidget {
  final status ;
  const MortorCycleList({Key? key,this.status}) : super(key: key);
  @override
  State<MortorCycleList> createState() => _MortorCycleListState();
}

class _MortorCycleListState extends State<MortorCycleList> {

  TextEditingController searchController = TextEditingController();
  late StreamController streamController;
  late Stream stream;
  List<MotorCycleObject?> AllMotorCycle = <MotorCycleObject?>[];
  CollectionReference  motors = FirebaseFirestore.instance.collection('motors');

  var motorcycleLength = 0;
  var statusText = '';
  bool loading = true;
  List<MotorCycleObject> motorObjects = [];
  List<MotorCycleObject> tempList = [];

  getMortorCycles() async{
    if(loading) {
      tempList = [];
      await motors
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if(doc['status'] == widget.status || widget.status.isEmpty) {
            tempList.add(
              MotorCycleObject(
                  id:doc.id,
                  frameNumber: doc["frameNumber"] ?? 0,
                  productionYear: doc["productionYear"] ?? '2023',
                  mainColor: doc["mainColor"] ?? 'Red',
                  status: doc["status"] ?? '',
                  featuredImage: doc['featuredImage'] ?? ''
              )
          );
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
  Future<void> deleteMotor(id) {
    return motors
        .doc(id)
        .delete()
        .then((value) =>
    {
      print("User Deleted"),
      Fluttertoast.showToast(msg: "Motor deleted successfully!"),
    }
    )
        .catchError((error) => {
      print("Failed to delete user: $error"),
      Fluttertoast.showToast(msg: "Motor deleted error!"),
    });
  }
  @override
  void initState()
  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 132),
        child: AppBar(
          flexibleSpace: Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CommonTextFieldWithTitle(
                            '',
                            'Search by frameNumber',
                            searchController,
                                (val) {
                            },
                            onChanged: (val) {
                              statusText = val!;
                            },
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  loading = true;
                                });
                              },
                              child:const Icon(Icons.search),
                            )
                        ),
                      ),
                      // TextFormField(
                      //   controller: searchController,
                      //
                      //   decoration: InputDecoration(
                      //
                      //
                      //     fillColor: const Color(0xFFEDF0FF),
                      //     contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      //     onChanged: (val) {
                      //       setState(() {});
                      //     },
                      //     prefixIcon: Padding(
                      //       padding: const EdgeInsets.all(16.0),
                      //       child: SvgPicture.asset('assets/icons/search.svg',
                      //           width: 16, color: const Color(0xFF8E8E8E)),
                      //     ),
                      //     hintText: 'Search by statusText',
                      //     hintStyle:
                      //         const TextStyle(color: Color(0xFF8E8E8E), fontSize: 15),
                      //     filled: true,
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide.none,
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      // ),
                    ),
                    const SizedBox(
                      width: 14.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApplyFilter(statusText: searchController.text,)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.orange,
                        ),
                        child: SvgPicture.asset('assets/icons/filter.svg'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/east.svg',
                        width: 20,
                        color: const Color(0xff3F3F3F),
                      ),
                    ),
                    const SizedBox(
                      width: 14.0,
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
      ),
      body:Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                FutureBuilder(
                    future: getMortorCycles(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting && loading == true) {
                        return  Center(
                            child: Column(
                              children: const [
                                Text("Loading..."),
                                SizedBox(
                                  height: 20,
                                ),
                                CircularProgressIndicator(),
                              ],
                            ));
                      }else {
                        return Column(
                            children:
                            [
                              Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child:
                                  widget.status==''?
                                  Text(
                                    'All MotorCycles (${motorcycleLength.toString()})',
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.5),
                                  )
                                      : Text(
                                    ' ${widget.status} Motors:(${motorcycleLength.toString()})',
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.5),)
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 10),
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    print("length:${motorObjects.length}");
                                    if(motorObjects.length>index){
                                      var data = motorObjects[index];
                                      if (data != null) {
                                        if (data.frameNumber.toString()
                                            .toLowerCase()
                                            .contains(
                                            searchController.text.toLowerCase())) {
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
                                                      height:
                                                      MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height - 350,
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
                                                                    borderRadius: BorderRadius
                                                                        .only(
                                                                        topLeft: Radius
                                                                            .circular(25),
                                                                        topRight:
                                                                        Radius.circular(
                                                                            25)),
                                                                    color: Colors.orange),
                                                              ),
                                                              Container(
                                                                width: double.maxFinite,
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    data.featuredImage.isNotEmpty?
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(26),
                                                                      child: Image
                                                                          .network(
                                                                        data.featuredImage
                                                                            .toString(),
                                                                        width: 200,
                                                                        height: 200,
                                                                      ),
                                                                    ):Container(),
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
                                                                          horizontal: 5),
                                                                      child: Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal: 5),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width*0.6,
                                                                              child:Column(
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    data.mainColor!= false? 'Frame Number:  ${data.frameNumber}':'FrameNumber:  ',
                                                                                    style: const TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w500,
                                                                                        fontSize: 15,
                                                                                        color: Color(
                                                                                            0xFF444444)),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                   data.mainColor!= false? 'Main Color:  ${data.mainColor}':'Main Color:  ',
                                                                                    style: const TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w500,
                                                                                        fontSize: 15,
                                                                                        color: Color(
                                                                                            0xFF444444)),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    data.status != false?
                                                                                    'Status: ${data.status}': 'Status',
                                                                                    style: const TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w500,
                                                                                        fontSize: 15,
                                                                                        color: Color(
                                                                                            0xFF444444)),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Spacer(),
                                                                        FloatingActionButton(
                              heroTag: null,
                                                                          backgroundColor: Colors.orange,
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                            deleteMotor(data.id);
                                                                            setState(() {
                                                                              loading = true;
                                                                            });
                                                                          },
                                                                          child: const Icon(Icons.delete),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        FloatingActionButton(
                              heroTag: null,
                                                                          backgroundColor: Colors.orange,
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => EditMotor(id:data.id)));
                                                                          },
                                                                          child: const Icon(Icons.edit),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        )
                                                                      ],
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
                                              // height: 300,
                                              // width: 250,
                                              margin: const EdgeInsets.only(right: 10,),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: const Color(0xFFDEDEDE),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 5.0, horizontal: 16),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(
                                                          8),
                                                      child: data.featuredImage.isNotEmpty? Image.network(
                                                        data.featuredImage.toString(),
                                                        width: 90,
                                                        height: 70,
                                                      ):const SizedBox(
                                                        height:50
                                                      )
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      data.frameNumber,
                                                      style: const TextStyle(
                                                          color: Color(0xFF333333),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      'Production Year:   ${data.productionYear}',
                                                      style: const TextStyle(
                                                          color: Color(0xFF555555),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      'Main Color:   ${data.mainColor}',
                                                      style: const TextStyle(
                                                          color: Color(0xFF707070),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      'Status:   ${data.status}',
                                                      style: const TextStyle(
                                                          color: Color(0xFF707070),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }
                                      else{
                                        return Container();
                                      }}
                                    else{
                                      return Container();
                                    }
                                  }
                              )
                            ]
                        );
                      }
                    }
                ),
              ],
            ),
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProduceMotor()));
                },
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange,
                    ),
                    child: const Text('Produce New', style: TextStyle( fontSize: 20, color: Colors.white),)
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMortor()));
                },
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange,
                    ),
                    child: const Text('Add Existing', style: TextStyle( fontSize: 20, color:Colors.white),)
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}


