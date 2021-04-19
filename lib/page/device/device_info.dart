
import 'package:auto_route/auto_route_annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeviceInfoPage extends StatefulWidget{
  final String name;

  DeviceInfoPage({@PathParam('name') this.name});
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage>{


  @override
  Widget build(BuildContext context){

    Response response;
    var jotaro = Dio();
    //response = await jotaro.get('http://47.102.192.194:48081/api/v1/device/name/${widget.name}');

    return new Scaffold(
      appBar:AppBar(
        title:Text("设备详情"),
      ),
      body:Center(
        child:Text("${widget.name.toString()}"),
      )
    );
  }
}