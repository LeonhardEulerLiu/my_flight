import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:my_flight/routeParas/serverExperMap.dart';
import 'package:provider/provider.dart';
import 'package:my_flight/modals/cart.dart';

//别忘了退款！

class successPage extends StatefulWidget {
  static const String routeName = "/shopSuccess";

  @override
  _successPageState createState() => _successPageState();
}

class _successPageState extends State<successPage> {
  Map resultMap = Map();

  bool loading = true;

  void goBuying() async {
    buyingResult result = await Provider.of<cartModal>(context, listen: false).publish();
    setState(() {
      resultMap["price"] = result.price;
      resultMap["status"] = result.status;
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    goBuying();
  }

  @override
  Widget build(BuildContext context) {
    //别忘了退款！
    int uno = Provider.of<cartModal>(context, listen: false).uno;
    String uname = Provider.of<cartModal>(context, listen: false).uname;
    int tno = Provider.of<cartModal>(context, listen: false).tripNo;

    return Scaffold(
      appBar: AppBar(
        title: Text("购买成功"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          if(tno < 0) IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, myScaffold.routeName[0], ModalRoute.withName('/'),
              arguments: mainPageArgs(uno, uname)),
          ),
          if(tno >= 0) IconButton(
            icon: Icon(Icons.check),
            //别忘了退款！
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, myScaffold.routeName[1], ModalRoute.withName('/'),
                arguments: mainPageArgs(uno, uname)),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 200, child: Image.asset("images/bilibiliSuccess.jpeg")),
            if(loading == false) instructionBox(
              [
                Text("购买成功！您总计花费了￥${resultMap["price"]}元！请知悉：",
                  style: TextStyle(fontSize: 15, color: Colors.white, ), ),
                Text("价格随时间可能会有变动。详情请查看您的行程。",
                  style: TextStyle(fontSize: 15, color: Colors.white, ), ),
                Text("接下来若有文本，则是座椅变动信息。若座椅不够，",
                  style: TextStyle(fontSize: 15, color: Colors.white, ), ),
                Text("则自动降舱位；若无经济舱，则会提示有几个座位 ",
                  style: TextStyle(fontSize: 15, color: Colors.white, ), ),
                Text("没有订购。点击 ",
                  style: TextStyle(fontSize: 15, color: Colors.white, ), ),
                Icon(Icons.check, color: Colors.white,),
                Text(" 以退出购票流程。",
                  style: TextStyle(fontSize: 15, color: Colors.white, ), ),
              ]
            ),
            if(loading == false) instructionBox(
              [
                Text(resultMap["status"],
                  style: TextStyle(fontSize: 15, color: Colors.white, ), softWrap: true,),
              ]
            ),
            if(loading == true)  loadingTip(),
          ],
        ),
      ),
    );
  }
}
