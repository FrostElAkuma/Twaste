import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/utils/dimensions.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

//This ticker provider so we can use vsync in  our tabcontroller
class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();
    //If he is NOT logged in no need to have the tabcontroller we will just show the sign in to your account page
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, vsync: this);
      //Get.find<OrderController>().getOrderList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My orders",
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: [
        Container(
          width: Dimensions.screenWidth,
          child: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            controller: _tabController,
            tabs: [
              Tab(
                text: "Current",
              ),
              Tab(
                text: "History",
              ),
            ],
          ),
        )
      ]),
    );
  }
}
