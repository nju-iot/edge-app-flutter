
import 'package:flutter/material.dart';
import 'package:flutter_app/page/interval/interval_actions.dart';
import 'package:flutter_app/page/interval/interval_list.dart';

class IntervalPage extends StatefulWidget{
  @override
  _IntervalPageState createState() => _IntervalPageState();
}

class _IntervalPageState extends State<IntervalPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState(){
    super.initState();

    _tabController = TabController(vsync:this,initialIndex: 0,length: 2);

    _tabController.addListener(() {});

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("定时任务"),
        bottom:TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs:<Widget>[
            Tab(text:"定时任务"),
            Tab(text:"触发动作"),
          ]
        )
      ),
      body:TabBarView(
        controller:_tabController,
        children:<Widget>[
          IntervalListPage(),
          IntervalActionsPage(),
        ]
      )
    );
  }
}