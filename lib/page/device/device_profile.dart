import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/notification/notice_notification.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';

var tmp;
List<String> willBeDeleted = [];
class DeviceProfilePage extends StatefulWidget{
  @override
  _DeviceProfilePageState createState() => _DeviceProfilePageState();

}

class _DeviceProfilePageState extends State<DeviceProfilePage>{

  @override
  Widget build(BuildContext context){
    //var tmp;
    return Scaffold(
        body:ListView(
            children:<Widget>[
              FutureBuilder(
                future:MyHttp.get('/core-metadata/api/v1/deviceprofile'),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    tmp = snapshot.data;
                    for(int i=0;i<tmp.length;i++){
                      tmp[i]['selected'] = false;
                    }
                    return Container(
                          //child:Expanded(
                            child:PaginatedDataTable(
                              rowsPerPage: tmp.length<=6?tmp.length:6,
                              header: Text("DeviceProfile"),
                              headingRowHeight: 24.0,
                              horizontalMargin: 8.0,
                              dataRowHeight: 60.0,
                              actions:<Widget>[
                                IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: (){
                                      setState(() {
                                        willBeDeleted = [];
                                      });
                                    }
                                ),
                                IconButton(
                                  icon:Icon(Icons.add),
                                  onPressed: () async{
                                    return await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('提示'),
                                            content: Text('请在您当前的服务器上以yml文件形式导入设备描述文件'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('确定'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                ),
                                IconButton(
                                  icon:Icon(Icons.delete),
                                  onPressed:() async{
                                    return await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('提示'),
                                            content: Text('是否要删除选定的文件？'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('取消'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('确认'),
                                                onPressed: () {
                                                  for(int i=0;i<willBeDeleted.length;i++){
                                                    MyHttp.delete('/core-metadata/api/v1/deviceprofile/id/${willBeDeleted[i]}');
                                                  }
                                                  willBeDeleted = [];
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                ),
                              ],
                              columns: [DataColumn(label:Text("设备描述信息"))],
                              source: MyProfileSource(tmp),
                            ),
                          //),
                    );
                  }else{
                    return Container(
                      //child:Expanded(
                        child:PaginatedDataTable(
                          rowsPerPage: 1,
                          header: Text("DeviceProfile"),
                          headingRowHeight: 24.0,
                          horizontalMargin: 8.0,
                          dataRowHeight: 60.0,
                          actions:<Widget>[
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: (){
                                setState(() {});
                              }
                            ),
                          ],
                          columns: [DataColumn(label:Text("设备描述信息"))],
                          source: MyProfileSource(tmp),
                        ),
                      //),
                    );
                    //return Text("暂无数据");
                  }
                },
              ),

            ]
        )
    );
  }

}

class MyProfileSource extends DataTableSource{

  MyProfileSource(this.data);

  var data;


  @override
  DataRow getRow(int index){
    if(index>=data.length){
      return null;
    }

    return DataRow.byIndex(
        index:index,
        selected: data[index]['selected'],
        onSelectChanged: (selected) {
          data[index]['selected'] = selected;
          if(selected==true){
            willBeDeleted.add(data[index]['id']);
          }else{
            willBeDeleted.remove(data[index]['id']);
          }
          notifyListeners();
        },
        cells:[
          DataCell(
            ListTile(
              onTap:(){},
              //leading:Text("#${index+1}"),
              title:Text("${data[index]['name'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("id: ${data[index]['id'].toString()}"),
              trailing:IconButton(
                icon:Icon(Icons.arrow_forward_ios),
                onPressed: (){
                  MyRouter.push(Routes.profileInfoPage(name:"${data[index]['name'].toString()}"));
                },
              ),
            ),
          ),
        ]
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    if(data==null)return 0;
    return data.length;
  }

}