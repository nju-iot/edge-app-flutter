
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/device/device_list.dart';
import 'package:flutter_app/page/device/device_service.dart';
import 'package:flutter_app/page/device/device_profile.dart';


class DevicePage extends StatefulWidget{
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState(){
    super.initState();

    _tabController = TabController(vsync:this,initialIndex: 0,length: 3);

    _tabController.addListener(() {});

    setState(() {});

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("设备管理"),
        bottom:TabBar(
          controller:_tabController,
          indicatorColor: Colors.white,
          tabs:<Widget>[
            Tab(text:"设备"),
            Tab(text:"设备服务"),
            Tab(text:"设备描述"),
          ],
        )
      ),
      body:TabBarView(
        controller:_tabController,
        children:<Widget>[
          DeviceListPage(),
          DeviceServicePage(),
          DeviceProfilePage(),
        ],
      ),

    );
  }
}