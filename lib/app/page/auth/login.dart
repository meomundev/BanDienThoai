import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/page/auth/forgotPass.dart';
import 'package:app_api/app/welcome/welcome.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import '../register.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();

  login() async {
    //lấy token (lưu share_preference)
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    // save share
    saveUser(user, token);
    //
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppWhite,
      appBar: AppBar(
        backgroundColor: mainAppWhite,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()));
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: greyColorForText,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'LOGIN',
                    style: TextStyle(
                        color: blueDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  _buildFormLogin(),
                  _buildSplitDivider(),
                  _buildSocialGoogleLogin(),
                  const SizedBox(height: 24),
                  _buildSocialFacebookLogin(),
                  _buildHaveNotAccount(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLogin() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountField(),
          const SizedBox(
            height: 24,
          ),
          _buildPasswordField(),
          const SizedBox(
            height: 16,
          ),
          _buildForgetPassword(),
          const SizedBox(
            height: 24,
          ),
          _buildButtonLogin(),
        ],
      ),
    );
  }

  Widget _buildAccountField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: TextStyle(color: orangeLight, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: TextFormField(
            controller: accountController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter your Username',
              hintStyle: TextStyle(color: greyLightColor, fontSize: 14),
              fillColor: mainAppWhite,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blueDark, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blueDark, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: error, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              errorStyle: TextStyle(
                color: error,
              ),
            ),
            style: TextStyle(color: blueDark),
            cursorColor: blueDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(color: orangeLight, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: '●●●●●●●●●●●●●',
                hintStyle: TextStyle(color: greyLightColor, fontSize: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: blueDark, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: blueDark, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: error, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                errorStyle: TextStyle(
                  color: error,
                ),
                fillColor: mainAppWhite,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: blueDark,
                  ),
                )),
            style: TextStyle(color: blueDark),
            obscureText: !isVisible,
            cursorColor: blueDark,
          ),
        ),
      ],
    );
  }

  Widget _buildForgetPassword() {
    return Row(
      children: [
        const Spacer(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Forgot password?",
                style: TextStyle(
                  color: blueDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonLogin() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              login();
            }
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
            style: TextStyle(
                color: mainAppWhite, fontWeight: FontWeight.bold, fontSize: 16),
          )),
    );
  }

  Widget _buildSplitDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              width: double.infinity,
              color: blueDark,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'or',
            style: TextStyle(
                color: blueDark, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              height: 1,
              width: double.infinity,
              color: blueDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialGoogleLogin() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return blueDarkO5;
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
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(width: 2, color: blueDark),
            ),
          ),
          surfaceTintColor:
              MaterialStateColor.resolveWith((states) => transparentColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/google.png',
              height: 24,
              width: 24,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'Login with Google',
              style: TextStyle(color: blueDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialFacebookLogin() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return blueDarkO5;
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
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(width: 2, color: blueDark),
            ),
          ),
          surfaceTintColor:
              MaterialStateColor.resolveWith((states) => transparentColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/facebook.png',
              height: 24,
              width: 24,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'Login with Facebook',
              style: TextStyle(color: blueDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHaveNotAccount(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(
            color: greyColorForText,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: "Register",
              style: TextStyle(
                color: blueDark,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _goToRegisterPage(context);
                },
            )
          ],
        ),
      ),
    );
  }

  void _goToRegisterPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }
}
