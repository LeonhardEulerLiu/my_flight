import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/modals/cart.dart';
import 'package:my_flight/pages/returnTicket.dart';
import 'package:my_flight/pages/shopSuccess.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:provider/provider.dart';

//说明一下本页Map _pageValues的格式：
//"航班号"     对应fno
//"身份证号"   对应passId
//"姓名"       对应passName
//"国籍"       对应passNation
//"舱位"       对应category
//"function"   相应的回调函数

//十分遗憾的是，由于能力有限，我无法做到通过设置父组件的布尔变量数组来设定子组件
//ExpansionPanel的展开状态，因为如果我这么做程序会发生错误。我只好使得每修改一个变量，
//所有panel全部打开。这里是github上的一个issue，描述的就是这个问题，且flutter官方
//至今并未解决（issue仍为open状态）。https://github.com/flutter/flutter/issues/13780
//即使是这样，编辑文本时仍然崩溃。我们将会弃用ExpansionPanel，因为它老是出bug。

//真的是异彩纷呈。但愿没有比这个页面再难的了。细数一下学到的教训吧。
//1. 将函数视作变量。怎样填充一个列表中的Map？我们曾想到，在点击加号的回调函数中给每个卡片加上
//   setState(()=>_pageValues[_ticketCount][key] = value); 这样的语句就行了。这并不是一
//   个好主意，因为_ticketCount会动态变化成最新的值，不会保持原来的值不变，这样回调时就会插错位置。
//   我们想到了使用返回函数变量的一个函数，mapFunction来解决这个问题，因为index是一个临时变量，不
//   是永久变量，不会随便改变。
//2. Stateful Widget的自动重用。Flutter出于性能考虑，会在控件改变位置时，重用相关的Stateful Widget。
//   我们需要加一个key以防止错误重用。关于这一点，我推荐你观看 https://my.oschina.net/u/4082889/blog/3031508
//   问题基本上是相同的。对于Stateless Widget则不会出现此问题。
//3. 初始化Stateful Widget。根据第二点，当取消一个卡片，其他卡片的位置会改变，即使有key也会初始化，
//   这样原来的值就会消失。我在formLineTextField与formLineChooser加入了初始值属性，这样在initState
//   中会用父组件的_pageValues来初始化值。
//4. 鉴于ExpansionPanel不成熟，不要在ExpansionPanel中加入任何Stateful Widget，也不要用bool数组决
//   定其展开状态。

//暂时不支持热重载。

//欢迎针对这个组件提出bug。

class passFormPage extends StatefulWidget {
  static const String routeName = "/passForm";

  final int order;

  //之所以使用带参构造器，是要试图在initState中使用order
  passFormPage(this.order);

  @override
  _passFormPageState createState() => _passFormPageState();
}

class _passFormPageState extends State<passFormPage> {
  int _fno;
  List<num> _prices;
  List<Map<String, Object>> _pageValues = [];
  int _ticketCount = 0;

  flightStepBox _ticketBox;

  final Map<String, int> categoryStringMap = {
    "头等舱": 1,   "商务舱": 2,   "经济舱": 3,
  };

  final List<String> categories = [
    null, "头等舱", "商务舱", "经济舱",
  ];

  final Map<String, String> nationMapSTL = {        //STL == short to long
    "CHN": "中国 - CHN", "OTH": "其他国家 - OTH",
  };

  ValueChanged<Map<String, Object>> mapFunction(int index) =>
    (Map<String, Object> map) => map.forEach((key, value) =>
      setState(() => _pageValues[index][key] = value));

  List<String> toDateElement(String date) {
    return date.split(new RegExp(r"[ :-]"));
  }

  @override
  void didChangeDependencies() {
    cartModal cart = Provider.of<cartModal>(context);
    Map flight = cart.details[widget.order];
    List<ticketModal> savedTickets = cart.cart[widget.order].tickets;
    _fno = cart.cart[widget.order].fno;
    _prices = [
      flight["fprice"], flight["bprice"], flight["eprice"],
    ];
    _ticketBox = flightStepBox(
      depaDay: int.parse(toDateElement(flight["depa_time"])[2]),
      depaTime: "${toDateElement(flight["depa_time"])[3]}:${toDateElement(flight["depa_time"])[4]}",
      depaIata: flight["depa_iata"],
      depaCname: flight["depa_port"],
      arivDay: int.parse(toDateElement(flight["ariv_time"])[2]),
      arivTime: "${toDateElement(flight["ariv_time"])[3]}:${toDateElement(flight["ariv_time"])[4]}",
      arivIata: flight["ariv_iata"],
      arivCname: flight["ariv_port"],
      prefix: flight["prefix"],
      pname: flight["ptag"],
      showTickets: true,
      firstClass: flight["first_class"],
      business: flight["business"],
      economy: flight["economy"],
    );
    _pageValues = [];
    _ticketCount = 0;
    for(ticketModal ticket in savedTickets){
      _pageValues.add({
        "航班号": _fno,
        "身份证号": ticket.passId,
        "姓名": ticket.passName,
        "国籍": nationMapSTL[ticket.passNation],
        "舱位": categories[ticket.category],
        "valid": 0,
      });
      _ticketCount++;
    }
  }

  @override
  Widget build(BuildContext context) {
    cartModal cart = Provider.of<cartModal>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("订票"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.white,),
          tooltip: "上一步",
          onPressed: () {
            print(_pageValues);
            List<ticketModal> upload = [];
            for(Map<String, Object> passenger in _pageValues){
              if(passenger["valid"] == 0){
                upload.add(ticketModal(
                  fno: _fno,
                  passId: passenger["身份证号"],
                  passName: passenger["姓名"],
                  passNation: passenger["国籍"].toString().split(" ")[2],
                  category: categoryStringMap[passenger["舱位"]],
                ));
              }
            }
            cart.putInCart(widget.order, flightFormModal(fno: _fno, tickets: upload));
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next, color: Colors.white,),
            tooltip: "下一步",
            onPressed: () {
              print(_pageValues);
              bool isFinished = true;
              for(Map<String, Object> passenger in _pageValues){
                //检查是否有空没填
                if(passenger["valid"] == 0 && passenger.containsValue("")){
                  isFinished = false;
                }
              }
              if(isFinished){
                List<ticketModal> upload = [];
                for(Map<String, Object> passenger in _pageValues){
                  if(passenger["valid"] == 0){
                    upload.add(ticketModal(
                        fno: _fno,
                        passId: passenger["身份证号"],
                        passName: passenger["姓名"],
                        passNation: passenger["国籍"].toString().split(" ")[2],
                        category: categoryStringMap[passenger["舱位"]],
                    ));
                  }
                }
                cart.putInCart(widget.order, flightFormModal(fno: _fno, tickets: upload));
                if(widget.order == cart.details.length - 1)
                  Navigator.pushNamed(context, successPage.routeName);
                else
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => passFormPage(widget.order+1),
                  ),);
              }
              else{
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("提示"),
                        content: Text("您还有空没填！"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("是"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "添加乘客",
        child: Icon(Icons.add),
        onPressed: () {
          setState( (){
            _pageValues.add({
              "航班号": _fno,
              "身份证号": "",
              "姓名": "",
              "国籍": "中国 - CHN",
              "舱位": "经济舱",
              "valid": 0,
            });
            _ticketCount++;
          });
        },
      ),
      body: ListView(
        children: <Widget>[
          _ticketBox,
          instructionBox(
            <Widget>[
              Text("现在正在填写第 ${widget.order+1} 个航班的信息。",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
              Text("点击右下角的按钮 ",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
              Icon(Icons.add, color: Colors.white),
              Text(" 以开始订购机票。",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
              Text("点击每个标题栏上的按钮 ",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
              Icon(Icons.clear, color: Colors.white),
              Text(" 以取消该乘客信息。",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
              Text("完成填写后，点击右上角的按钮 ",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
              Icon(Icons.navigate_next, color: Colors.white),
              Text(" 以进行下一步。",
                style: TextStyle(fontSize: 15, color: Colors.white, ),),
            ],
          ),
          for(int porder = 0; porder < _ticketCount; porder++)
              if(_pageValues[porder]["valid"] == 0)
                formCardList(
                  key: ValueKey(porder),
                  title: "乘客${porder+1}",
                  titleBackground: Colors.purple,
                  trialingButton: IconButton(
                    icon: Icon(Icons.clear, color: Colors.purple,),
                    onPressed: () async {   //仿照例子：https://api.flutter.dev/flutter/material/SimpleDialog-class.html
                      switch (await showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text("确认取消"),
                              content: Text("确认要取消该乘客吗？不可撤销！"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("是"),
                                  onPressed: () => Navigator.of(context).pop(1),
                                ),
                                FlatButton(
                                  child: Text("否"),
                                  onPressed: () => Navigator.of(context).pop(2),
                                ),
                              ],
                            ),
                      )) {
                        case 1: //确认删除用户
                          setState(() =>
                            _pageValues[porder]["valid"] = -1
                          );
                          break;
                        case 2: //不想取消用户，则什么也不做
                          break;
                      }
                    },
                  ),
                  contents: <Widget>[
                    formLineShow("航班号", _fno.toString()),
                    formLineTextField("身份证号", mapFunction(porder), initialize: true, initValue: _pageValues[porder]["身份证号"],),
                    formLineTextField("姓名", mapFunction(porder), initialize: true, initValue: _pageValues[porder]["姓名"],),
                    formLineChooser("国籍", ["中国 - CHN", "其他国家 - OTH"], mapFunction(porder), initialize: true, initValue: _pageValues[porder]["国籍"],),
                    formLineChooser("舱位", ["经济舱", "商务舱", "头等舱",], mapFunction(porder), initialize: true, initValue: _pageValues[porder]["舱位"],),
                    formLineShow("当前价格",
                        "￥${_prices[
                          categoryStringMap[
                            _pageValues[porder]["舱位"]
                          ] - 1
                        ].toString()}"),
                  ],
                ),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
}
