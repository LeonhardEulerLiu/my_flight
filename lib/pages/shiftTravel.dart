import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/serverExperMap.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:dio/dio.dart';
import 'package:my_flight/common/http.dart';

//ExpansionPanel在返回时展开异常。这个以后再修复。

class shiftAppBar extends StatelessWidget with PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("行程"),
      automaticallyImplyLeading: false,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class shiftTravelBody extends StatefulWidget {
  @override
  _shiftTravelBodyState createState() => _shiftTravelBodyState();
}

class _shiftTravelBodyState extends State<shiftTravelBody> {
  List travels = [];
  bool loading = true;

  List<String> toDateElement(String date) {
    return date.split(new RegExp(r"[ :-]"));
  }

  waitStepBox timeDiff(String a, String b) {    //b应比a晚
    print("a: $a, b: $b");
    DateTime adate = DateTime.parse(a);
    DateTime bdate = DateTime.parse(b);
    Duration diff = bdate.difference(adate);
    if(diff.inDays > 0)
      return waitStepBox(days: diff.inDays,);
    else if(diff.inHours > 0)
      return waitStepBox(hours: diff.inHours,);
    else
      return waitStepBox(minutes: diff.inMinutes,);
  }

  void getTrips () async{
    final mainPageArgs args = ModalRoute.of(context).settings.arguments;
    try{
      Response response = await dio.post("trip/front/findByUno", data: {"uno": args.uno});
      print(response.data);
      setState(() {
        travels = response.data;
        loading = false;
      });
    } catch(e){
      print("无法连接到服务器！");
      setState(() {
        travels = [];
        loading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    getTrips();
  }

  @override
  Widget build(BuildContext context) {
    final mainPageArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());

    return ListView(
      children: [
        instructionBox(
          [
            Text("对每个行程，点击标题栏右侧的 ", style: TextStyle(fontSize: 15, color: Colors.white, ), ),
            Icon(Icons.border_color, color: Colors.white, ),
            Text(" 以改签。", style: TextStyle(fontSize: 15, color: Colors.white, ),),
            Text("点击灰色票签以查看乘客信息。", style: TextStyle(fontSize: 15, color: Colors.white, ),),
          ]
        ),
        formPanelList(
          <formPanelInfo>[
            for(int i=0; i<travels.length; i++) formPanelInfo(
              "${travels[i]["flights"][0]["depa_city"]} 至 ${travels[i]["flights"].last["ariv_city"]}"
                  " - ${toDateElement(travels[i]["flights"][0]["depa_time"])[0]}年${toDateElement(travels[i]["flights"][0]["depa_time"])[1]}月出发",
              [
                for(int j=0; j<travels[i]["flights"].length; j++) Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        var newMap = await Navigator.pushNamed(context, "/returnTicket",
                          arguments: returnTicketArgs(args.uno, travels[i]["tno"], travels[i]["flights"][j]),);
                        setState(() {
                          travels[i]["flights"][j] = newMap;
                        });
                      },
                      child: flightStepBox(
                        depaDay: int.parse(toDateElement(travels[i]["flights"][j]["depa_time"])[2]),
                        depaTime: "${toDateElement(travels[i]["flights"][j]["depa_time"])[3]}:${toDateElement(travels[i]["flights"][j]["depa_time"])[4]}",
                        depaIata: travels[i]["flights"][j]["depa_iata"],
                        depaCname: travels[i]["flights"][j]["depa_port"],
                        arivDay: int.parse(toDateElement(travels[i]["flights"][j]["ariv_time"])[2]),
                        arivTime: "${toDateElement(travels[i]["flights"][j]["ariv_time"])[3]}:${toDateElement(travels[i]["flights"][j]["ariv_time"])[4]}",
                        arivIata: travels[i]["flights"][j]["ariv_iata"],
                        arivCname: travels[i]["flights"][j]["ariv_port"],
                        prefix: travels[i]["flights"][j]["prefix"],
                        pname: travels[i]["flights"][j]["ptag"],
                        color: Colors.grey[350],
                      ),
                    ),
                    if(j < travels[i]["flights"].length - 1)
                      //用标准时间加减。其实用当地时间加减也行，因为是一个地方。但是如果是不同地方，就必须用标准时间了。我们坚持用标准时间加减。
                      timeDiff(travels[i]["flights"][j]["ariv_gmt"], travels[i]["flights"][j+1]["depa_gmt"]),
                  ],
                ),
              ],
              trailingIconButton: IconButton(
                icon: Icon(Icons.border_color, color: Colors.green),
                tooltip: "改签",
                onPressed: () async {
                  String result = await showModalBottomSheet(context: context,
                      builder: (context) => changeQueryCard(
                        beginDate: "2019-07-01",
                        endDate: "2022-01-01",
                        depaCity: travels[i]["flights"][0]["depa_city"],
                        arivCity: travels[i]["flights"].last["ariv_city"],
                        originalDate: travels[i]["flights"][0]["depa_time"].split(" ")[0],
                      ),
                    );
                  if(result != "")
                    Navigator.pushNamed(context, "/flightsChoice",
                      arguments: searchFlightArgs(
                        args.uno, args.uname, travels[i]["tno"], travels[i]["flights"][0]["depa_cno"],
                        travels[i]["flights"][0]["depa_city"], travels[i]["flights"].last["ariv_cno"],
                        travels[i]["flights"].last["ariv_city"], result,
                      ),
                    );
                }
              ),
            ),
          ]
        ),
        if(travels.length < 1 && loading == false)  notFound("行程"),
        if(travels.length < 1 && loading == true)   loadingTip(),
      ],
    );
  }
}
