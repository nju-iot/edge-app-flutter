import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeviceServicePage extends StatefulWidget{
  @override
  _DeviceServicePageState createState() => _DeviceServicePageState();

}

class _DeviceServicePageState extends State<DeviceServicePage>{

  @override
  Widget build(BuildContext context){
    var tmp;
    return Scaffold(
        body: ListView(
            children:<Widget>[
              FutureBuilder(
                future:MyHttp.get('/core-metadata/api/v1/deviceservice'),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    tmp = snapshot.data;
                    return Container(
                      child:PaginatedDataTable(
                        rowsPerPage: tmp.length<=6?tmp.length:6,
                        header: Text("设备服务"),
                        headingRowHeight: 24.0,
                        horizontalMargin: 8.0,
                        dataRowHeight: 60.0,
                        actions:<Widget>[
                          IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: (){
                                setState(() {
                                  Fluttertoast.showToast(
                                      msg: "刷新成功",
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
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
                                      content: Text('请在您当前的服务器上部署设备服务'),
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
                        ],
                        columns: [DataColumn(label:Text("基本信息"))],
                        source: MyServiceSource(tmp),
                      ),
                    );
                  }else{
                    return Container(
                        child:PaginatedDataTable(
                          rowsPerPage: 1,
                          header: Text("DeviceService"),
                          headingRowHeight: 24.0,
                          horizontalMargin: 8.0,
                          dataRowHeight: 60.0,
                          actions: <Widget>[
                            IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: (){
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "刷新成功",
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  });
                                }
                            ),
                          ],
                          columns: [DataColumn(label:Text("基本信息"))],
                          source: MyServiceSource(tmp),
                        ),
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

class MyServiceSource extends DataTableSource{

  MyServiceSource(this.data);

  var data;

  @override
  DataRow getRow(int index){
    if(index>=data.length){
      return null;
    }
    return DataRow.byIndex(
        index:index,
        cells:[
          DataCell(
            ListTile(
              onTap:(){},
              //leading:Text("#${index+1}"),
              title:Text("${data[index]['name'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("id: ${data[index]['id'].toString()}",maxLines: 2,overflow: TextOverflow.ellipsis),
              trailing:IconButton(
                  icon:Icon(Icons.arrow_forward_ios),
                  onPressed: (){
                    MyRouter.push(Routes.serviceInfoPage(name:"${data[index]['name'].toString()}"));
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
    if(data==null) return 0;
    return data.length;
  }
}





