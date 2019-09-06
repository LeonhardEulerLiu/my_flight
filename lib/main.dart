import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/modals/cart.dart';
import 'package:provider/provider.dart';

import 'package:my_flight/pages/login.dart';
import 'package:my_flight/pages/signUp.dart';
import 'package:my_flight/pages/changePassword.dart';
import 'package:my_flight/pages/flightsChoice.dart';
import 'package:my_flight/pages/returnTicket.dart';
import 'package:my_flight/pages/choiceDetails.dart';
import 'package:my_flight/pages/shopSuccess.dart';
import 'package:dio/dio.dart';
import 'package:my_flight/common/http.dart';

//原本模拟器是10.0.2.2的，为了方便真机调试而改10.27.201.211
void main() {
  dio.options
    ..baseUrl = "http://10.0.2.2:8080/ltflight/"
    ..connectTimeout = 5000
    ..receiveTimeout = 5000;

  runApp(
      MultiProvider(
        providers: [
          //我们应当认真地考虑provider的多种类型。详见示例程序。
          ChangeNotifierProvider(builder: (context) => cartModal()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        //passForm使用带参构造器
        loginPage.routeName: (context) => loginPage(),
        signupPage.routeName: (context) => signupPage(),
        myScaffold.routeName[0]: (context) => myScaffold(0),
        myScaffold.routeName[1]: (context) => myScaffold(1),
        myScaffold.routeName[2]: (context) => myScaffold(2),
        changePasswordPage.routeName: (context) => changePasswordPage(),
        flightsChoicePage.routeName: (context) => flightsChoicePage(),
        returnTicketPage.routeName: (context) => returnTicketPage(),
        choiceDetailsPage.routeName: (context) => choiceDetailsPage(),
        successPage.routeName: (context) => successPage(),
      },
    );
  }
}

