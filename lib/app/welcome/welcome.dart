import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:app_api/app/page/register.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              _buildLogo(),
              const SizedBox(
                height: 100,
              ),
              _buildTitleAndContent(),
              const SizedBox(
                height: 24,
              ),
              _buildButtonLogin(context),
              const SizedBox(
                height: 24,
              ),
              _buildButtonRegister(context),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      urlLogo,
      height: 320,
      width: 320,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTitleAndContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'Welcome to us',
            style: TextStyle(
                color: blueDark, fontWeight: FontWeight.bold, fontSize: 40),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Please login to your account or create new account to continue',
              style: TextStyle(color: orangeLight),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonLogin(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
          onPressed: () {
            _goToLoginPage(context);
          },
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return mainAppWhite.withOpacity(0.2);
                  }
                  return transparentColor;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return blueDark;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              surfaceTintColor:
                  MaterialStateColor.resolveWith((states) => transparentColor)),
          child: Text(
            'Login',
            style: TextStyle(color: mainAppWhite, fontWeight: FontWeight.bold),
          )),
    );
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Widget _buildButtonRegister(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          _goToRegisterPage(context);
        },
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return blueDarkO5;
                }
                return transparentColor;
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return mainAppWhite;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(width: 2, color: blueDark),
              ),
            ),
            surfaceTintColor:
                MaterialStateColor.resolveWith((states) => transparentColor)),
        child: Text(
          'Create account',
          style: TextStyle(color: blueDark, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _goToRegisterPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }
}
