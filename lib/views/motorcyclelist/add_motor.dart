import 'dart:async';
import 'package:arionmotor/views/motorcyclelist/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'all_motorcycle_model.dart';

class AddMortor extends StatefulWidget {

  const AddMortor({Key? key,}) : super(key: key);
  @override
  State<AddMortor> createState() => _AddMortorState();
}

class _AddMortorState extends State<AddMortor> {

  TextEditingController searchController = TextEditingController();
  late StreamController streamController;
  late Stream stream;
  CollectionReference  motors = FirebaseFirestore.instance.collection('motors');

  var motorcycleLength = 0;
  var statusText = '';
  bool loading = true;
  List<ClickableMotorCycleObject> motorObjects = [];
  List<ClickableMotorCycleObject> tempList = [];

  getMortorCycles() async{
    if(loading) {
      tempList = [];
      await motors
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if(doc['status'] == 'In Production') {
            tempList.add(
                ClickableMotorCycleObject(
                    id:doc.id,
                    frameNumber: doc["frameNumber"] ?? 0,
                    productionYear: doc["productionYear"] ?? '2023',
                    mainColor: doc["mainColor"] ?? 'Red',
                    status: doc["status"] ?? '',
                    featuredImage: doc['featuredImage'] ?? '',
                    click: false
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

  Future<void> updateMotor(id) {
    return motors
        .doc(id)
        .update({'status': 'In Store'})
        .then((value) => print("Motor Updated"))
        .catchError((error) => print("Failed to update motor status: $error"));
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
        preferredSize: Size(MediaQuery.of(context).size.width, 130),
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
                                  Text(
                                    'In Production MotorCycles (${motorcycleLength.toString()})',
                                    style: const TextStyle(
                                        color: Color(0xFF243690),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.5),
                                  ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
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
                                              print(motorObjects[index].click);
                                              print(!motorObjects[index].click);
                                              List<ClickableMotorCycleObject> tempList = [];
                                              tempList = motorObjects;
                                              tempList[index].click = !motorObjects[index].click;
                                              setState(() {
                                                motorObjects= tempList;
                                              });
                                            },
                                            child: Container(
                                              // height: 300,
                                              // width: 250,
                                              margin: const EdgeInsets.only(right: 10,),
                                              decoration: BoxDecoration(
                                                color: motorObjects[index].click?  const Color(0xFFDEDEDE): Colors.white,
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
          const SizedBox(
            height: 20,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
        ),
        onPressed: () {
          // Add your onPressed code here!
          var number;
          motorObjects.forEach((element) {
            if(element.click == true){
              updateMotor(element.id);
            }
          });
          setState(() {
            Fluttertoast.showToast(msg: '$number motors status updated!');
            loading = true;
          });
        },
        backgroundColor: Colors.orange,
        child: const Text('+', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),),
      ),
    );
  }
}


