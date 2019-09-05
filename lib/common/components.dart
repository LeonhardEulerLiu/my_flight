import 'package:flutter/material.dart';
import 'package:my_flight/pages/searchFlight.dart';
import 'package:my_flight/pages/shiftTravel.dart';
import 'package:my_flight/pages/aboutMe.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:my_flight/pages/choiceDetails.dart';

class myScaffold extends StatefulWidget {
  int _mainPageIndex;

  List<Widget> appBars = [
    searchAppBar(),
    shiftAppBar(),
    null,
  ];
  List<Widget> pages = <Widget>[
    searchFlightBody(),
    shiftTravelBody(),
    aboutMe(),
  ];
  List<FloatingActionButton> buttons = [null, null, null];

  static const List<String> routeName = [
    "/searchFlight", "/shiftTravel", "/aboutMe",
  ];

  myScaffold(this._mainPageIndex);

  @override
  _myScaffoldState createState() => _myScaffoldState();
}

class _myScaffoldState extends State<myScaffold> {

  _myScaffoldState();

  void _onItemTapped(int index){
    setState((){
      widget._mainPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBars[widget._mainPageIndex],
      body: IndexedStack(
        index: widget._mainPageIndex,
        children: widget.pages,
      ),
      bottomNavigationBar: mainNavigBar(mainPageIndex: widget._mainPageIndex,
          onMainBarTapped: _onItemTapped),
      floatingActionButton: widget.buttons[widget._mainPageIndex],
    );
  }
}

//主界面导航栏
class mainNavigBar extends StatelessWidget {
  final int mainPageIndex;
  final Function onMainBarTapped;

  mainNavigBar({@required this.mainPageIndex, @required this.onMainBarTapped});

  void _onItemTapped(int index){
    onMainBarTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chrome_reader_mode),
          title: Text('买票'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplanemode_active),
          title: Text('行程'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('我的'),
        ),
      ],
      currentIndex: mainPageIndex,
      backgroundColor: Colors.blue[900],
      selectedItemColor: Colors.orange[700],
      unselectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}

typedef void goSearch();

//买票：查询框
class searchCard extends StatefulWidget {
  final List<String> cityList;
  final String beginDate;     //注意，根据订票的意义，我们的开始时间取今天与beginDate中的晚者。
  final String endDate;
  final ValueChanged<Map<String, String>> changeMap;
  final DateTime validBeginDate;
  goSearch goToSearch;

  searchCard({@required this.cityList, @required this.beginDate, @required this.endDate,
      @required this.changeMap, this.goToSearch}):
      validBeginDate = DateTime.parse(beginDate).isAfter(DateTime.parse(DateTime.now().toString().split(" ")[0])) ?
        DateTime.parse(beginDate) : DateTime.parse(DateTime.now().toString().split(" ")[0]);  //取今天0点与beginDate中的晚者


  @override
  _searchCardState createState() => _searchCardState();
}

class _searchCardState extends State<searchCard> {
  String depaCity;
  String arivCity;
  String date;
  List<String> cityList;

  @override
  void initState() {
      print("city init!");
      depaCity = (widget.cityList == null || widget.cityList.length < 1) ? "请选择" : cityList[0];
      arivCity = (widget.cityList == null || widget.cityList.length < 1) ? "请选择" : cityList[0];
      date = (DateTime.parse(widget.beginDate).isAfter(DateTime.now()) ? widget.beginDate : DateTime.now()).toString().split(" ")[0];
  }

  void changeDepaCity(String newCity) {
    setState(() {
      depaCity = newCity;
    });
    widget.changeMap({"depaCity": newCity});
  }

  void changeArivCity(String newCity) {
    setState(() {
      arivCity = newCity;
    });
    widget.changeMap({"arivCity": newCity});
  }

  @override
  Widget build(BuildContext context) {
    print("cityList_1: $cityList");
    cityList = (cityList == null || cityList.length < 1) ? widget.cityList : cityList;
    print("cityList_2: $cityList");
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      color: Colors.white60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  GestureDetector(
                    onTap: () => showModalBottomSheet(context: context,
                      builder: (context) => cityPicker(cityList, changeDepaCity),
                    ),
                    child: SizedBox(width: 100,
                      child: Text(depaCity,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),),
                  ),
                  IconButton(
                      icon: Icon(Icons.autorenew,
                          color: Colors.black45),
                      onPressed: () {
                        String temp = depaCity;
                        changeDepaCity(arivCity);
                        changeArivCity(temp);
                      }
                  ),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(context: context,
                      builder: (context) => cityPicker(cityList, changeArivCity),
                    ),
                    child: SizedBox(width: 100,
                      child: Text(arivCity,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.right,),),
                  ),
                ]
            ),
            Divider(color: Colors.black45,),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                DateTime selectedDate = await showDatePicker(
                    context: context,
                    //取今天与beginDate中的晚者
                    initialDate: DateTime.parse(date),
                    firstDate: widget.validBeginDate,
                    lastDate: DateTime.parse(widget.endDate),
                    builder: (BuildContext context, Widget child) {
                      return child;
                    }
                );
                String newDate = selectedDate == null ? date : selectedDate.toString().split(" ")[0];
                widget.changeMap({"date": newDate});
                setState(() {
                  date = newDate;
                });
              },
              child: Row(children:[
                Text(date,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,))
              ]),
            ),
            SizedBox(height: 20),
            Row(children:[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    widget.goToSearch ??= () => print("Nothing");
                    widget.goToSearch();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                        '查询',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

//改签：只能修改时间的查询框
class changeQueryCard extends StatefulWidget {
  final String beginDate;
  final String endDate;
  final String originalDate;    //格式："2018-09-30"
  final String depaCity;
  final String arivCity;
  final DateTime validBeginDate;

  changeQueryCard({@required this.beginDate, @required this.endDate, @required this.depaCity,
                  @required this.arivCity, @required this.originalDate,}):
        validBeginDate = DateTime.parse(beginDate).isAfter(DateTime.parse(DateTime.now().toString().split(" ")[0])) ?
          DateTime.parse(beginDate) : DateTime.parse(DateTime.now().toString().split(" ")[0]);  //取今天0点与beginDate中的晚者

  @override
  _changeQueryCardState createState() => _changeQueryCardState();
}

class _changeQueryCardState extends State<changeQueryCard> {
  String date;

  @override
  void initState(){
    DateTime origin = DateTime.parse(widget.originalDate);
    DateTime begin = DateTime.parse(widget.beginDate);
    DateTime now = DateTime.now();
    DateTime temp;
    if(begin.isAfter(now))
      temp = begin;
    else
      temp = now;
    if(origin.isAfter(temp))
      temp = origin;
    date = temp.toString().split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("您正准备改签${widget.originalDate.split("-")[0]}年${widget.originalDate.split("-")[1]}月的航班：", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),)
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("提示：根据规定，您只能修改出发时间", style: TextStyle(fontSize: 17, ),)
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white60,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      SizedBox(width: 100,
                        child: Text(widget.depaCity,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),),
                      Icon(Icons.fast_forward,
                          color: Colors.black45),
                      SizedBox(width: 100,
                        child: Text(widget.arivCity,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.right,),),
                    ]
                ),
                Divider(color: Colors.black45,),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () async {
                    DateTime selectedDate = await showDatePicker(
                        context: context,
                        //取今天与beginDate中的晚者
                        initialDate: DateTime.parse(date),
                        firstDate: widget.validBeginDate,
                        lastDate: DateTime.parse(widget.endDate),
                        builder: (BuildContext context, Widget child) {
                          return child;
                        }
                    );
                    String newDate = selectedDate == null ? date : selectedDate.toString().split(" ")[0];
                    setState(() {
                      date = newDate;
                    });
                  },
                  child: Row(children:[
                    Text(date,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,))
                  ]),
                ),
                SizedBox(height: 20),
                Row(children:[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => Navigator.pop(context, date),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.blue,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                            '改签',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => Navigator.pop(context, ""),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.teal,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                            '取消',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class cityPicker extends StatelessWidget {
  final List<String> cities;  /* = ["济南", "广州", "阿德莱德", ]; */
  final ValueChanged<String> picked;

  cityPicker(this.cities, this.picked);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for(String city in cities) ListTile(
          title: Text('$city'),
          onTap: () {
            picked(city);
            Navigator.pop(context, city);
          },
        ),
      ],
    );
  }
}

class remainingTickets {
  final String prefix;
  final String pname;
  final int firstClass;
  final int business;
  final int economy;

  remainingTickets(this.prefix, this.pname, this.firstClass, this.business, this.economy);
}

//买票：梗概框
class saleOutline extends StatefulWidget {
  final String depaTime;
  final String arivDateTime;
  final String depaCname;
  final String arivCname;
  final num rawPrice;
  final List<remainingTickets> remains;
  final int price;
  final int shiftCount;
  final flightDetailsArgs tripDetail;
  UniqueKey key;

  saleOutline({@required this.depaTime, @required this.arivDateTime, @required this.depaCname,
              @required this.arivCname, @required this.rawPrice, @required this.remains, @required this.tripDetail, this.key}):
              price = rawPrice.ceil(), shiftCount = remains?.length - 1;

  @override
  _saleOutlineState createState() => _saleOutlineState();
}

class _saleOutlineState extends State<saleOutline> with SingleTickerProviderStateMixin {
  bool spread = false;
  AnimationController menuController;
  final List<Icon> numIcons = [
    null, Icon(Icons.filter_1), Icon(Icons.filter_2), Icon(Icons.filter_3), Icon(Icons.filter_4),
    Icon(Icons.filter_5), Icon(Icons.filter_6), Icon(Icons.filter_7), Icon(Icons.filter_8),
    Icon(Icons.filter_9), Icon(Icons.filter_9_plus),
  ];

  @override
  void initState(){
    super.initState();
    menuController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 5000),
    );
    menuController.forward();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  void _onTapMenu() {
    setState(() {
      if(spread){
        menuController.forward();
      }
      else{
        menuController.reverse();
      }
      spread = !spread;
    });
  }

  //下面build()中GestureDetector不够灵敏。你有什么好主意吗？
  void _onTapGo() =>
    //我们准备在这里直接进入下一个页面。请在这里展示进入下一个页面所需要的参数类。
    Navigator.pushNamed(context, choiceDetailsPage.routeName, arguments: widget.tripDetail);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                  children: [
                    GestureDetector(
                      onTap: _onTapGo,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          FlutterLogo(size: 50),
                          SizedBox(height: 5),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.transfer_within_a_station, color: Colors.cyan),
                                Text("${widget.shiftCount}次"),
                              ]
                          )
                        ],
                      ),
                    ),
                    GestureDetector(onTap: _onTapGo, child: SizedBox(width: 15),),
                    GestureDetector(onTap: _onTapGo, child: timePortBlock(widget.depaTime, widget.depaCname),),
                    GestureDetector(onTap: _onTapGo, child: SizedBox(width: 15)),
                    GestureDetector(
                      onTap: _onTapGo,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[Icon(Icons.fast_forward, color: Colors.blue,),],
                      ),
                    ),
                    GestureDetector(onTap: _onTapGo, child: SizedBox(width: 15)),
                    GestureDetector(onTap: _onTapGo, child: timePortBlock(widget.arivDateTime, widget.arivCname)),
                    Spacer(),
                    GestureDetector(
                      onTap: _onTapMenu,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Text("￥${widget.price} 起",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange, ),),
                            SizedBox(height: 15),
                            AnimatedIcon(
                              icon: AnimatedIcons.close_menu,
                              progress: menuController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
              if(spread) SizedBox(height: 15,),
              if(spread) Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(50.0),
                  1: FixedColumnWidth(80.0),
                  2: FixedColumnWidth(80.0),
                  3: FixedColumnWidth(50.0),
                  4: FixedColumnWidth(50.0),
                  5: FixedColumnWidth(50.0),
                },
                border: TableBorder(
                  top: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                  bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                  horizontalInside: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Text('', style: TextStyle(fontSize: 17,),),
                      Text('航班号', style: TextStyle(fontSize: 17,),),
                      Text('机型', style: TextStyle(fontSize: 17,),),
                      Text('头等', style: TextStyle(fontSize: 17,),),
                      Text('商务', style: TextStyle(fontSize: 17,),),
                      Text('经济', style: TextStyle(fontSize: 17,),),
                    ],
                  ),
                  for(int i=0; i<widget.remains.length; i++) TableRow(
                    children: <Widget>[
                      numIcons[i+1],
                      Text(widget.remains[i].prefix, style: TextStyle(fontSize: 17,),),
                      Text(widget.remains[i].pname, style: TextStyle(fontSize: 17,),),
                      Text(widget.remains[i].firstClass.toString(), style: TextStyle(fontSize: 17,),),
                      Text(widget.remains[i].business.toString(), style: TextStyle(fontSize: 17,),),
                      Text(widget.remains[i].economy.toString(), style: TextStyle(fontSize: 17,),),
                    ],
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}

class timePortBlock extends StatelessWidget {
  final String time;
  final String port;
  String portA, portB;

  timePortBlock(this.time, this.port){
    if(port.length <= 4){
      portA = port;
      portB = "";
    }
    else if(port.length <= 8){
      portA = port.substring(0, 4);
      portB = port.substring(4);
    }
    else{
      portA = port.substring(0, 4);
      portB = port.substring(4, 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(time, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
        Text(portA, style: TextStyle(fontSize: 15,),),
        Text(portB, style: TextStyle(fontSize: 15,),),
      ],
    );
  }
}

//买票：行程（可以重用于行程）
class flightStepBox extends StatelessWidget {
  final Color color;
  final bool showTickets;
  final int depaDay;
  final String depaTime;
  final String depaIata;
  final String depaCname;
  final int arivDay;
  final String arivTime;
  final String arivIata;
  final String arivCname;
  final String prefix;
  final String pname;
  final int firstClass;
  final int business;
  final int economy;

  flightStepBox({
    @required this.depaDay, @required this.depaTime, @required this.depaIata, @required this.depaCname,
    @required this.arivDay, @required this.arivTime, @required this.arivIata, @required this.arivCname,
    @required this.prefix,  @required this.pname,  this.color = Colors.white, this.showTickets = false,
    this.firstClass = 0, this.business = 0, this.economy = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
//      margin: const EdgeInsets.symmetric(vertical: 10),
//      margin: const EdgeInsets.only(top: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: showTickets ? 175 : 155,
        child: Row(
          children:[
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  SizedBox(height: 22),
                  Text("$depaDay日$depaTime", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 30),
                  Text("$arivDay日$arivTime", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  Spacer(),
                ]
            ),
            VerticalDivider(color: Colors.grey, indent: 20, endIndent: 55,),
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  SizedBox(height: 22),
                  Text("$depaIata  $depaCname", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 30),
                  Text("$arivIata  $arivCname", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 10),
                  Text("航班：$prefix | 机型：$pname",  style: TextStyle(fontSize: 15, color: Colors.blue),),
                  if(showTickets) Text("头等：$firstClass   商务：$business   经济：$economy", style: TextStyle(fontSize: 15, color: Colors.orange[800]),),
                  Spacer(),
                ]
            ),
          ],
        ),
      ),
    );
  }
}

class waitStepBox extends StatelessWidget {
  final int days;
  final int hours;
  final int minutes;

  waitStepBox({this.days = 0, this.hours = 0, this.minutes = 0});

  String estimate(){
    if(days != 0)
      return "约$days天";
    else if(hours != 0)
      return "约$hours小时";
    else
      return "约$minutes分钟";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Card(
//          color: Colors.teal[300],
          child: Container(
            height: 40,
            width: 250,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text("休息", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(width: 50),
                  Text(estimate(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                ],
              ),
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Colors.teal[400],
                    Colors.teal[200],
                    Colors.teal[50],
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//买票：行程确认指示框（可以重用作页面指示框）
//提示：下面给出了列表的使用参考：
//<Widget>[
//  Text("请查看下面的行程。",
//    style: TextStyle(fontSize: 15, color: Colors.white, ), ),
//  Text("如果您确信这就是您所要的行程，",
//    style: TextStyle(fontSize: 15, color: Colors.white, ), ),
//  Text("点击右上角的按钮 ",
//    style: TextStyle(fontSize: 15, color: Colors.white, ), ),
//  Icon(Icons.navigate_next, color: Colors.white,),
//  Text(" 以开始订购机票。",
//    style: TextStyle(fontSize: 15, color: Colors.white, ), ),
//],
class instructionBox extends StatelessWidget {
  final List<Widget> textGroup;

  instructionBox(this.textGroup);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0, ),
          child: Wrap(
            children: textGroup,
          ),
        ),
      ),
    );
  }
}

//必须写上形参名字str，否则将会识别为(dynamic)=>bool而不是(String)=>bool函数类型。
typedef bool isSame(String str);

//买票：用户表单行（可以重用于行程、注册）
class formLineTextField extends StatefulWidget {
  final String title;
  final bool password;
  String inValue = "";
  ValueChanged<Map<String, Object>> parentChange;
  final bool checkSame;
  isSame checkPasswordSame;
  bool initialize;
  String initValue;

  formLineTextField(this.title, this.parentChange, {this.password = false,
                    this.checkSame = false, this.checkPasswordSame, this.initialize = false,
                    this.initValue = ""});

  @override
  _formLineTextFieldState createState() => _formLineTextFieldState();
}

class _formLineTextFieldState extends State<formLineTextField> {
  int _status = 0;
  bool isSamePassword = false;    //搬到State中才会保持状态！

  final List<Icon> icons = [
    null,
    Icon(Icons.check, color: Colors.green),
    Icon(Icons.clear, color: Colors.red),
    Icon(Icons.clear, color: Colors.red),
  ];

  final List<String> tips = [
    null,
    null,
    "不能为空！",
    "确认密码与密码不相同！",
  ];

  final _controller = TextEditingController();

  @override
  void initState(){
    _controller.addListener((){
      final text = _controller.text;
      if(text.length > 0){
        if(!widget.checkSame || isSamePassword){
          setState(() {
            _status = 1;
          });
        }
        else{
          setState(() {
            _status = 3;
          });
        }
      }
      else{
        setState(() {
          _status = 2;
        });
      }
    });
    super.initState();
    if(widget.initialize)
      setState(() {
        _controller.text = widget.initValue;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 60,
              child: TextField(
                obscureText: widget.password,
                textAlignVertical: TextAlignVertical.bottom,
                //在checkPasswordSame发生了许多事情【因为判断有步骤上的延迟】。最初它是ValueChanged<String>类型（即(String)=>(void)类型），
                //但是因为如下原因被弃置：
                //1. _controller会在文本改变之后首先调用，之后才执行onChanged里面的语句。这导致它里面的状态判断在onChanged的语句执行之前就
                //   执行了。因此，我们特意在onChanged里面粘贴了initState里面的部分if语句，为的就是在调用widget.checkPasswordSame(value)
                //   之后才判断。
                //2. 令人震惊的是，即使调用了widget.checkPasswordSame(value)之后，即使在父亲组件里setState里面是正确的值，如果你在onChanged
                //   里面，widget.checkPasswordSame(value)语句之后调用widget.isSamePassword还是保持原来的值，而不是改变的值（所以是错的）。
                //   我猜想这是因为onChanged函数没有执行完，因此还留在旧部件内，等onChanged执行完后才更新组件。我们只好设法让widget.checkPasswordSame(value)
                //   返回值，因此我们只能放弃ValueChanged<String>类型，改用(String)=>(bool)类型。（官方就是这么表示函数类型的）
                //3. 所以我们使用了typedef来定义了一个自定义的函数类型(String)=>(bool)，并在父亲函数中做了函数类型的调整。现在应该运转正常
                //   了。另外，typedef中，必须写上形参名字str，否则将会识别为(dynamic)=>bool而不是(String)=>bool函数类型。
                //Happy coding!
                onChanged: (value) {
                  widget.inValue = value;
                  widget.parentChange({widget.title: value, });
                  bool result;
                  if(widget.checkSame) {
                    result = widget.checkPasswordSame(value);
                    isSamePassword = result;
                    print(result);
                  }
                  if(value.length > 0){
                    if(!widget.checkSame || result){
                      setState(() {
                        _status = 1;
                      });
                    }
                    else{
                      setState(() {
                        _status = 3;
                      });
                    }
                  }
                  else{
                    setState(() {
                      _status = 2;
                    });
                  }
                },
                controller: _controller,
                decoration: InputDecoration(
                  helperText: tips[_status],
//                    labelText: widget.title,
                  suffixIcon: icons[_status],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class formLineChooser extends StatefulWidget {
  final String title;
  final List<String> options;
  ValueChanged<Map<String, Object>> parentChange;
  bool initialize;
  String initValue;

  formLineChooser(this.title, this.options, this.parentChange,
    {this.initialize = false, this.initValue = ""});

  @override
  _formLineChooserState createState() => _formLineChooserState();
}

class _formLineChooserState extends State<formLineChooser> {
  String dropdownValue;

  @override
  void initState(){
    if(widget.initialize)
      setState(() {
        dropdownValue = widget.initValue;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: DropdownButton<String>(
                value: dropdownValue ?? widget.options[0],
                onChanged: (String newValue) {
                  widget.parentChange({widget.title: newValue, });    //在前在后没有任何问题
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: widget.options
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class formLineShow extends StatelessWidget {
  final String title;
  final String value;

  formLineShow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 220,
              child: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,), softWrap: true)
          ),
        ],
      ),
    );
  }
}

//对话栏选项
enum deleteOptions {ok, cancel}

//AppBar--带垃圾桶图标
class trashTitleBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String delTitle;
  bool showTrashIcon;

  trashTitleBar(this.title, this.delTitle, {this.showTrashIcon = true});

  @override
  _trashTitleBarState createState() => _trashTitleBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);    //貌似56是默认高度
}

class _trashTitleBarState extends State<trashTitleBar> {
  //参见SimpleDialog相关文档：它高度集成化
  WidgetBuilder dialogBuilder = (context) => SimpleDialog(
    title: const Text("确认要删除所选项吗？"),
    children: <Widget>[
      SimpleDialogOption(
        onPressed: () {
          print("ok");
          Navigator.pop(context, 0);  //or deleteOptions.ok, type is deleteOptions
        },
        child: const Text("是"),
      ),
      SimpleDialogOption(
        onPressed: () {
          print("no");
          Navigator.pop(context, 1);  //or deleteOptions.cancel, type is deleteOptions
        },
        child: const Text("否"),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.showTrashIcon ? widget.delTitle : widget.title),
      actions: <Widget>[
        if(widget.showTrashIcon) IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "删除票",
            onPressed: (){
              print("deleting...");
              setState((){
                widget.showTrashIcon = false;
              });
            }
        ),
        if(!widget.showTrashIcon) IconButton(
            icon: const Icon(Icons.check),
            tooltip: "删除",
            onPressed: () async {
              int result = await showDialog<int>(
                  context: context,
                  builder: dialogBuilder
              );
              //另一种你更喜欢的对话框方式AlertDialog见如下文档的示例框：一点也不难！
              //https://api.flutter.dev/flutter/material/AlertDialog-class.html
              switch(result){
                case 0:
                  print("Get 0");
                  break;
                case 1:
                  print("Get 1");
                  break;
              }
              setState(() {
                widget.showTrashIcon = true;
              });
            }
        ),
        if(!widget.showTrashIcon) IconButton(
          icon: const Icon(Icons.clear),
          tooltip: "其他",
          onPressed: (() {
            print("canceled!");
            setState(() {
              widget.showTrashIcon = true;
            });
          }),
        ),
      ],
    );
  }
}

typedef void saveExpanded(int index, bool newState);

//请不要在表单处使用formPanelList组件，会崩溃。可以用该组件来展示信息(statelessWidget)，且不能用bool列表控制开闭。
//formPanelList的表单替代方案见formCardList，请在passForm.dart中参考它的使用。
class formPanelInfo {
  final String title;
  final List<Widget> lines;
  bool isExpanded;
  final bool selectable;
  bool isReadyToDel;
  final IconButton trailingIconButton;

  formPanelInfo(this.title, this.lines, {this.isExpanded = false,
    this.selectable = false, this.isReadyToDel = false,
    this.trailingIconButton = null,});
}

//买票：用户表单（可以重用于行程、注册）
//使用方法：
//   ListView(
//    children: <Widget>[
//      formPanelList([
//        formPanelInfo(
//          "123",
//          <Widget>[
//            formLineTextField("身份证号"),
//            formLineTextField("身份证号"),
//            formLineChooser("国籍", <String>['One', 'Two', 'Free', 'Four']),
//            formLineShow('过激', "香港是不可侵犯的！哈哈哈哈哈哈哈哈哈哈哈哈"),
//        ],),
//        formPanelInfo(
//          "123",
//          <Widget>[
//            formLineTextField("身份证号"),
//            formLineTextField("身份证号"),
//            formLineChooser("国籍", <String>['One', 'Two', 'Free', 'Four']),
//            formLineShow('过激', "香港是不可侵犯的！哈哈哈哈哈哈哈哈哈哈哈哈"),
//        ],),
//      ]),
//    ],
//  ),
class formPanelList extends StatefulWidget {
  List<formPanelInfo> info;

  formPanelList(this.info);

  @override
  _formPanelListState createState() => _formPanelListState();
}

class _formPanelListState extends State<formPanelList> {

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded){
        setState((){
          widget.info[index].isExpanded = !isExpanded;
        });
      },
      children: widget.info.map<ExpansionPanel>((formPanelInfo info){
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded){
            return ListTile(
              title: Text(info.title),
              leading: info.selectable ?
              Checkbox(
                value: info.isReadyToDel,
                onChanged: (checked){
                  print(info.title + ": $checked");
                  setState(() {
                    info.isReadyToDel = checked;
                  });
                },
              )
              : null,
              trailing: info.trailingIconButton,
            );
          },
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Column(
              children: [
                ...info.lines,
//                SizedBox(height: 15,),
//                Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: RaisedButton(
//                        onPressed: () => print("05"),
//                        textColor: Colors.white,
//                        padding: const EdgeInsets.all(0.0),
//                        color: Colors.red,
//                        child: Container(
//                          padding: const EdgeInsets.all(10.0),
//                          child: const Text(
//                            '取消',
//                            style: TextStyle(fontSize: 20)
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
              ],
            ),
          ),
          isExpanded: info.isExpanded,
        );
      }).toList(),
    );
  }
}

class formCardList extends StatelessWidget {
  final String title;
  final Color titleBackground;
  final IconButton trialingButton;
  final List<Widget> contents;
  ValueKey key;

  formCardList({@required this.title, @required this.contents, this.titleBackground = Colors.purple,
                this.trialingButton = null, this.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(
                    label: Text(title, style: TextStyle(color: Colors.white),),
                    backgroundColor: titleBackground,
                  ),
                  trialingButton,
                ],
              ),
            ),
            ...contents,
          ],
        ),
      ),
    );
  }
}

//退票：确认对话框
//参见_trashTitleBarState类，它使用一个SimpleDialog与showDiaialog方法来处理用户点击
//“取消”按钮的情况。
//到了具体页面再耦合才有意义。

//用户管理：注册框。注意到登录框、修改密码框等与其类似
class userForm extends StatefulWidget {
  final Icon titleIcon;
  final String title;
  final List<Widget> formLines;
  final int buttonNumber;   // 1 or 2
  final List<String> buttonText;
  final List<Color> buttonColor;
  final List<VoidCallback> onPressed;

  userForm({@required this.titleIcon, @required this.title, @required this.formLines,
            @required this.buttonNumber, @required this.buttonText, @required this.buttonColor,
            @required this.onPressed});

  @override
  _userFormState createState() => _userFormState();
}

class _userFormState extends State<userForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20,),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.titleIcon,
                    SizedBox(width: 20),
                    Text("${widget.title}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  ],
                ),
                ...widget.formLines,
                Row(children:[
                  Expanded(
                    child: RaisedButton(
                      onPressed: widget.onPressed[0],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      color: widget.buttonColor[0],
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            '${widget.buttonText[0]}',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                    ),
                  ),
                  if(widget.buttonNumber == 2) SizedBox(width: 10),
                  if(widget.buttonNumber == 2) Expanded(
                    child: RaisedButton(
                      onPressed: widget.onPressed[1],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      color: widget.buttonColor[1],
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            '${widget.buttonText[1]}',
                            style: TextStyle(fontSize: 20)
                        ),
                      ),
                    ),
                  ),
                  ]
                ),
              ]
          ),
        ),
      ),
    );
  }
}

//用户管理：注册页。里面以注册框为参数，主要定义页面外观
class userFormScaffold extends StatelessWidget {
  userForm form;

  userFormScaffold({@required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[800],
              Colors.blue,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: form,
        ),
      ),
    );
  }
}

//鸣谢（虽然直接拿有点不好 :( ）bilibili为我提供图片资源
//“暂无”组件。在没有列表项等可以用这个组件作为提示。可以用于flightsChoice.dart,
// shiftTravel.dart, 以及returnTicket.dart。
class notFound extends StatelessWidget {
  final String lackThing;

  notFound(this.lackThing);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset("images/bilibiliError.jpg"),
          Text("暂未找到$lackThing，抱歉！", style: TextStyle(fontSize: 20, ),)
        ],
      ),
    );
  }
}

class loadingTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset("images/bilibiliLoading.jpg"),
          Text("请稍后....", style: TextStyle(fontSize: 20, ),)
        ],
      ),
    );
  }
}
