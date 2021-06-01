
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
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title:Text("消息管理"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        bottom:TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs:<Widget>[
            Tab(text:"通知消息"),
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