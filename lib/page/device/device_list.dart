
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'dart:math' as math;



class DeviceListPage extends StatefulWidget{
  @override
  DeviceListPageState createState() => DeviceListPageState();

}

class DeviceListPageState extends State<DeviceListPage>{


  @override
  void initState(){
    super.initState();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    Future<Null> _onrefresh(){
      return Future.delayed(Duration(seconds: 5),(){   // 延迟5s完成刷新
        setState(() {
        });
      });
    }

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    var tmp;

    return RefreshIndicator(
        child: Scaffold(
          floatingActionButton:Draggable(
            child:FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                MyRouter.push(Routes.deviceAddPage);
              },
            ),
            feedback:FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                MyRouter.push(Routes.deviceAddPage);
              },
            ),
            onDragEnd: (detail){

            },
          ),
          body:FloatingSearchBar(
              hint: '请输入设备名称',
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              maxWidth: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                print('szz');
                //MyRouter.push(Routes.deviceInfoPage(name:"${tmp[index]['name'].toString()}"));
                // Call your model, bloc, controller here.
              },
              onSubmitted: (query){
                if(query!=null&&query!='') {
                  MyRouter.push(Routes.deviceInfoPage(name: "${query}"));
                }
              },
              // Specify a custom transition to be used for
              // animating between opened and closed stated.
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(Icons.place),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: Colors.accents.map((color) {
                        return Container(height: 112, color: color);
                      }).toList(),
                    ),
                  ),
                );
              },
              body:IndexedStack(
                children: [
                  Column(
                    children:<Widget>[
                      //FloatingSearchBarScrollNotifier(
                      //child:
                      FutureBuilder(
                        future:MyHttp.get('/core-metadata/api/v1/device'),
                        builder: (BuildContext context,AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            tmp = snapshot.data;
                            return Expanded(
                                child:Container(
                                    margin:const EdgeInsets.only(top:70.0),
                                    child:ListView.builder(
                                      itemCount: tmp == null ? 0 : tmp.length,
                                      itemBuilder: (BuildContext context, int index){
                                        return InkWell(
                                          onTap: (){},
                                          child:Card(
                                            child:ListTile(
                                              onTap:(){},
                                              leading:Text("#${index+1}"),
                                              title:Text("${tmp[index]['name'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
                                              subtitle: Text("id: ${tmp[index]['id'].toString()}"),
                                              trailing:IconButton(
                                                  icon:Icon(Icons.arrow_forward_ios),
                                                  onPressed:(){
                                                    MyRouter.push(Routes.deviceInfoPage(name:"${tmp[index]['name'].toString()}"));
                                                  }
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                )
                            );
                          }else{
                            return Container(
                                alignment: Alignment.topCenter,
                                margin:const EdgeInsets.only(top:70.0),
                                child:Text("未搜索到结果，请刷新页面或重试")
                            );
                          }
                        },
                      ),
                      //),
                    ],
                  )
                ],

              )
          ),
        ),
        onRefresh: _onrefresh,
    );
  }
}

