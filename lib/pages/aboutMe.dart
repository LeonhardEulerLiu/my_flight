import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';
import 'package:my_flight/routeParas/routeParas.dart';
import 'package:my_flight/pages/login.dart';

//About Me的酷炫页面：自定义标题栏
class aboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainPageArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());

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
            title: Text("${args.uname}", style: TextStyle(
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
                  onTap: () => Navigator.pushNamed(context, "/changePassword",
                    arguments: mainPageArgs(
                      args.uno, args.uname,
                    )),
                ),
                ListTile(
                  title: Text("注销"),
                  leading: Icon(Icons.exit_to_app, color: Colors.red,),
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, loginPage.routeName, (Route<dynamic> route) => false),
                ),
              ]
          ),
        ),
      ],
    );
  }
}