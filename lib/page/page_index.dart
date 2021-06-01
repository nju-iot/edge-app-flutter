
import 'package:flutter/material.dart';
import 'package:flutter_app/routes/cloud_route.dart';
import 'package:flutter_app/routes/home_route.dart';
import 'package:flutter_app/routes/user_route.dart';
import 'package:flutter_app/utils/provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget{
  IndexPage({Key key}):super(key:key);

  @override
  _IndexPageState createState() => new _IndexPageState();
}

//主页
class _IndexPageState extends State<IndexPage>{

  List<BottomNavigationBarItem> getTabs(BuildContext context) =>[
    BottomNavigationBarItem(icon: Icon(Icons.airplay),label:"主页"),
    BottomNavigationBarItem(icon: Icon(Icons.cloud),label:"云端"),
    BottomNavigationBarItem(icon: Icon(Icons.account_box),label:"用户"),
  ];


  List<Widget> getTabWidget(BuildContext context) =>[
    HomeRoute(),
    CloudRoute(),
    UserRoute(),
  ];

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    var tabs = getTabs(context);
    //provider进行页面状态管理
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Consumer(
      builder: (BuildContext context, AppStatus status,Widget child){
        return Scaffold(
          appBar:AppBar(
            //title:Text("首页"),
            title:Text(tabs[status.tabIndex].label),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  appBarColor[800],
                  appBarColor[200],
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
          drawer:MyDrawer(),
          body:IndexedStack(
            index:status.tabIndex,
            children:getTabWidget(context),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items:tabs,
            currentIndex: status.tabIndex,
            onTap: (index){
              status.tabIndex = index;
            },
            type:BottomNavigationBarType.fixed,
            fixedColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );

  }
}
