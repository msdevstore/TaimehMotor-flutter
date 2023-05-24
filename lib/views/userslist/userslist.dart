import 'dart:async';
import 'package:arionmotor/views/motorcyclelist/text_field.dart';
import 'package:arionmotor/views/userslist/create_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'user_model.dart';
import 'apply_filter.dart';

class UserList extends StatefulWidget {
  final role ;
  const UserList({Key? key,this.role}) : super(key: key);
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  TextEditingController searchController = TextEditingController();
  late StreamController streamController;
  late Stream stream;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  var userLength = 0;
  var roleText = '';
  bool loading = true;
  List<UserObject> userObjects = [];
  List<UserObject> tempList = [];

  getUsers() async{
    if(loading) {
      tempList = [];
      await users
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if(doc['role'].isEmpty ||doc['role'] == widget.role || widget.role.isEmpty) {
              tempList.add(
                  UserObject(
                      id:doc.id,
                      name: doc["name"] ?? '',
                      jobTitle: doc["jobTitle"] ?? '',
                      email: doc["email"] ?? '',
                      role: doc["role"] ?? '',
                      featuredImage: doc['featuredImage'] ?? ''
                  )
              );
          }
        });
      });
      setState(() {
        userObjects = tempList;
        loading = false;
        userLength = userObjects.length;
      });
    }
  }
  Future<void> deleteUser(id) {
    return users
        .doc(id)
        .delete()
        .then((value) =>
        {
          print("User Deleted"),
          Fluttertoast.showToast(msg: "User deleted successfully!"),
        }
    )
        .catchError((error) => {
          print("Failed to delete user: $error"),
          Fluttertoast.showToast(msg: "User deleted error!"),
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
                            'Search by name',
                            searchController,
                                (val) {
                            },
                            onChanged: (val) {
                              roleText = val!;
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
                    ),
                    const SizedBox(
                      width: 14.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApplyFilter(roleText: searchController.text,)));
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
                    future: getUsers(),
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
                                  widget.role==''?
                                  Text(
                                    'All Users (${userLength.toString()})',
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.5),
                                  )
                                      : Text(
                                    ' ${widget.role} Users:(${userLength.toString()})',
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
                                    print("length:${userObjects.length}");
                                    if(userObjects.length>index){
                                      var data = userObjects[index];
                                      if (data != null) {
                                        if (data.name.toString()
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
                                                                    ):Container(
                                                                      margin: const EdgeInsets.only(top:30),
                                                                      child:CircleAvatar(
                                                                          backgroundColor: Colors.transparent,
                                                                          radius: 30,
                                                                          child: SvgPicture.asset(
                                                                            'assets/img/avatar.svg',
                                                                            width: double.maxFinite,
                                                                            height: double.maxFinite,
                                                                          )),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 7,
                                                                    ),
                                                                    Text(
                                                                      'Name:  ${data.name}',
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
                                                                              width: MediaQuery.of(context).size.width*0.8,
                                                                              child:Column(
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment
                                                                                    .center,
                                                                                children: [
                                                                                  Text(
                                                                                    data.name!= false? 'Job Title:  ${data.jobTitle}':'JOb Title:  ',
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
                                                                                    data.email!= false? 'Email:  ${data.email}':'Email:  ',
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
                                                                                    data.role != false?
                                                                                    'Role: ${data.role}': 'Role',
                                                                                    style: const TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w500,
                                                                                        fontSize: 15,
                                                                                        color: Color(
                                                                                            0xFF444444)),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Spacer(),
                                                                                      Container(
                                                                                        child: FloatingActionButton(
                                                                                          backgroundColor: Colors.orange,
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                            deleteUser(data.id);
                                                                                            setState(() {
                                                                                              loading = true;
                                                                                            });
                                                                                          },
                                                                                          child: const Icon(Icons.delete),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
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
                                                        ):Container(
                                                          margin: const EdgeInsets.only(top:10),
                                                          child:CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              radius: 30,
                                                              child: SvgPicture.asset(
                                                                'assets/img/avatar.svg',
                                                                width: double.maxFinite,
                                                                height: double.maxFinite,
                                                              )),
                                                        )
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      data.name,
                                                      style: const TextStyle(
                                                          color: Color(0xFF333333),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      '${data.jobTitle}',
                                                      style: const TextStyle(
                                                          color: Color(0xFF555555),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      '${data.email}',
                                                      style: const TextStyle(
                                                          color: Color(0xFF707070),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      '${data.role}',
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateUser()));
        },
        backgroundColor: Colors.orange,
        child: const Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),),
      ),
    );
  }
}


