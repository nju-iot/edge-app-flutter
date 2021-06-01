import 'dart:convert';

import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/interval/interval_add.dart';
import "package:flutter_app/models/MyInterval.dart";

class IntervalInfoPage extends StatefulWidget {
  final String id;
  IntervalInfoPage(@PathParam("id") this.id);

  @override
  _IntervalInfoPageState createState() => _IntervalInfoPageState();
}

class _IntervalInfoPageState extends State<IntervalInfoPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyHttp.get("/support-scheduler/api/v1/interval/${widget.id}"),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          if(snapshot.hasError){
            print("Error: ${snapshot.error}");
            return Text("请求出现错误, 请刷新页面或重试");
          }else{
            MyInterval myInterval=MyInterval.fromJson(snapshot.data);
            return IntervalAddPage(interval:jsonEncode(myInterval));
          }
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}
