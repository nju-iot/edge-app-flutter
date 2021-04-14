
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';

class DeviceListPage extends StatefulWidget{
  @override
  DeviceListPageState createState() => DeviceListPageState();

}

class DeviceListPageState extends State<DeviceListPage>{

  @override
  Widget build(BuildContext context){
    var tmp;
    return Scaffold(
        body:Column(
          children:<Widget>[
            Row(
                children:[
                  Expanded(child:Text('所有设备')),
                  //Expanded(child:Text('名称')),
                  //Expanded(child:Text('所属服务')),
                  //Expanded(child:Text('操作')),
                  //Expanded(child:Text('')),
                ]
            ),

            FutureBuilder(
              future:MyHttp.get('http://47.102.192.194:48081/api/v1/device'),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  tmp = snapshot.data;
                  print(tmp.length);
                  return Expanded(
                      child:Container(
                          child:ListView.builder(
                            itemCount: tmp == null ? 0 : tmp.length,
                            itemBuilder: (BuildContext context, int index){
                              return InkWell(
                                onTap: (){},
                                child:Card(
                                  child:ListTile(
                                    onTap:(){},
                                    leading:Expanded(child:Text("#${index+1}")),
                                    title:Expanded(child:Text("${tmp[index]['name'].toString()}",style:TextStyle(fontWeight: FontWeight.bold))),
                                    subtitle: Text("id: ${tmp[index]['id'].toString()}"),
                                    trailing:Icon(Icons.arrow_forward_ios),
                                    /*Row(
                                        children:<Widget>[
                                          Expanded(child:Text("${tmp[index]['name'].toString()}")),
                                          Expanded(child:Text("${tmp[index]['service']['name'].toString()}")),
                                          Expanded(child:Icon(Icons.delete)),
                                          Expanded(child:Icon(Icons.auto_fix_high)),
                                        ]
                                    )*/
                                  ),
                                ),
                              );
                            },
                          )
                  )
                  );
                }else{
                  return Text("暂无数据，请添加设备");
                }
              },
            ),


            /*FutureBuilder(
              future:MyHttp.get('http://47.102.192.194:48081/api/v1/device'),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  tmp = snapshot.data;
                  print(tmp.length);
                  return Text("${tmp[1]['service']['name'].toString()}");
                }else{
                  return Text("暂无");
                }
              },
            ),*/

          ],
        )
    );
  }

}