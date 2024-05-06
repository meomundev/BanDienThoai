import 'package:app_api/other/color.dart';
import 'package:app_api/other/text.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainAppGrey,
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/premiumImage.jpg',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      backgroundColor: transparentColor,
                      title: Text(
                        'Premium',
                        style: TextStyle(
                          color: mainAppBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      elevation: 0,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BEAT BUDDY PREMIUM',
                          style: TextStyle(
                            fontSize: 12,
                            color: mainAppBlack,
                          ),
                        ),
                        Text(
                          'Get 2 months of Premium',
                          style: TextStyle(
                            color: greyLightColor,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          'for $pricePremium' '₫',
                          style: TextStyle(
                            color: greyLightColor,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildFormLessonJoinPremium(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTitlePickYourPremium(),
                    _buildFormChoicePremium(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormLessonJoinPremium() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: mainAppWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Why join Premium?',
              style: TextStyle(color: orangeLight, fontSize: 16),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
                title: Text(
                  'Listen offline without Wi-Fi',
                  style: TextStyle(fontSize: 12, color: greyLightColor),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
                title: Text(
                  'Play songs in any order',
                  style: TextStyle(fontSize: 12, color: greyLightColor),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
                title: Text(
                  'Music without ad interruptions',
                  style: TextStyle(fontSize: 12, color: greyLightColor),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
                title: Text(
                  'Higher sound quality',
                  style: TextStyle(fontSize: 12, color: greyLightColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitlePickYourPremium() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Pick your Premium',
        style: TextStyle(
          color: blueDark,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildFormChoicePremium(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        _buildPickPremiumMini(context),
        _buildPickPremiumIndividual(),
        _buildPickPremiumStudent(),
      ],
    );
  }

  Widget _buildPickPremiumMini(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 83, 169, 209),
            Color.fromARGB(255, 7, 78, 111)
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  'Mini',
                  style: TextStyle(fontSize: 16, color: mainAppWhite),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$pricePremiumMini' '₫',
                      style: TextStyle(color: mainAppGrey, fontSize: 24),
                    ),
                    Text(
                      'FOR 1 DAY',
                      style: TextStyle(color: mainAppGrey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '1 Premium account',
                style: TextStyle(color: mainAppGrey),
              )),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => Demo()));
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 7, 78, 111)
                        .withOpacity(0.2);
                  }
                  return Colors.transparent;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return mainAppWhite;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            child: Text(
              'GET PREMIUM',
              style: TextStyle(
                color: mainAppBlack,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text_premiumMini,
            style: TextStyle(
              color: greyLightColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPickPremiumIndividual() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 8, 68, 46),
            Color.fromARGB(255, 6, 137, 89),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  'Premium Individual',
                  style: TextStyle(fontSize: 16, color: mainAppWhite),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$pricePremium' '₫',
                      style: TextStyle(color: mainAppWhite, fontSize: 24),
                    ),
                    Text(
                      'FOR 2 MONTHS',
                      style: TextStyle(color: mainAppWhite, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '1 Premium account',
                style: TextStyle(color: greyColorForText),
              )),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 6, 137, 89)
                        .withOpacity(0.2);
                  }
                  return Colors.transparent;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return mainAppWhite;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            child: Text(
              'GET PREMIUM',
              style: TextStyle(
                color: mainAppBlack,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text_premiumIndividual,
            style: TextStyle(
              color: greyLightColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPickPremiumStudent() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 222, 163, 76),
            Color.fromARGB(255, 132, 82, 7),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  'Premium Student',
                  style: TextStyle(fontSize: 16, color: mainAppWhite),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$pricePremiumStudent' '₫',
                      style: TextStyle(color: mainAppWhite, fontSize: 24),
                    ),
                    Text(
                      'FOR 2 MONTHS',
                      style: TextStyle(color: mainAppWhite, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '1 Premium account',
                style: TextStyle(color: greyColorForText),
              )),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 132, 82, 7)
                        .withOpacity(0.2);
                  }
                  return Colors.transparent;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return mainAppWhite;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            child: Text(
              'GET PREMIUM',
              style: TextStyle(
                color: mainAppBlack,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text_premiumStudent,
            style: TextStyle(
              color: greyLightColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
