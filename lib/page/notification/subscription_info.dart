
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';

var tmp;
class SubInfoPage extends StatefulWidget{
  final String id;
  SubInfoPage(@PathParam('id') this.id);
  @override
  _SubInfoPageState createState() => _SubInfoPageState();

}

class _SubInfoPageState extends State<SubInfoPage>{

  Map<String,dynamic> postTmp;
  Future<dynamic> _future;

  @override
  void initState(){
    _future = MyHttp.get('/support-notification/api/v1/subscription/${widget.id}');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void _forSubmitted(){
      var _form = formKey.currentState;
      if(_form.validate()){
        //postTmp['subscribedLabels'] = tmp['subscribedLabels'];
        MyHttp.putJson('/support-notification/api/v1/subscription',postTmp).catchError((error){
          MyHttp.handleError(error);
          return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: Text('修改失败，请检查网络状况或设备信息格式'),
                  actions: <Widget>[
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
        });
        _form.save();
        Navigator.of(context).pop(true);
      }
    }

    return Scaffold(
      appBar:AppBar(
        title:Text("详情"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async{
              return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('提示'),
                      content: Text('是否要删除该订阅信息？'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        FlatButton(
                          child: Text('确认'),
                          onPressed: () {
                            MyHttp.delete('/support-notification/api/v1/subscription/${widget.id}');
                            Navigator.of(context).pop(true);
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
      ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _forSubmitted,
          child: new Text('提交'),
        ),
      body:FutureBuilder(
        future:_future,
        builder:(BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            tmp = snapshot.data;
            postTmp = {
              'slug':tmp['slug'],
              'id':tmp['id'],
              'receiver':tmp['receiver'],
              'description':tmp['description'],
              'subscribedLabels':tmp['subscribedLabels']==null?[]:tmp['subscribedLabels'],
              'subscribedCategories':tmp['subscribedCategories']==null?[]:tmp['subscribedCategories'],
              'channels':tmp['channels'],
            };
            var subLabels = tmp['subscribedLabels']==null?'无':tmp['subscribedLabels'].toString().substring(1,tmp['subscribedLabels'].toString().length-1);
            var subCata = '';

            return ListView(
              children:<Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget>[
                      Container(
                        padding:EdgeInsets.all(16.0),
                        child:Form(
                          key:formKey,
                          autovalidate: true,
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                Text("基本信息",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                                SizedBox(height:10),
                                TextFormField(
                                  decoration:InputDecoration(
                                    //contentPadding: EdgeInsets.all(10.0),
                                    labelText: "id",
                                    labelStyle: TextStyle(color:Colors.black),
                                  ),
                                  style: TextStyle(color:Colors.grey),
                                  initialValue: tmp['id'],
                                  enabled: false,
                                ),
                                TextFormField(
                                  decoration:InputDecoration(
                                    //contentPadding: EdgeInsets.all(10.0),
                                    labelText: "slug",
                                    labelStyle: TextStyle(color:Colors.black),
                                  ),
                                  style: TextStyle(color:Colors.grey),
                                  initialValue: tmp['slug'],
                                  enabled: false,
                                ),
                                TextFormField(
                                  decoration:InputDecoration(
                                    //contentPadding: EdgeInsets.all(10.0),
                                    labelText: "接收方",
                                    labelStyle: TextStyle(color:Colors.black),
                                  ),
                                  style: TextStyle(color:Colors.grey),
                                  initialValue: tmp['receiver']==null?'无':tmp['receiver'],
                                  enabled: false,
                                ),
                                TextFormField(
                                  decoration:InputDecoration(
                                    labelText: "描述信息",
                                    labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                                  ),
                                  initialValue: tmp['description'],
                                  onChanged: (val){
                                    postTmp['description'] = val;
                                  },
                                ),
                                SizedBox(height:30),
                                Text("订阅类别",style:TextStyle(color:Colors.black,fontSize: 14)),
                                MySubCategories(postTmp, subCata),

                                Text("订阅标签",style:TextStyle(color:Colors.black,fontSize: 14)),
                                MySubLabel(postTmp,subLabels),
                              ]
                          )
                        )
                      ),
                      /*Container(
                          padding:EdgeInsets.all(16.0),
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                Text("订阅频道",style:TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 16)),
                              ]
                          )
                      )*/
                    ]
                )
              ]
            );

          }else{
            return Center(child:Text("加载失败，请刷新页面"));
          }
        }
      )
    );
  }
}

class MySubCategories extends StatefulWidget{

  dynamic tmp;
  String subCategories;

  MySubCategories(this.tmp,this.subCategories);

  @override
  _MySubCategoriesState createState() => _MySubCategoriesState();

}

class _MySubCategoriesState extends State<MySubCategories>{
  bool flag_SECURITY = tmp['subscribedCategories']==null?false:tmp['subscribedCategories'].contains('SECURITY');
  bool flag_HW_HEALTH = tmp['subscribedCategories']==null?false:tmp['subscribedCategories'].contains('HW_HEALTH');
  bool flag_SW_HEALTH = tmp['subscribedCategories']==null?false:tmp['subscribedCategories'].contains('SW_HEALTH');
  //bool tapped = false;

  @override
  Widget build(BuildContext context) {
    print(flag_SECURITY);
    print(widget.tmp);
    return ExpansionTile(
        title:Text("点击选择"),
        backgroundColor: Colors.grey,
        children:<Widget>[
          CheckboxListTile(
            value: flag_SECURITY,
            onChanged: (value) {
              setState(() {
                flag_SECURITY = value;
                //print(value);
                if(flag_SECURITY){
                  widget.tmp['subscribedCategories'].add('SECURITY');
                }else{
                  widget.tmp['subscribedCategories'].remove('SECURITY');
                }
              });
            },
            title: Text("SECURITY"),
          ),
          CheckboxListTile(
            value: flag_HW_HEALTH,
            onChanged: (value) {
              setState(() {
                flag_HW_HEALTH = value;
                if(flag_HW_HEALTH){
                  widget.tmp['subscribedCategories'].add('HW_HEALTH');
                }else{
                  widget.tmp['subscribedCategories'].remove('HW_HEALTH');
                }
              });
            },
            title: Text("HW_HEALTH"),
          ),
          CheckboxListTile(
            value: flag_SW_HEALTH,
            onChanged: (value) {
              setState(() {
                flag_SW_HEALTH = value;
                if(flag_SW_HEALTH){
                  widget.tmp['subscribedCategories'].add("SW_HEALTH");
                }else{
                  widget.tmp['subscribedCategories'].remove("SW_HEALTH");
                }
              });
            },
            title: Text("SW_HEALTH"),
          ),
        ]
    );
  }

}

class MySubLabel extends StatefulWidget{

  dynamic tmp;
  String subLabels;

  MySubLabel(this.tmp,this.subLabels);

  @override
  _MySubLabelState createState() => _MySubLabelState();

}

class _MySubLabelState extends State<MySubLabel>{

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:widget.subLabels,
      onChanged: (String newValue) {
        setState(() {
          if(newValue=='无'){
            widget.tmp['subscribedLabels'] = [];
          }else{
            widget.tmp['subscribedLabels'] = [newValue];
          }
          widget.subLabels = newValue;
        });
      },
      items: <String>['无','metadata']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}