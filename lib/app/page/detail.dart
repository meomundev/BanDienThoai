import 'dart:convert';

import 'package:app_api/app/page/info_user/detailUser.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppGrey,
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildFormAvatar(),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildFormInfomation(),
                  _buildFormEdit(),
                  _buildFormHelp(),
                  const SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
            // Image(
            //   image: NetworkImage(user.imageURL!),
            //   height: 200,
            //   width: 200,
            // ),
            // Text("NumberID: ${user.idNumber}", style: mystyle),
            // Text("Fullname: ${user.fullName}", style: mystyle),
            // Text("Phone Number: ${user.phoneNumber}", style: mystyle),
            // Text("Gender: ${user.gender}", style: mystyle),
            // Text("birthDay: ${user.birthDay}", style: mystyle),
            // Text("schoolYear: ${user.schoolYear}", style: mystyle),
            // Text("schoolKey: ${user.schoolKey}", style: mystyle),
            // Text("dateCreated: ${user.dateCreated}", style: mystyle),
          ]),
        ),
      ),
    );
  }

  Widget _buildFormAvatar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [blueDark, mainAppGrey]),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: mainAppWhite,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                // child: Image.asset(
                //   "assets/images/debug.jpg",
                //   fit: BoxFit.cover,
                // ),
                child: Image(
                  image: NetworkImage(user.imageUrl!),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormInfomation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Information',
          style: TextStyle(
            color: blueDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: mainAppWhite, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '${user.fullName}',
                    style: TextStyle(
                      color: mainAppBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${user.idNumber}',
                    style: TextStyle(
                      color: greyColorForText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Phone Number',
                    style: TextStyle(
                        fontSize: 16,
                        color: orangeLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${user.phoneNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainAppBlack,
                    ),
                  ),
                ],
              ),
              Divider(
                color: greyDivier,
              ),
              Row(
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                        fontSize: 16,
                        color: orangeLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${user.gender}',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainAppBlack,
                    ),
                  ),
                ],
              ),
              Divider(
                color: greyDivier,
              ),
              Row(
                children: [
                  Text(
                    'Birthday',
                    style: TextStyle(
                        fontSize: 16,
                        color: orangeLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${user.birthDay}',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainAppBlack,
                    ),
                  ),
                ],
              ),
              Divider(
                color: greyDivier,
              ),
              Row(
                children: [
                  Text(
                    'School Year',
                    style: TextStyle(
                        fontSize: 16,
                        color: orangeLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${user.schoolYear}',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainAppBlack,
                    ),
                  ),
                ],
              ),
              Divider(
                color: greyDivier,
              ),
              Row(
                children: [
                  Text(
                    'School Key',
                    style: TextStyle(
                        fontSize: 16,
                        color: orangeLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${user.schoolKey}',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainAppBlack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFormEdit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Settings',
          style: TextStyle(
            color: blueDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: mainAppWhite, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserProfileSettings(),
              _buildAccountManagement(),
              _buildNotificationSettings(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildUserProfileSettings() {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return blueDarkO5;
                }
                return mainAppWhite;
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return mainAppWhite;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
            surfaceTintColor:
                MaterialStateColor.resolveWith((states) => mainAppWhite)),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: orangeLight,
              size: 24,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Information',
              style: TextStyle(fontSize: 16, color: mainAppBlack),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 24,
              color: orangeLight,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountManagement() {
    return OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return blueDarkO5;
                }
                return mainAppWhite;
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return mainAppWhite;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
            surfaceTintColor:
                MaterialStateColor.resolveWith((states) => mainAppWhite)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetailUser()),
            );
          },
          child: Row(
            children: [
              Icon(
                Typicons.business_card,
                color: orangeLight,
                size: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Account/card management',
                style: TextStyle(fontSize: 16, color: mainAppBlack),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 24,
                color: orangeLight,
              )
            ],
          ),
        ));
  }

  Widget _buildNotificationSettings() {
    return OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return blueDarkO5;
              }
              return mainAppWhite;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return mainAppWhite;
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
          surfaceTintColor:
              MaterialStateColor.resolveWith((states) => mainAppWhite)),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: orangeLight,
            size: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Notification settings',
            style: TextStyle(fontSize: 16, color: mainAppBlack),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 24,
            color: orangeLight,
          )
        ],
      ),
    );
  }

  Widget _buildFormHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Help',
          style: TextStyle(
            color: blueDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: mainAppWhite, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpCenter(),
              _buildApplicationInformation(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHelpCenter() {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return blueDarkO5;
                }
                return mainAppWhite;
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return mainAppWhite;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
            surfaceTintColor:
                MaterialStateColor.resolveWith((states) => mainAppWhite)),
        child: Row(
          children: [
            Icon(
              Icons.help_outline_outlined,
              color: orangeLight,
              size: 24,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Help center',
              style: TextStyle(fontSize: 16, color: mainAppBlack),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 24,
              color: orangeLight,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationInformation() {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return blueDarkO5;
                }
                return mainAppWhite;
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return mainAppWhite;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
            surfaceTintColor:
                MaterialStateColor.resolveWith((states) => mainAppWhite)),
        child: Row(
          children: [
            Icon(
              Icons.app_shortcut,
              color: orangeLight,
              size: 24,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'General',
              style: TextStyle(fontSize: 16, color: mainAppBlack),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 24,
              color: orangeLight,
            )
          ],
        ),
      ),
    );
  }
}
