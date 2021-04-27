import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';

class DeviceProfilePage extends StatefulWidget{
  @override
  _DeviceProfilePageState createState() => _DeviceProfilePageState();

}

var tmp;
class _DeviceProfilePageState extends State<DeviceProfilePage>{

  /*var result;

  void getRequest() async{
    Dio dio = new Dio();
    Response response = await dio.get('http://47.102.192.194:4000/rule-engine/rules');
    setState(() {
      result = response.data;
    });
  }*/

  @override
  Widget build(BuildContext context){
    //var tmp;
    return Scaffold(
        body:ListView(
            children:<Widget>[
              FutureBuilder(
                future:MyHttp.get('http://47.102.192.194:48081/api/v1/deviceprofile'),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    tmp = snapshot.data;
                    return Container(
                          //child:Expanded(
                            child:PaginatedDataTable(
                              rowsPerPage: 6,
                              header: Text("DeviceProfile"),
                              headingRowHeight: 24.0,
                              horizontalMargin: 8.0,
                              dataRowHeight: 60.0,
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
        cells:[
          DataCell(
            ListTile(
              onTap:(){},
              //leading:Text("#${index+1}"),
              title:Text("${data[index]['name'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
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