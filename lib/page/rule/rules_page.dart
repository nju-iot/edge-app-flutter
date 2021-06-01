import 'package:flutter/material.dart';
import 'package:flutter_app/page/rule/rules_list.dart';
import 'package:flutter_app/page/rule/streams_list.dart';

class RulesPage extends StatefulWidget {
  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("规则引擎"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: "流",
              ),
              Tab(
                text: "规则",
              ),
            ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          StreamListPage(),
          RuleListPage(),
        ],
      ),
    );
  }
}
