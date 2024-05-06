import 'dart:convert';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/category/category_list.dart';
import 'package:app_api/app/page/detail.dart';
import 'package:app_api/app/page/history/orderHistory.dart';
import 'package:app_api/app/page/home.dart';
import 'package:app_api/app/page/info_user/detailUser.dart';
import 'package:app_api/app/page/premium.dart';
import 'package:app_api/app/page/product/product_cart.dart';
import 'package:app_api/app/page/product/product_list.dart';
import 'package:app_api/app/page/scanQR.dart';
import 'package:app_api/app/route/page1.dart';
import 'package:app_api/app/route/page2.dart';
import 'package:app_api/app/route/page3.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  final int? selectedCategory;
  const Mainpage({Key? key, this.selectedCategory});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  bool _isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _closeDrawer(int index) {
    setState(() {
      _scaffoldKey.currentState?.closeDrawer();
      _selectedIndex = index;
    });
  }

  static int? _selectedCategory;
  String appBarTitle = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
    print(user.imageUrl);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "Home";
    switch (index) {
      case 0:
        {
          return const CategoryList();
        }
      case 1:
        {
          return ProductList(catID: _selectedCategory);
        }
      case 2:
        nameWidgets = "ScanQR";
        break;
      case 3:
        {
          return const ProductCart();
        }
      case 4:
        {
          return const Detail();
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainAppWhite,
        ),
        backgroundColor: blueDark,
        title: Text(
          "HL Mobile",
          style: TextStyle(color: orangeLight, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: blueDark,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // user.imageURL!.length < 5
                  //     ? const SizedBox()
                  //     : CircleAvatar(
                  //         radius: 40,
                  //         backgroundImage: NetworkImage(
                  //           user.imageURL!,
                  //         )),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        // child: Image.asset(
                        //   "assets/images/debug.jpg",
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image(
                          image: NetworkImage(user.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    user.fullName!,
                    style: TextStyle(color: mainAppWhite),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: orangeLight,
                size: 28,
              ),
              title: Text('Home',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(
                Icons.phone_android,
                color: orangeLight,
                size: 28,
              ),
              title: Text('Product',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 1;
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_bag_outlined,
                color: orangeLight,
                size: 28,
              ),
              title: Text('Cart',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 3;
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline_outlined,
                color: orangeLight,
                size: 28,
              ),
              title: Text('User',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 4;
                setState(() {});
              },
            ),
            Divider(
              color: blueDark,
            ),
            ListTile(
              leading: Icon(
                Icons.history,
                color: orangeLight,
                size: 28,
              ),
              title: Text('History',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderHistory()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: orangeLight,
                size: 28,
              ),
              title: Text('Manage Profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DetailUser()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.pages,
                color: orangeLight,
                size: 28,
              ),
              title: Text('Page3',
                  style: TextStyle(
                    fontSize: 16,
                    color: mainAppBlack,
                  )),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Page3()));
              },
            ),
            Divider(
              color: blueDark,
            ),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: orangeLight,
                      size: 28,
                    ),
                    title: Text('Logout',
                        style: TextStyle(
                          fontSize: 16,
                          color: mainAppBlack,
                        )),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 32,
              color: greyLightColor,
            ),
            activeIcon: Icon(
              Icons.home_outlined,
              size: 32,
              color: blueDark,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.phone_android,
              size: 32,
              color: greyLightColor,
            ),
            activeIcon: Icon(
              Icons.phone_android,
              size: 32,
              color: blueDark,
            ),
            label: 'Product',
          ),
          BottomNavigationBarItem(
              icon: Container(
                height: 18,
              ),
              label: 'Scan QR'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: greyLightColor,
            ),
            activeIcon: Icon(
              Icons.shopping_bag_outlined,
              size: 32,
              color: blueDark,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 32,
              color: greyLightColor,
            ),
            activeIcon: Icon(
              Icons.person_outline,
              size: 32,
              color: blueDark,
            ),
            label: 'User',
          ),
        ],
        selectedFontSize: 12,
        currentIndex: _selectedIndex,
        unselectedItemColor: greyLightColor,
        selectedItemColor: blueDark,
        backgroundColor: mainAppWhite,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: blueDark,
          borderRadius: BorderRadius.circular(28),
        ),
        child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ScanQR()));
            },
            icon: Icon(
              Icons.qr_code_outlined,
              size: 32,
              color: mainAppWhite,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _loadWidget(_selectedIndex),
    );
  }
}
