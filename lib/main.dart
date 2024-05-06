import 'dart:io';

import 'package:app_api/app/model/product_viewmodel.dart';
import 'package:app_api/app/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WelcomePage(),
//       // initialRoute: "/",
//       // onGenerateRoute: AppRoute.onGenerateRoute,  -> su dung auto route (pushName)
//     );
//   }
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductVM(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const WelcomePage(),
      ),
    );
  }
}
