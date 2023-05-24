import 'package:arionmotor/views/requests/request_object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Maintenances extends StatefulWidget {
  const Maintenances({super.key});

  @override
  State<Maintenances> createState() => _Maintenances();
}

class _Maintenances extends State<Maintenances> {

  bool loading = true;
  CollectionReference  requests = FirebaseFirestore.instance.collection('requests');
  CollectionReference  motors = FirebaseFirestore.instance.collection('motors');
  List<RequestObject> requestList = [];
  List<Widget> requestWidgetList = [];
  List<RequestObject> tempList = [];


  getRequestList() async {
    if (loading) {
      tempList = [];
      await requests
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          if (doc['type'] == 'maintain') {
            String motor_id='';
            String img = '';
            motor_id = doc['motor_id'];
            print(motor_id);
            await motors
                .doc(motor_id)
                .get()
                .then((DocumentSnapshot documentSnapshot){
              if (documentSnapshot.exists) {
                Map data = (documentSnapshot.data() as Map);
                (data).forEach((key, value) {
                  if(key == 'featuredImage'){
                    print(value);
                    img = value;
                  }
                });
              }
              else{
                // Fluttertoast.showToast(msg: 'Motor Data does not exist!');
              }
              tempList.add(
                  RequestObject(
                      id: doc.id,
                      request_date: doc["request_date"] ?? '2023-03-01',
                      type: doc["type"] ?? '',
                      user_id: doc["user_id"] ?? '',
                      username: doc['username']?? '',
                      img: img
                  )
              );
              setState(() {
                requestList = tempList;
                loading = false;
              });
            });
          }
        });
      });
    }
  }

  void initState(){
    getRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(child: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const SizedBox(
            height: 20,
          ),
          loading? Container():
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10),
              itemCount: 10,
              itemBuilder: (context, index) {
                if(requestList.length>index){
                  var data = requestList[index];
                  if (data != null) {
                    if (true) {
                      return
                        Container(
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
                            child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ClipRect(
                                  //   child: (data.img.isNotEmpty || data.img != '')? Image.network(
                                  //       data.img):Container()
                                  // ),
                                  Column(
                                    children: [
                                      Text(
                                        data.username,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        'User Name:  ${data.username}',
                                        style: const TextStyle(
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        'Requested Date:   ${data.request_date}',
                                        style: const TextStyle(
                                            color: Color(0xFF707070),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        'Motor: ${data.motor_id}',
                                        style: const TextStyle(
                                            color: Color(0xFF707070),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
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
        ])
    ))
    ]
    );
  }
}
