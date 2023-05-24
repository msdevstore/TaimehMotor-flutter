import 'package:arionmotor/views/dashboard/widget/custom_drawer.dart';
import 'package:arionmotor/views/dashboard/widget/reuseable_container.dart';
import 'package:arionmotor/views/dashboard/widget/reuseable_container_svg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../financial.dart';
import '../motorcyclelist/motorcycleslist.dart';
import '../requests/requests.dart';
import '../shop/shop.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../userslist/userslist.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  late SharedPreferences preferences;
  @override
  List<Widget> imgList= [
    Image.asset(
      'assets/img/motor1.jpeg',
      fit: BoxFit.fill,
    ),
    Image.asset(
      'assets/img/motor2.jpeg',
      fit: BoxFit.fill,
    ),
    Image.asset(
      'assets/img/motor3.jpeg',
      fit: BoxFit.fill,
    ),
    Image.asset(
      'assets/img/motor4.jpeg',
      fit: BoxFit.fill,
    ),
  ];
    void initState(){
  }
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.orange,
          centerTitle: true,
          // leading: Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: SvgPicture.asset(
          //     'assets/icons/filter.svg',
          //   ),
          // ),
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child:const Text(
                  'TAIMEH MOTORS',
                  style: TextStyle(
                    fontSize: 24
                  ),
                )
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  height: 125.0,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(70.0),
                          bottomRight: Radius.circular(70.0)),
                      color: Colors.orange),
                ),
                Positioned(
                    bottom: -75,
                    child: SizedBox(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        onPageChanged: (index) {
                          currentIndex = index;
                          setState(() {});
                        },
                        controller: PageController(
                            initialPage: 0, viewportFraction: 0.92),
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius
                                  .circular(26),
                              child: imgList[index]
                              ),
                            ),
                        ),
                      ),
                    )
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
            DotsIndicator(
              dotsCount: 4,
              position: currentIndex.toDouble(),
              decorator: DotsDecorator(
                  color: const Color(0xFFA4A4A4).withOpacity(0.44),
                  activeColor: Colors.orange,
                  activeSize: const Size(15.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  spacing: const EdgeInsets.all(2.5)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MortorCycleList(status:'')));
                          },
                          child: const ReusableContainer(
                            iconUrl: 'assets/icons/motors.png',
                            title: 'MotorCycles',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Shop()));
                          },
                          child: const ReusableContainer(
                            iconUrl: 'assets/icons/shop.png',
                            title: 'Shop',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Requests()));
                          },
                          child: const ReusableContainer(
                            iconUrl: 'assets/icons/request.png',
                            title: 'Requests',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Financial()));
                          },
                          child: const ReusableContainer(
                            iconUrl: 'assets/icons/finance.png',
                            title: 'Financial',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            preferences = await SharedPreferences.getInstance();
                            var accountType = preferences.getString('accountType')!;
                            print(accountType);
                            if(accountType == 'admin') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserList(role: '',)));
                            }else{
                              Fluttertoast.showToast(msg:
                                  'You have no right to access. Only Administrator can access');
                            }
                          },
                          child: const ReusableContainerSvg(
                            iconUrl: 'assets/icons/Group.svg',
                            title: 'UserList',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
