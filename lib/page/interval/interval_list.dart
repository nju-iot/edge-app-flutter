import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';

class IntervalListPage extends StatefulWidget{
  @override
  IntervalListPageState createState() => IntervalListPageState();

}

class IntervalListPageState extends State<IntervalListPage>{
  
  var interval_list=[];
  
  @override
  void initState() {
    super.initState();
      
  }
  
  void fetch_interval_list(){
    
  }
  
  

  Future<Null> _onrefresh(){
    return Future.delayed(Duration(seconds: 5),(){});
  }

  

  @override
  Widget build(BuildContext context){
    return RefreshIndicator(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            ListTile(title: Text("title"),trailing: IconButton(icon: Icon(Icons.add),onPressed: (){
              MyRouter.push(Routes.intervalAddPage);
            },),),
            Expanded(
              child: ListView.builder(
                itemBuilder:(BuildContext context,int index){
                  return ListTile(title: Text("${index+1}"),
                  trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null)
                  );
                } ))
          ],
        ),
      ), 
      onRefresh: _onrefresh,
      );
  }


  /* 
  Widget buildFloatingSearchBar(){
  return FloatingSearchBar(
    automaticallyImplyDrawerHamburger: false,
    hint: "请输入定时任务名称",
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment:MediaQuery.of(context).orientation==Orientation.portrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    maxWidth: MediaQuery.of(context).orientation==Orientation.portrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query){
      //搜索内容改变时，展示推荐结果
      
    },
    builder: (context,transition){
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Center(
            child: Text("text"),
          ),
        ),
      );
    });
  }

  */
}

