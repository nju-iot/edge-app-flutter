
import 'package:flutter/material.dart';

import '../../http.dart';

class NotificationPage extends StatefulWidget{

  @override
  _NotificationPageState createState() => _NotificationPageState();

}

class _NotificationPageState extends State<NotificationPage>{
  var tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ListView(
            children:<Widget>[
              FutureBuilder(
                future:MyHttp.get('/support-notification/api/v1/notification/end/${DateTime.now().millisecondsSinceEpoch}/50'),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    tmp = snapshot.data;
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: tmp.length<=6?tmp.length:6,
                        header: Text("Notifications"),
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
                          IconButton(
                            icon:Icon(Icons.delete),
                            onPressed:() async{
                              return await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('提示'),
                                      content: Text('是否要删除选定的消息？'),
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
                            icon:Icon(Icons.search),
                            onPressed: (){},
                          ),
                        ],
                        columns: [DataColumn(label:Text("提醒消息"))],
                        source: MyNotificationSource(tmp),
                      ),
                      //),
                    );
                  }else{
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: 1,
                        header: Text("Notifications"),
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
                        columns: [DataColumn(label:Text("提醒消息"))],
                        source: MyNotificationSource(tmp),
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

class MyNotificationSource extends DataTableSource{

  MyNotificationSource(this.data);

  var data;

  @override
  DataRow getRow(int index){
    //print(data[1]['created'].runtimeType);
    if(index>=data.length){
      return null;
    }
    data.sort((left,right) {
      int created1 = right['created'];
      int created2 = left['created'];
      return created1.compareTo(created2);
      }
    );
    return DataRow.byIndex(
        index:index,
        cells:[
          DataCell(
            ListTile(
              onTap:(){},
              //leading:Text("#${index+1}"),
              title:Text("${data[index]['slug'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("id: ${data[index]['id'].toString()}"),
              trailing:Icon(Icons.arrow_forward_ios),
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