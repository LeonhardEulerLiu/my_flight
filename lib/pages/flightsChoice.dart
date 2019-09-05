import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:my_flight/routeParas/serverExperMap.dart';
import 'package:my_flight/common/http.dart';
import 'package:dio/dio.dart';

//我们不知道为什么会有D/skia Shader compilation error, 虽然应该不会影响运行。
//各票张随机场名长度的改变，列与列之间会有轻微不对齐，不过我们忽略此问题。
//我们将在点击条目之后直接进入下一页面，所以这里将不写回调函数。
//我们将在写参数类（网络传值）时，将参数类直接传入条目之中。其他参数不变。
//我们将不再重复网络请求，下一页将直接使用这一夜条目中的参数类引用。

class flightsChoicePage extends StatefulWidget {
  static const String routeName = "/flightsChoice";

  @override
  _flightsChoicePageState createState() => _flightsChoicePageState();
}

class _flightsChoicePageState extends State<flightsChoicePage> {
  int uno;
  String uname;
  int tno;
  int orderStandard = 0;
  List flightsRes = [];
  bool loading = true;

  List<String> toDateElement(String date) {
    return date.split(new RegExp(r"[ :-]"));
  }

//  @override
//  void initState(){
//    flightsRes = server_flightRes;
//    for(int i=0; i<flightsRes.length; i++){
//      flightsRes[i]["begin_time"] = flightsRes[i]["flights"][0]["depa_time"];
//      flightsRes[i]["finish_time"] = flightsRes[i]["flights"].last["ariv_time"];
//      flightsRes[i]["begin_port"] = flightsRes[i]["flights"][0]["depa_port"];
//      flightsRes[i]["finish_port"] = flightsRes[i]["flights"].last["ariv_port"];
//      flightsRes[i]["shifts"] = flightsRes[i]["flights"].length;
//      num totalEprice = 0;
//      for(int j=0; j<flightsRes[i]["flights"].length; j++){
//        totalEprice += flightsRes[i]["flights"][j]["eprice"];
//      }
//      flightsRes[i]["total_eprice"] = totalEprice;
//    }
//  }

  void searchResult() async {
    searchFlightArgs args = ModalRoute.of(context).settings.arguments;
    try {
      Response response = await dio.post("flight/front/findChoice", data: {"depaCno": args.depaCno,
        "arivCno": args.arivCno, "depaDate": args.depaDate});
      setState(() {
        flightsRes = response.data;
        for(int i=0; i<flightsRes.length; i++){
          flightsRes[i]["begin_time"] = flightsRes[i]["flights"][0]["depa_time"];
          flightsRes[i]["finish_time"] = flightsRes[i]["flights"].last["ariv_time"];
          flightsRes[i]["begin_port"] = flightsRes[i]["flights"][0]["depa_port"];
          flightsRes[i]["finish_port"] = flightsRes[i]["flights"].last["ariv_port"];
          flightsRes[i]["shifts"] = flightsRes[i]["flights"].length;
          num totalEprice = 0;
          for(int j=0; j<flightsRes[i]["flights"].length; j++){
            totalEprice += flightsRes[i]["flights"][j]["eprice"];
          }
          flightsRes[i]["total_eprice"] = totalEprice;
        }
        loading = false;
      });
      print("结束！");
    } catch(e) {
      print("服务器出错啦！");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    searchResult();
  }

  @override
  Widget build(BuildContext context) {
    searchFlightArgs args = ModalRoute.of(context).settings.arguments;
    uno = args.uno;
    uname = args.uname;
    tno = args.tno;
    print(args.toString());

    switch(orderStandard){
      case 0:       //终到时间从早到晚
        flightsRes?.sort((left, right) {
          DateTime a = DateTime.parse(left["finish_time"]);
          DateTime b = DateTime.parse(right["finish_time"]);
          return a.difference(b).inMinutes;
        });
        break;
      case 1:       //单人票价从低到高
        flightsRes?.sort((left, right) {
          num a = left["total_eprice"];
          num b = right["total_eprice"];
          return (a - b).floor();
        });
        break;
      case 2:       //换乘次数由少到多
        flightsRes?.sort((left, right) {
          num a = left["shifts"];
          num b = right["shifts"];
          return a - b;
        });
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${args.depaCity} 至 ${args.arivCity}"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.import_export, color: Colors.white),
            onSelected: (int result) => setState(() => orderStandard = result),
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text("终到时间从早到晚"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("单人票价从低到高"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("换乘次数由少到多"),
              ),
            ],
          ),
        ],
      ),
      body:
        ListView(
          children: <Widget>[
            for(int i=0; i<flightsRes.length; i++) saleOutline(
              depaTime: "${toDateElement(flightsRes[i]["begin_time"])[3]}:${toDateElement(flightsRes[i]["begin_time"])[4]}",
              arivDateTime: "${toDateElement(flightsRes[i]["finish_time"])[2]}日${toDateElement(flightsRes[i]["finish_time"])[3]}:${toDateElement(flightsRes[i]["finish_time"])[4]}",
              depaCname: flightsRes[i]["begin_port"],
              arivCname: flightsRes[i]["finish_port"],
              rawPrice: flightsRes[i]["total_eprice"],
              remains: [
                for(int j=0; j<flightsRes[i]["flights"].length; j++)
                  remainingTickets(flightsRes[i]["flights"][j]["prefix"], flightsRes[i]["flights"][j]["ptag"],
                    flightsRes[i]["flights"][j]["first_class"], flightsRes[i]["flights"][j]["business"], flightsRes[i]["flights"][j]["economy"]),
              ],
              tripDetail: flightDetailsArgs(uno, tno, uname, flightsRes[i]["flights"]),
              key: UniqueKey(),
            ),
            if(flightsRes.length < 1 && loading == false)   notFound("航班"),
            if(flightsRes.length < 1 && loading == true)    loadingTip(),
          ],
        ),
    );
  }
}
