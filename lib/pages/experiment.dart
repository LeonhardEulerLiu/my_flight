import 'package:flutter/material.dart';
import 'package:my_flight/common/components.dart';

class experimentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("实验页"), ),
      body: notFound("航班"),
    );
  }
}
