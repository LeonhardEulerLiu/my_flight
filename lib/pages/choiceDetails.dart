import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/modals/cart.dart';
import 'package:my_flight/pages/passForm.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:provider/provider.dart';

class choiceDetailsPage extends StatelessWidget {
  static const routeName = "/choiceDetails";

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

  @override
  Widget build(BuildContext context) {
    flightDetailsArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("行程确认"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next, color: Colors.white,),
            tooltip: "开始订票",
            onPressed: () {
              Provider.of<cartModal>(context, listen: false).initCart(args.uno, args.uname, args.tno, args.details);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => passFormPage(0),
              ),);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          instructionBox(
            <Widget>[
              Text("请查看下面的行程。",
                style: TextStyle(fontSize: 15, color: Colors.white, ), ),
              Text("如果您确信这就是您所要的行程，",
                style: TextStyle(fontSize: 15, color: Colors.white, ), ),
              Text("点击右上角的按钮 ",
                style: TextStyle(fontSize: 15, color: Colors.white, ), ),
              Icon(Icons.navigate_next, color: Colors.white,),
              Text(" 以开始订购机票。",
                style: TextStyle(fontSize: 15, color: Colors.white, ), ),
            ],
          ),
          for(int i=0; i<args.details.length; i++) Column(         //解释一下为什么ListView显示不出来？Column可以正常显示。
            children: <Widget>[
              flightStepBox(
                depaDay: int.parse(toDateElement(args.details[i]["depa_time"])[2]),
                depaTime: "${toDateElement(args.details[i]["depa_time"])[3]}:${toDateElement(args.details[i]["depa_time"])[4]}",
                depaIata: args.details[i]["depa_iata"],
                depaCname: args.details[i]["depa_port"],
                arivDay: int.parse(toDateElement(args.details[i]["ariv_time"])[2]),
                arivTime: "${toDateElement(args.details[i]["ariv_time"])[3]}:${toDateElement(args.details[i]["ariv_time"])[4]}",
                arivIata: args.details[i]["ariv_iata"],
                arivCname: args.details[i]["ariv_port"],
                prefix: args.details[i]["prefix"],
                pname: args.details[i]["ptag"],
                showTickets: true,
                firstClass: args.details[i]["first_class"],
                business: args.details[i]["business"],
                economy: args.details[i]["economy"],
              ),
              if(i < args.details.length - 1)
                timeDiff(args.details[i]["ariv_gmt"], args.details[i+1]["depa_gmt"]),
            ],
          ),
        ],
      ),
    );
  }
}