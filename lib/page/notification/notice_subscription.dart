import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';

import '../../http.dart';


List<String> willBeDeleted = [];
class SubscriptionPage extends StatefulWidget{

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();

}

class _SubscriptionPageState extends State<SubscriptionPage>{

  var tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ListView(
            children:<Widget>[
              FutureBuilder(
                future:/*MyHttp.get('/support-notification/api/v1/subscription')*/MyHttp.get('/support-notification/api/v1/subscription/labels/metadata').catchError((error){MyHttp.handleError(error);}),
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
                        header: Text("订阅"),
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
                            onPressed: (){
                              MyRouter.push(Routes.subAddPage);
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
                                            for(int i=0;i<willBeDeleted.length;i++){
                                              MyHttp.delete('/support-notification/api/v1/subscription/${willBeDeleted[i]}');
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
                        columns: [DataColumn(label:Text("订阅消息"))],
                        source: MySubscriptionSource(tmp),
                      ),
                      //),
                    );
                  }else{
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: 1,
                        header: Text("订阅消息"),
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
                        columns: [DataColumn(label:Text("所有订阅"))],
                        source: MySubscriptionSource(tmp),
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

class MySubscriptionSource extends DataTableSource{

  MySubscriptionSource(this.data);

  var data;


  @override
  DataRow getRow(int index){
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
            SizedBox(
              width:336.0,
              child:ListTile(
                onTap:(){},
                //leading:Text("#${index+1}"),
                title:Text("订阅消息${data[index]['slug'].toString().substring(19)}",style:TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("id: ${data[index]['id'].toString()}",maxLines:2,overflow: TextOverflow.ellipsis,),
                trailing:IconButton(
                  icon:Icon(Icons.arrow_forward_ios),
                  onPressed: (){
                    MyRouter.push(Routes.subInfoPage(id:"${data[index]['id'].toString()}"));
                  },
                ),
              ),
            )
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