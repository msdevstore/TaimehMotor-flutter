import 'maintenances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'purchase.dart';
import 'pre_orders.dart';
import 'shop_sales.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
          length: 4,
          child: Scaffold(
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
                          const Text(
                            "Requests",
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
                bottom: const TabBar(
                    isScrollable: true,
                    indicatorWeight: 3,
                    unselectedLabelColor: Color(0xFF333333),
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                    ),
                    labelColor: Color(0xFF243690),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    indicatorColor: Color(0xFF243690),
                    tabs: [
                      Tab(
                        text: 'Maintain Requested',
                      ),
                      Tab(
                        text: 'Purchase Requested',
                      ),
                      Tab(
                        text: 'Pre Orders',
                      ),
                      Tab(
                        text: 'Shop Sales',
                      ),
                    ])),
            body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 22),
                child:
                 TabBarView(
                    children: [
                      Maintenances(),
                      PreOrders(),
                      Purchases(),
                      ShopSales()
                    ])
            ),
          ));
  }
}
