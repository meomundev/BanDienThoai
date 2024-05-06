import 'package:app_api/other/color.dart';
import 'package:barcode_scan2/model/scan_result.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String? qrResult;

  // Hàm để quét mã QR
  Future<void> _scanQR() async {
    try {
      ScanResult scanResult = await BarcodeScanner.scan();
      setState(() {
        qrResult = scanResult.rawContent;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          qrResult = "Từ chối truy cập camera";
        });
      } else {
        setState(() {
          qrResult = "Lỗi không xác định $ex";
        });
      }
    } on FormatException {
      setState(() {
        qrResult = "Bạn đã nhấn nút back trước khi quét bất cứ thứ gì";
      });
    } catch (ex) {
      setState(() {
        qrResult = "Lỗi không xác định $ex";
      });
    }
  }

  // Hàm để mở URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Không thể mở URL: $url';
    }
  }

  // Hàm để sao chép kết quả
  void _copyResult(String? result) {
    Clipboard.setData(ClipboardData(text: result ?? ""));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã sao chép: $result")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: orangeLight,
        ),
        backgroundColor: blueDark,
        title: Text(
          "Scan QR",
          style: TextStyle(
            color: orangeLight,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (qrResult != null) {
                  _launchURL(qrResult!);
                }
              },
              child: Text(
                qrResult ?? "Scan your QR",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: qrResult != null ? Colors.blue : Colors.black,
                  decoration:
                      qrResult != null ? TextDecoration.underline : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _copyResult(qrResult);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // border radius
                ),
                backgroundColor: blueDark, // padding
              ),
              child: Text(
                "Copy",
                style: TextStyle(color: mainAppWhite),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: blueDark,
        icon: Icon(
          Icons.camera_alt,
          color: mainAppWhite,
        ),
        label: Text(
          "Scan",
          style: TextStyle(color: mainAppWhite),
        ),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
