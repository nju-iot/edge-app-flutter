import 'package:flutter/material.dart';

import '../../http.dart';

class TransmissionPage extends StatefulWidget{

  @override
  _TransmissionPageState createState() => _TransmissionPageState();

}

class _TransmissionPageState extends State<TransmissionPage>{

  var tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ListView(
            children:<Widget>[
              FutureBuilder(
                future:MyHttp.get('/support-notification/api/v1/transmission/end/${DateTime.now().millisecondsSinceEpoch}/50'),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    tmp = snapshot.data;
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: tmp.length<=6?tmp.length:6,
                        header: Text("Transmissions"),
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
                            onPressed: (){},
                          )
                        ],
                        columns: [DataColumn(label:Text("传输信息"))],
                        source: MyTransmissionSource(tmp),
                      ),
                      //),
                    );
                  }else{
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: 1,
                        header: Text("Transmissions"),
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
                        columns: [DataColumn(label:Text("传输信息"))],
                        source: MyTransmissionSource(tmp),
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

class MyTransmissionSource extends DataTableSource{

  MyTransmissionSource(this.data);

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
              title:Text("transmission-${data[index]['created'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
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