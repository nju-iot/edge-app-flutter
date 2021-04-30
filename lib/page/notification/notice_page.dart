
import 'package:flutter/material.dart';
import 'package:flutter_app/page/notification/notice_notification.dart';
import 'package:flutter_app/page/notification/notice_subscription.dart';
import 'package:flutter_app/page/notification/notice_transmission.dart';

class NoticePage extends StatefulWidget{
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync:this,initialIndex: 0,length:3);
    _tabController.addListener(() { });
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("消息管理"),
        bottom:TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs:<Widget>[
            Tab(text:"提醒消息"),
            Tab(text:"订阅消息"),
            Tab(text:"传输信息"),
          ]
        ),
      ),
      body:TabBarView(
        controller:_tabController,
        children:[
          NotificationPage(),
          SubscriptionPage(),
          TransmissionPage(),
        ],
      ),
    );
  }
}