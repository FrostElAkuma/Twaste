import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:twaste/my_pages/account/account_page.dart';
import 'package:twaste/my_pages/auth/sign_up_page.dart';
import 'package:twaste/my_pages/cart/cart_history_page.dart';
import 'package:twaste/my_pages/home/main_page.dart';
import 'package:twaste/my_pages/order/order_page.dart';

import '../auth/sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  List pages = [
    MainPage(),
    OrderPage(),
    CartHistory(),
    AccountPage(),
  ];

  void onTapNav(int i) {
    //To trigger UI change we need to use set state
    setState(() {
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.amber,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //This so we can keep track of which index we are in thys changing the icon glows
        currentIndex: _index,
        //We need a parameter of int index for onTapNav but apparently flutter will do if for us
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive,
            ),
            label: 'history',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'me',
          )
        ],
      ),
    );
  }
}
