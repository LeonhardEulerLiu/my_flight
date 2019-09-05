import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:my_flight/common/http.dart';
import 'package:dio/dio.dart';

class returnTicketPage extends StatefulWidget {
  static const String routeName = "/returnTicket";

  @override
  _returnTicketPageState createState() => _returnTicketPageState();
}

class _returnTicketPageState extends State<returnTicketPage> {

  List<String> toDateElement(String date) {
    return date.split(new RegExp(r"[ :-]"));
  }

  static const List<String> _categoryList = [
    null, "头等舱", "商务舱", "经济舱",
  ];

  @override
  Widget build(BuildContext context) {
    returnTicketArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("${args.flight["depa_port"]} 至 ${args.flight["ariv_port"]}"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.white,),
          onPressed: () => Navigator.pop<Map>(context, args.flight),
        ),
      ),
      body: ListView(
        children: <Widget>[
          flightStepBox(
            depaDay: int.parse(toDateElement(args.flight["depa_time"])[2]),
            depaTime: "${toDateElement(args.flight["depa_time"])[3]}:${toDateElement(args.flight["depa_time"])[4]}",
            depaIata: args.flight["depa_iata"],
            depaCname: args.flight["depa_port"],
            arivDay: int.parse(toDateElement(args.flight["ariv_time"])[2]),
            arivTime: "${toDateElement(args.flight["ariv_time"])[3]}:${toDateElement(args.flight["ariv_time"])[4]}",
            arivIata: args.flight["ariv_iata"],
            arivCname: args.flight["ariv_port"],
            prefix: args.flight["prefix"],
            pname: args.flight["ptag"],
            color: Colors.grey[350],
          ),
          instructionBox(
            [
              Text("对每个乘客，点击标题栏右侧的 ", style: TextStyle(fontSize: 15, color: Colors.white, ), ),
              Icon(Icons.clear, color: Colors.white, ),
              Text(" 以退票。", style: TextStyle(fontSize: 15, color: Colors.white, ), ),
            ]
          ),
          for(int i=0; i<args.flight["passengers"].length; i++)
            if(args.flight["passengers"][i]["valid"] == 0)
              formCardList(
                key: ValueKey(i),
                title: args.flight["passengers"][i]["passName"],
                trialingButton: IconButton(
                  icon: Icon(Icons.clear, color: Colors.purple, ),
                  onPressed: () async {
                     switch(await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("确认退票"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('您真的要退 ${args.flight["passengers"][i]["passName"]} 的票吗？'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("是"),
                            onPressed: () => Navigator.of(context).pop(1),
                          ),
                          FlatButton(
                            child: Text("否"),
                            onPressed: () => Navigator.of(context).pop(2),
                          )
                        ],
                      )
                    )){
                       case 1:    //确认退票，执行操作
                        setState(() {
                          args.flight["passengers"][i]["valid"] = -1;
                        });
                        //别忘了联系服务器呦！
                        Response response = await dio.post("ticket/front/cancelIndiv", data: {"tno": args.tno, "fno": args.flight["passengers"][i]["fno"],
                            "sno": args.flight["passengers"][i]["sno"], "category": args.flight["passengers"][i]["category"],
                            "price": args.flight["passengers"][i]["price"]});
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Text("退票成功"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('已经返回￥${response.data}元！'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("是"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                        ));
                         break;
                       case 2:    //不想退票，什么都不做
                         break;
                     }
                  },
                ),
                contents: <Widget>[
                  formLineShow("航班号", args.flight["passengers"][i]["fno"].toString(),),
                  formLineShow("航班名", args.flight["passengers"][i]["prefix"]),
                  formLineShow("座号", args.flight["passengers"][i]["sname"],),
                  formLineShow("身份证号", args.flight["passengers"][i]["passId"]),
                  formLineShow("姓名", args.flight["passengers"][i]["passName"]),
                  formLineShow("国籍", args.flight["passengers"][i]["passNation"]),
                  formLineShow("舱位", _categoryList[args.flight["passengers"][i]["category"]]),
                  formLineShow("价格", "￥${args.flight["passengers"][i]["price"]}"),
                ],
              ),
          if(args.flight["passengers"].length < 1)  notFound("乘客"),
        ],
      ),
    );
  }
}

