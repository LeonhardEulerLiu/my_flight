import 'package:flutter/material.dart';

//这个文件与components.dart相对应，是没有被参数化的具体示例部件。
//我们先写的示例部件，再参数化。这样一旦参数化失败，可以重新引用它。

class R_myScaffold extends StatefulWidget {
  final List<Widget> appBars;
  final List<Widget> pages;

  R_myScaffold(this.appBars, this.pages);

  @override
  _R_myScaffoldState createState() => _R_myScaffoldState();
}

class _R_myScaffoldState extends State<R_myScaffold> {
  int _mainPageIndex = 0;

  _R_myScaffoldState();

  void _onItemTapped(int index){
    setState((){
      _mainPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBars[_mainPageIndex],
      body: widget.pages[_mainPageIndex],
      bottomNavigationBar: R_mainNavigBar(mainPageIndex: _mainPageIndex,
          onMainBarTapped: _onItemTapped),
      floatingActionButton: FloatingActionButton(
        tooltip: "Change ticket",
        child: Icon(Icons.border_color),
        onPressed: null,
      ),
    );
  }
}

//主界面导航栏
class R_mainNavigBar extends StatelessWidget {
  final int mainPageIndex;
  final Function onMainBarTapped;

  R_mainNavigBar({@required this.mainPageIndex, @required this.onMainBarTapped});

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

//买票：查询框
class R_searchCard extends StatefulWidget {
  @override
  _R_searchCardState createState() => _R_searchCardState();
}

class _R_searchCardState extends State<R_searchCard> {
  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => R_cityPicker(),
                    ),
                    child: SizedBox(width: 100,
                      child: Text('济南',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),),
                  ),
                  IconButton(
                      icon: Icon(Icons.autorenew,
                          color: Colors.black45),
                      onPressed: () => print("2")
                  ),
                  GestureDetector(
                    onTap: () => R_cityPicker(),
                    child: SizedBox(width: 100,
                      child: Text('济南',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.right,),),
                  ),
                ]
            ),
            Divider(color: Colors.black45,),
            SizedBox(height: 5),
            GestureDetector(
              onTap: (){
                Future<DateTime> selectedDate = showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return child;
                    }
                );
                print(selectedDate.toString());
              },
              child: Row(children:[
                Text("2010-10-10",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,))
              ]),
            ),
            SizedBox(height: 20),
            Row(children:[
              Expanded(
                child: RaisedButton(
                  onPressed: () => print("05"),
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
class R_changeQueryCard extends StatefulWidget {
  @override
  _R_changeQueryCardState createState() => _R_changeQueryCardState();
}

class _R_changeQueryCardState extends State<R_changeQueryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("您正准备改签#1号航班：", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),)
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
                        child: Text('济南',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),),
                      Icon(Icons.fast_forward,
                          color: Colors.black45),
                      SizedBox(width: 100,
                        child: Text('济南',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.right,),),
                    ]
                ),
                Divider(color: Colors.black45,),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: (){
                    Future<DateTime> selectedDate = showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return child;
                        }
                    );
                    print(selectedDate.toString());
                  },
                  child: Row(children:[
                    Text("2010-10-10",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,))
                  ]),
                ),
                SizedBox(height: 20),
                Row(children:[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => print("05"),
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
                      onPressed: () => print("06"),
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

class R_cityPicker extends StatelessWidget {
  List<String> cities = ["济南", "广州", "阿德莱德", ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for(String city in cities) ListTile(
          title: Text('$city'),
          onTap: ()=>print('$city is selected.'),
        ),
      ],
    );
  }
}

//买票：梗概框
class R_saleOutline extends StatefulWidget {
  @override
  _R_saleOutlineState createState() => _R_saleOutlineState();
}

class _R_saleOutlineState extends State<R_saleOutline> with SingleTickerProviderStateMixin {
  bool spread = false;
  AnimationController menuController;

  @override
  void initState(){
    super.initState();
    menuController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 5000),
    );
  }

  _onTapMenu() {
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        FlutterLogo(size: 50),
                        SizedBox(height: 5),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.transfer_within_a_station, color: Colors.cyan),
                              Text("1次"),
                            ]
                        )
                      ],
                    ),
                    SizedBox(width: 15),
                    R_timePortBlock("10:50", "北京首都国际机场"),
                    SizedBox(width: 15),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children:[Icon(Icons.fast_forward, color: Colors.blue,),],
                    ),
                    SizedBox(width: 15),
                    R_timePortBlock("31日10:50", "北京首都国际机场"),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _onTapMenu();
                      },
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Text("￥88888", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
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
                children: const <TableRow>[
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
                  TableRow(
                    children: <Widget>[
                      Icon(Icons.filter_1),
                      Text('LT235', style: TextStyle(fontSize: 17,),),
                      Text('A333-A7', style: TextStyle(fontSize: 17,),),
                      Text('11', style: TextStyle(fontSize: 17,),),
                      Text('23', style: TextStyle(fontSize: 17,),),
                      Text('234', style: TextStyle(fontSize: 17,),),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Icon(Icons.filter_2),
                      Text('LT235', style: TextStyle(fontSize: 17,),),
                      Text('A333-A7', style: TextStyle(fontSize: 17,),),
                      Text('11', style: TextStyle(fontSize: 17,),),
                      Text('23', style: TextStyle(fontSize: 17,),),
                      Text('234', style: TextStyle(fontSize: 17,),),
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

class R_timePortBlock extends StatelessWidget {
  final String time;
  final String port;
  String portA, portB;

  R_timePortBlock(this.time, this.port){
    if(port.length <= 4){
      portA = port;
      portB = "";
    }
    else{
      portA = port.substring(0, 4);
      portB = port.substring(4);
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
class R_flightStepBox extends StatelessWidget {
  final Color color;

  R_flightStepBox({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
//      margin: const EdgeInsets.symmetric(vertical: 10),
//      margin: const EdgeInsets.only(top: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 175,
        child: Row(
          children:[
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  SizedBox(height: 22),
                  Text("24日10:30", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 30),
                  Text("2日1:30", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
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
                  Text("PEK  北京首都国际机场", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 30),
                  Text("HKG  北京首都国际机场", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 10),
                  Text("航班：LT375 | 机型：A333-A7",  style: TextStyle(fontSize: 15, color: Colors.blue),),
                  Text("头等：15   商务：12   经济：250", style: TextStyle(fontSize: 15, color: Colors.orange[800]),),
                  Spacer(),
                ]
            ),
          ],
        ),
      ),
    );
  }
}

class R_waitStepBox extends StatelessWidget {
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
                  Text("约5小时", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
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

//买票：用户表单行（可以重用于行程、注册）
class R_formLineTextField extends StatefulWidget {
  final String title;
  final bool password;
  String inValue = "";

  R_formLineTextField(this.title, {this.password = false,});

  @override
  _R_formLineTextFieldState createState() => _R_formLineTextFieldState();
}

class _R_formLineTextFieldState extends State<R_formLineTextField> {
  int _status = 0;

  final List<Icon> icons = [
    null,
    Icon(Icons.check, color: Colors.green),
    Icon(Icons.clear, color: Colors.red),
  ];

  final List<String> tips = [
    null,
    null,
    "不能为空！",
  ];

  final _controller = TextEditingController();

  void initState(){
    _controller.addListener((){
      final text = _controller.text;
      if(text.length > 0){
        setState(() {
          _status = 1;
        });
      }
      else{
        setState(() {
          _status = 2;
        });
      }
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
                onSubmitted: (value) {
                  print(value);
                  widget.inValue = value;
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

class R_formLineChooser extends StatefulWidget {
  final String title;
  final List<String> options;

  R_formLineChooser(this.title, this.options);

  @override
  _R_formLineChooserState createState() => _R_formLineChooserState();
}

class _R_formLineChooserState extends State<R_formLineChooser> {
  String dropdownValue;

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

class R_formLineShow extends StatelessWidget {
  final String title;
  final String value;

  R_formLineShow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
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
enum R_deleteOptions {ok, cancel}

//AppBar--带垃圾桶图标
class R_trashTitleBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String delTitle;
  bool showTrashIcon;

  R_trashTitleBar(this.title, this.delTitle, {this.showTrashIcon = true});

  @override
  _R_trashTitleBarState createState() => _R_trashTitleBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);    //貌似56是默认高度
}

class _R_trashTitleBarState extends State<R_trashTitleBar> {
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

class R_formPanelInfo {
  final String title;
  final List<Widget> lines;
  bool isExpanded;
  bool isReadyToDel;

  R_formPanelInfo(this.title, this.lines, {this.isExpanded = false, this.isReadyToDel = false});
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
class R_formPanelList extends StatefulWidget {
  List<R_formPanelInfo> info;

  R_formPanelList(this.info);

  @override
  _R_formPanelListState createState() => _R_formPanelListState();
}

class _R_formPanelListState extends State<R_formPanelList> {

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded){
        setState((){
          widget.info[index].isExpanded = !isExpanded;
        });
      },
      children: widget.info.map<ExpansionPanel>((R_formPanelInfo info){
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded){
            return ListTile(
              title: Text(info.title),
              leading: Checkbox(
                value: info.isReadyToDel,
                onChanged: (checked){
                  print(info.title + ": $checked");
                  setState(() {
                    info.isReadyToDel = checked;
                  });
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.border_color),
                onPressed: () => showModalBottomSheet(context: context,
                  builder: (context) => R_changeQueryCard(),
                ),
              ),
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

//退票：确认对话框
//参见_trashTitleBarState类，它使用一个SimpleDialog与showDiaialog方法来处理用户点击
//“取消”按钮的情况。
//到了具体页面再耦合才有意义。

//About Me的酷炫页面：自定义标题栏
class R_aboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("刘涛是坏蛋", style: TextStyle(
              color: Colors.black,
            )),
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
            background: Image.asset("images/electricPlane.jpg", fit: BoxFit.fill,),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
              [
                ListTile(
                  title: Text("修改密码"),
                  leading: Icon(Icons.build),
                ),
              ]
          ),
        ),
      ],
    );
  }
}

//用户管理：注册框。注意到登录框、修改密码框等与其类似
class R_userForm extends StatefulWidget {
  @override
  _R_userFormState createState() => _R_userFormState();
}

class _R_userFormState extends State<R_userForm> {
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
                    Icon(Icons.contact_mail, color: Colors.teal,),
                    SizedBox(width: 20),
                    Text("登录", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  ],
                ),
                R_formLineTextField("姓名"),
                R_formLineTextField("身份证号"),
                R_formLineChooser("国籍", ["CHN", "其他"]),
                R_formLineChooser("性别", ["M", "F", "N"]),
                R_formLineTextField("密码", password: true,),
                R_formLineTextField("确认密码", password: true,),
                Row(children:[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => print("05"),
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
//                  SizedBox(width: 10),
//                  Expanded(
//                    child: RaisedButton(
//                      onPressed: () => print("06"),
//                      textColor: Colors.white,
//                      padding: const EdgeInsets.all(0.0),
//                      color: Colors.teal,
//                      child: Container(
//                        padding: const EdgeInsets.all(10.0),
//                        child: const Text(
//                            '取消',
//                            style: TextStyle(fontSize: 20)
//                        ),
//                      ),
//                    ),
//                  ),
                  ]
                ),
              ]
          ),
        ),
      ),
    );
  }
}
