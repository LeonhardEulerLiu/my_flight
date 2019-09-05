import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:my_flight/routeParas/serverExperMap.dart';
import 'package:dio/dio.dart';
import 'package:my_flight/common/http.dart';

//我们使用myScaffold来作为三个首页的容器，因为他们有底部导航栏链接。
//参见components.dart里面的myScaffold和mainNavigBar。
//本页没有浮动按钮。

//关于切换底部导航栏状态丢失问题的解决，感谢 https://www.cnblogs.com/hupo376787/p/10624636.html

class searchAppBar extends StatelessWidget with PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("买票"),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class searchFlightBody extends StatefulWidget {
  @override
  _searchFlightBodyState createState() => _searchFlightBodyState();
}

class _searchFlightBodyState extends State<searchFlightBody> {
  mainPageArgs theArgs;

  Map<String, String> _pageValues = {
    "depaCity": "请选择",
    "arivCity": "请选择",
    "date": DateTime.now().toString().split(" ")[0],
  };

  //让index从1开始
//  List<String> cities = [null, "济南", "广州", "阿德莱德", ];
  List serverCityList;
  Map<String, int> cityMap = Map();
  
  void getCityList() async {
    try{
      Response response = await dio.get("city/front/findPair");
      print(response.data);
      serverCityList = response.data.map((item) => cityPairArgs.fromJson(item)).toList();
      for(cityPairArgs city in serverCityList){
        cityMap[city.cityName] = city.cno;
      }
    } catch(e){
      print("无法从服务器获取城市列表！");
      serverCityList = [];
    }
  }

  @override
  void initState() {
    getCityList();
  }

  void changeProp(Map<String, String> map) => map.forEach((key, value) => _pageValues[key] = value);
  void goToSearch() {
    if(_pageValues.containsValue("请选择")){
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('提示'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('请先选择起止城市！'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确认'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else{
      Navigator.pushNamed(context, "/flightsChoice",
        arguments: searchFlightArgs(theArgs.uno, theArgs.uname, -1, cityMap[_pageValues["depaCity"]], _pageValues["depaCity"],
            cityMap[_pageValues["arivCity"]], _pageValues["arivCity"], _pageValues["date"]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mainPageArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());
    theArgs = args;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/flightSearch.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
          child: searchCard(
            cityList: cityMap.keys.toList(),
            beginDate: "2019-01-01",
            endDate: "2021-01-01",
            changeMap: changeProp,
            goToSearch: goToSearch,
          ),
      ),
    );
  }
}

