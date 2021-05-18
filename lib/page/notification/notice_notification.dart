
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';

import '../../http.dart';


List<String> willBeDeleted = [];
var tmp;
//bool searched = true;
//var items = [];

class NotificationPage extends StatefulWidget{

  @override
  _NotificationPageState createState() => _NotificationPageState();

}

class _NotificationPageState extends State<NotificationPage>{
  DateTime _selectStart = DateTime.now();
  DateTime _selectEnd = DateTime.now();
  //var tmp;

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
                    for(int i=0;i<tmp.length;i++){
                      tmp[i]['selected'] = false;
                    }
                    return NoticeListBaseWidget(tmp);
                  }else{
                    return Container(
                      //child:Expanded(
                      child:PaginatedDataTable(
                        rowsPerPage: 1,
                        header: Text("通知消息"),
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
                        columns: [DataColumn(label:Text("由新到旧（仅展示最近50条）"))],
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
            willBeDeleted.add(data[index]['slug']);
          }else{
            willBeDeleted.remove(data[index]['slug']);
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
                title:Text("${data[index]['slug'].toString()}",style:TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("id: ${data[index]['id'].toString()}",maxLines: 2,overflow: TextOverflow.ellipsis,),
                trailing:IconButton(
                  icon:Icon(Icons.arrow_forward_ios),
                  onPressed: (){
                    MyRouter.push(Routes.notificationInfoPage(slug: "${data[index]['slug'].toString()}"));
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

class NoticeListBaseWidget extends StatefulWidget{

  var data;
  NoticeListBaseWidget(this.data);

  @override
  _NoticeListState createState() => _NoticeListState();

}

class _NoticeListState extends State<NoticeListBaseWidget>{
  var temp;
  bool searched = false;

  DateTime _selectStart = DateTime.now();
  DateTime _selectEnd = DateTime.now();

  //时间选择器
  _showStartPicker(Function state) {
    showDatePicker(
      context: context,
      initialDate: _selectStart, //选中的日期
      firstDate: DateTime(1970), //日期选择器上可选择的最早日期
      lastDate: DateTime(2030), //日期选择器上可选择的最晚日期
    ).then((selectedValue) {
      state(() {
        if(selectedValue!=null) {
          _selectStart = selectedValue;
        }
      });
    });
  }

  _showEndPicker(Function state) {
    showDatePicker(
      context: context,
      initialDate: _selectEnd, //选中的日期
      firstDate: DateTime(1970), //日期选择器上可选择的最早日期
      lastDate: DateTime(2030), //日期选择器上可选择的最晚日期
    ).then((selectedValue) {
      state(() {
        if(selectedValue!=null){
          _selectEnd = selectedValue;
        }
      });
    });
  }

  //筛选弹窗
  Widget timepicker(Function state){
    return SimpleDialog(
      title:Text('按时间筛选'),
      children: <Widget>[
        SimpleDialogOption(
          child: InkWell(
            onTap:(){
              _showStartPicker(state);
            },
            child:Text.rich(TextSpan(
                children:[
                  TextSpan(
                    text:"起始: ",
                    style:TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:14,
                    ),
                  ),
                  TextSpan(
                    text:formatDate(_selectStart, [yyyy, "-", mm, "-", "dd"]),
                    style:TextStyle(
                      color:Colors.blue,
                      fontSize:14,
                    ),
                  )
                ]
            )),
          ),
        ),
        SimpleDialogOption(
          child: InkWell(
            onTap:(){
              _showEndPicker(state);
            },
            child:Text.rich(TextSpan(
                children:[
                  TextSpan(
                    text:"截至: ",
                    style:TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:14,
                    ),
                  ),
                  TextSpan(
                    text:formatDate(_selectEnd, [yyyy, "-", mm, "-", "dd"]),
                    style:TextStyle(
                      color:Colors.blue,
                      fontSize:14,
                    ),
                  )
                ]
            )),
          ),
        ),
        Container(
            width:60.0,
            child:SizedBox(
                width:60.0,
                child:FlatButton(
                  //color: Colors.blue,
                  textColor: Colors.blue,
                  child: new Text('确定'),
                  onPressed: () {
                    setState(() {
                      var items = [];
                      if(_selectStart.millisecondsSinceEpoch<_selectEnd.millisecondsSinceEpoch){
                        for(int i=0;i<widget.data.length;i++){
                          var created = widget.data[i]['created'];
                          if(created>_selectStart.millisecondsSinceEpoch&&created<_selectEnd.millisecondsSinceEpoch){
                            items.add(widget.data[i]);
                          }
                        }
                        temp = items;
                        searched = true;
                      }
                    });
                    Navigator.of(context).pop(true);
                  },
                )
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      //child:Expanded(
      child:PaginatedDataTable(
        rowsPerPage: searched==true?(temp.length==0?1:temp.length<=6?temp.length:6):(tmp.length<=6?tmp.length:6),
        header: Text("通知消息"),
        headingRowHeight: 24.0,
        horizontalMargin: 8.0,
        dataRowHeight: 60.0,
        actions:<Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                setState(() {
                  searched = false;
                  _selectStart = DateTime.now();
                  _selectEnd = DateTime.now();
                  willBeDeleted = [];
                });
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
                            for(int i=0;i<willBeDeleted.length;i++){
                              MyHttp.delete('/support-notification/api/v1/notification/slug/${willBeDeleted[i]}');
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
          IconButton(
            icon:Icon(Icons.search),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (context,state){
                          //return timepicker(state);
                          return Container(
                            child:timepicker(state),
                          );
                        }
                    );
                  }
              );
            },
          ),
        ],
        columns: [DataColumn(label:Text("    由新到旧（仅展示最近50条）"))],
        source: searched==true?MyNotificationSource(temp):MyNotificationSource(tmp),//MyNotificationSource(items),
      ),
      //),
    );
  }
}

