import 'package:flutter/material.dart';

import '../../http.dart';

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
                future:MyHttp.get('/support-notification/api/v1/subscription'),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    tmp = snapshot.data;
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: tmp.length<=6?tmp.length:6,
                        header: Text("Subscriptions"),
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
                            icon:Icon(Icons.add),
                            onPressed: (){},
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
                        header: Text("Subscriptions"),
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
                        columns: [DataColumn(label:Text("订阅消息"))],
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