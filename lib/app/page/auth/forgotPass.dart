import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:app_api/other/color.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isLoading = false;
  bool isVisible = false;
  TextEditingController _accountIdController = TextEditingController();
  TextEditingController _numberIdController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  Future<void> _resetPassword() async {
    String accountId = _accountIdController.text;
    String numberId = _numberIdController.text;
    String newPassword = _newPasswordController.text;

    print('Thong tin tai khoản: $accountId, $numberId, $newPassword');
    // Set isLoading to true để hiển thị circular progress indicator
    setState(() {
      _isLoading = true;
    });

    // Gọi API reset password ở đây
    await Future.delayed(Duration(seconds: 2)); // Giả lập API đang xử lý
    bool check =
        await APIRepository().forgotPassword(accountId, numberId, newPassword);
    // Set isLoading to false khi nhận được phản hồi từ API
    if (check) {
      setState(() {
        _isLoading = false;
      });
      print('Đặt lại mật khẩu thành công!');
      Navigator.pop(context);
    } else
      print('Đặt lại mật khẩu thất bại!');

    // Xử lý phản hồi từ API, ví dụ:
    // if (response.statusCode == 200) {
    //   // Xử lý khi reset password thành công
    // } else {
    //   // Xử lý khi reset password thất bại
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainAppWhite,
        appBar: AppBar(
          backgroundColor: mainAppWhite,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'RESET PASSWORD',
                    style: TextStyle(
                        color: blueDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account ID',
                        style: TextStyle(color: orangeLight, fontSize: 18),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: _accountIdController,
                          decoration: InputDecoration(
                            hintText: 'ID',
                            hintStyle:
                                TextStyle(color: greyLightColor, fontSize: 14),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: blueDark, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: blueDark, width: 1.5),
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
                          ),
                          style: TextStyle(color: blueDark),
                          cursorColor: blueDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number ID',
                        style: TextStyle(color: orangeLight, fontSize: 18),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: _numberIdController,
                          decoration: InputDecoration(
                            hintText: 'Number ID',
                            hintStyle:
                                TextStyle(color: greyLightColor, fontSize: 14),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: blueDark, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: blueDark, width: 1.5),
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
                          ),
                          style: TextStyle(color: blueDark),
                          cursorColor: blueDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Column(
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
                          controller: _newPasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'New password',
                              hintStyle: TextStyle(
                                  color: greyLightColor, fontSize: 14),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: blueDark, width: 1.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: blueDark, width: 1.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: error, width: 1.5),
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
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: blueDark,
                                ),
                              )),
                          style: TextStyle(color: blueDark),
                          obscureText: !isVisible,
                          cursorColor: blueDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return mainAppWhite.withOpacity(0.2);
                              }
                              return transparentColor;
                            },
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return blueDark;
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          surfaceTintColor: MaterialStateColor.resolveWith(
                              (states) => transparentColor)),
                      onPressed: _isLoading
                          ? null
                          : _resetPassword, // Disable nút khi isLoading là true
                      child: _isLoading
                          ? CircularProgressIndicator() // Hiển thị circular progress indicator khi isLoading là true
                          : Text(
                              'Reset',
                              style: TextStyle(
                                  color: mainAppWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
