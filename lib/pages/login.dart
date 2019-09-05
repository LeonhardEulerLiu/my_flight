import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/pages/signUp.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:dio/dio.dart';
import 'package:my_flight/common/http.dart';

class loginPage extends StatefulWidget {
  static const routeName = "/";

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  Map<String, Object> _pageValues = {
    "用户号": "",
    "身份证号": "",
    "密码": "",
    "canPass": "5",    //服务器返回，其实没什么用
  };

  void changePageValues(Map<String, Object> map) => map.forEach((key, value) => _pageValues[key] = value);

  @override
  Widget build(BuildContext context) {
    return userFormScaffold(
      form: userForm(
        titleIcon: Icon(Icons.add_to_home_screen, color: Colors.deepOrange),
        title: "登录",
        formLines: <Widget>[
          formLineTextField("用户号", changePageValues),
          formLineTextField("身份证号", changePageValues, password: true,),
          formLineTextField("密码", changePageValues, password: true,),
        ],
        buttonNumber: 2,
        buttonText: ["登录", "注册"],
        buttonColor: [Colors.blue, Colors.green],
        onPressed: [() async {
          print("It is the button!");
          print(_pageValues);
          //去搜索数据库看看用户名、密码一类的匹不匹配
          if(_pageValues.containsValue("")){
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('你还有空未填。'),
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
            print("Let's go!");
            try{
              Response response = await dio.post("user/front/findByLogin",
                  data: {"uno": _pageValues["用户号"], "uid": _pageValues["身份证号"], "password": _pageValues["密码"]});
              print(response.data);
              if(response.data["uno"] < 0){
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('提示'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('密码或身份证号与用户名不匹配。'),
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
                Navigator.pushNamed(context, myScaffold.routeName[0],
                  arguments: mainPageArgs(response.data["uno"], response.data["uname"], ), );
              }
            } catch(e){
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('提示'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('用户登陆失败。'),
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
          }
        },
          (){
            Navigator.pushNamed(context, signupPage.routeName);
          }],
      ),
    );
  }
}
