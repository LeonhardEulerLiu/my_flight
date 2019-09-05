import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:dio/dio.dart';
import 'package:my_flight/common/http.dart';

class buyingResult {
  num price;
  String status;

  buyingResult(this.price, this.status);
}

//票应当全部有效
class ticketModal {
  int fno;
  String passId;
  String passName;
  String passNation;
  int category;

  ticketModal({@required this.fno, @required this.passId,
    @required this.passName, @required this.passNation, @required this.category, });

//  String toString() => "ticketModal{ $fno, $passId, $passName, $passNation, $category }\n";

  Map<String, dynamic> toJson() =>
      {
        "fno": fno,
        "passId": passId,
        "passName": passName,
        "passNation": passNation,
        "category": category
      };
}

class flightFormModal {
  int fno;
  List<ticketModal> tickets;

  flightFormModal({@required this.fno, @required this.tickets});

//  String toString() {
//    String result = "flightFormModal { fno: $fno, tickets: \n";
//    for(ticketModal t in tickets){
//      result += t.toString();
//    }
//    result += " } \n";
//    return result;
//  }

  Map<String, dynamic> toJson() =>
      {
        "fno": fno,
        "passengers": tickets.map((f) => f.toJson()).toList()
      };
}

class cartModal extends ChangeNotifier{
  int uno;
  String uname;
  int tripNo;
  List details;     //航班详情，见serverExperMap.dart的server_flightRes的flights字段
  List<flightFormModal> cart;

  cartModal({this.uno = -1, this.uname = "", this.tripNo = -1, this.details = const [], this.cart = const [], });

  void initCart(int uno, String uname, int tripNo, List details) {
    this.uno = uno;
    this.uname = uname;
    this.tripNo = tripNo;
    this.details = details;
    cart = [];
    for(int i=0; i<details.length; i++){
      cart.add(flightFormModal(fno: details[i]["fno"], tickets: []));
    }
    notifyListeners();
  }

  void putInCart(int flightOrder, flightFormModal form) {
    cart[flightOrder] = form;
    notifyListeners();
  }

  Map<String, dynamic> toJson() =>
      {
        "uno": uno,
        "flights": cart.map((e) => e.toJson()).toList()
      };

  //别忘了退款！
  Future<buyingResult> publish() async {
//    print("details: \n");
//    for(var item in details){
//      print(item);
//      print("\n\n");
//    }
//    print("cart: \n");
//    for(flightFormModal f in cart){
//      print(f);
//      print("\n\n");
//    }
    print("Wanted Map: \n");
    print(toJson());
    Response buying = await dio.post("ticket/front/supply", data: toJson());
    num totalPrice = buying.data["price"];
    String status = buying.data["status"];
    if(tripNo > 0){     //不退票则为-1
      Response returning = await dio.post("ticket/front/cancelTrip", data: {"tno": tripNo});
      status = "退票成功，共返回￥${returning.data}元！" + status;
    }
    return new buyingResult(totalPrice, status);
  }
}