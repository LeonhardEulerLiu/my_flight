import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:dio/dio.dart';
import 'package:my_flight/common/http.dart';

//还有一些问题：当我们输完密码（如123），再输确认密码（如1234），再改密码至1234，仍然显示不匹配，
//必须动一下确认密码框才可以。这个以后解决。

class changePasswordPage extends StatefulWidget {
  static const routeName = "/changePassword";

    @override
    _changePasswordPageState createState() => _changePasswordPageState();
}

class _changePasswordPageState extends State<changePasswordPage> {
  bool passwordSame = false;
  Map<String, Object> _pageValues = {
    "用户号": "",
    "原密码": "",
    "新密码": "",
    "确认密码": "",
  };
  void changePageValues(Map<String, Object> map) => map.forEach((key, value) => _pageValues[key] = value);

  bool checkTwoPasswordSame(String str) {
    setState(() =>
      passwordSame = _pageValues["新密码"] == _pageValues["确认密码"]);
    return _pageValues["新密码"] == _pageValues["确认密码"];
  }

  @override
  Widget build(BuildContext context) {
    final mainPageArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());
    _pageValues["用户号"] = args.uno;

    return userFormScaffold(
        form: userForm(
          titleIcon: Icon(Icons.cached, color: Colors.red),
          title: "修改密码",
          formLines: <Widget>[
            SizedBox(height: 15),
            formLineShow("用户号", args.uno.toString()),
            formLineTextField("原密码",  changePageValues, password: true,),
            formLineTextField("新密码", changePageValues, password: true,),
            formLineTextField("确认密码", changePageValues, password: true,
                checkSame: true, checkPasswordSame: checkTwoPasswordSame,),
          ],
          buttonNumber: 2,
          buttonText: ["修改", "取消"],
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
                          Text('确认密码与密码不相同！'),
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
              try{
                Response response = await dio.post("user/front/renovatePass",
                  data: {"uno": _pageValues["用户号"], "originalPass": _pageValues["原密码"],
                  "newPass": _pageValues["新密码"]});
                print(response.data);
                if(response.data == 1) {    //修改密码成功
                    switch (await showDialog<int>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('提示'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('更改密码成功！'),
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
                    )) {
                      case 1:
                        Navigator. pushNamedAndRemoveUntil(context, "/aboutMe", ModalRoute.withName('/'),
                          arguments: mainPageArgs(args.uno, args.uname),);
                        break;
                    }
                }
                else {    //返回值为-1，因为原密码错误而不能修改密码
                  showDialog(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('提示'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('原始密码错误，修改密码失败！'),
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
              } catch(e){
                  switch (await showDialog<int>(
                    context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('提示'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('与服务器连接失败！'),
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
                    )) {
                      case 1:
                        Navigator. pushNamedAndRemoveUntil(context, "/aboutMe", ModalRoute.withName('/'),
                        arguments: mainPageArgs(args.uno, args.uname),);
                        break;
                    }
              }
          }}, () {
            Navigator. pushNamedAndRemoveUntil(context, "/aboutMe", ModalRoute.withName('/'),
              arguments: mainPageArgs(args.uno, args.uname),);
          }],
        ),
    );
  }
}
