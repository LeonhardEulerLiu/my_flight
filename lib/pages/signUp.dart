import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/common/http.dart';

//还有一些问题：当我们输完密码（如123），再输确认密码（如1234），再改密码至1234，仍然显示不匹配，
//必须动一下确认密码框才可以。这个以后解决。仍然有反应不良的问题。。。已经初步解决

class signupPage extends StatefulWidget {
  static const routeName = "/signUp";

  @override
  _signupPageState createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  bool passwordSame = false;
  Map<String, Object> _pageValues = {
    "姓名": "",
    "身份证号": "",
    "国籍": "中国 - CHN",
    "性别": "男 - M",
    "密码": "",
    "确认密码": "",
    "uno": "5",      //服务器返回
  };

  void changePageValues(Map<String, Object> map) {
    print(map);
    print(_pageValues);
    map.forEach((key, value) {_pageValues[key] = value;
    print("设置$key:$value");});
    print(_pageValues);
  }

  bool checkTwoPasswordSame(String str) {
    setState(() =>
      passwordSame = _pageValues["密码"] == _pageValues["确认密码"]);
    return _pageValues["密码"] == _pageValues["确认密码"];
  }

  @override
  Widget build(BuildContext context) {
    return userFormScaffold(
      form: userForm(
        titleIcon: Icon(Icons.assignment_ind, color: Colors.teal),
        title: "注册",
        formLines: <Widget>[
          formLineTextField("姓名", changePageValues, ),
          formLineTextField("身份证号", changePageValues, ),
          formLineChooser("国籍", ["中国 - CHN", "其他国籍 - OTH"], changePageValues, ),
          formLineChooser("性别", ["男 - M", "女 - F", "不愿提供 - N"], changePageValues, ),
          formLineTextField("密码", changePageValues, password: true, ),
          formLineTextField("确认密码", changePageValues, password: true,
              checkSame: true, checkPasswordSame: checkTwoPasswordSame, ),
        ],
        buttonNumber: 2,
        buttonText: ["注册", "取消"],
        buttonColor: [Colors.blue, Colors.deepOrange],
        onPressed: [() async {
          print("It is the ok button!");
          print(_pageValues);
          if(_pageValues.containsValue("")){     //有些空没填
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('有些空您还没填呢！'),
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
          else if(passwordSame == false){     //确认密码与密码不相同
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('确认密码与密码不相同！'),    //仍然有反应不良的问题，需要解决
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
          else{                 //提示注册成功
            //向服务器传送注册数据
            try{
              Response response = await dio.post("user/front/supply",
                data: {"uno":0, "uid": _pageValues["身份证号"], "nation": _pageValues["国籍"].toString().split(" ")[2],
                       "uname": _pageValues["姓名"], "gender": _pageValues["性别"].toString().split(" ")[2],
                       "password": _pageValues["密码"], "impl": 0});
              print("OK! ${response.data}");
              switch (await showDialog<int>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('提示'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('注册成功。请您牢记您的用户号：'),
                          Text('${response.data}，登录必填！'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('确认'),
                        onPressed: () {
                          Navigator.of(context).pop(1);
                        },
                      ),
                    ],
                  );
                },
              )){
                case 1:
                  Navigator.pop(context);
                  break;
              }
            } catch(e){
              print(e);
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('提示'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('注册数据上传服务器失败！'),
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
        }, () {
          Navigator.pop(context);
        }],
      ),
    );
  }
}
