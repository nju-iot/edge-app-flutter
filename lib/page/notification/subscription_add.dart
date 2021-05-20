
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/router/route_map.gr.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/widget/icon_with_text.dart';
import 'package:fluttertoast/fluttertoast.dart';


Map<String,dynamic> postTmp;
bool flag_SECURITY = false;
bool flag_HW_HEALTH = false;
bool flag_SW_HEALTH = false;

class SubAddPage extends StatefulWidget{
  @override
  _SubAddPageState createState() => _SubAddPageState();
}

class _SubAddPageState extends State<SubAddPage>{
  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    postTmp = {
      'slug':'',
      'name':'',
      'description':'',
      'subscribedLabels':[],
      'subscribedCategories':[],
      'channels':[]
    };

    void _forSubmitted(){
      var _form = formKey.currentState;
      if(_form.validate()){
        MyHttp.postJson('/support-notification/api/v1/subscription',postTmp).catchError((error){
          MyHttp.handleError(error);
          return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提示'),
                  content: Text('添加失败，请检查网络状况或格式'),
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
        }).then((value){
          _form.save();
          Navigator.of(context).pop(true);
          setState(() {
            //MyRouter.replace(Routes);
            Fluttertoast.showToast(
                msg: "添加成功",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.5),
                textColor: Colors.white,
                fontSize: 16.0
            );
          });
        });
      }

    }
    String slug = "client-subscription-${DateTime.now().millisecondsSinceEpoch.toString()}";
    postTmp['slug'] = slug;
    var subLabels = "无";

    return Scaffold(
      appBar:AppBar(
        title:Text("新增"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _forSubmitted,
        child: new Text('提交'),
      ),
      body:ListView(
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
                          labelText: "slug",
                          labelStyle: TextStyle(color:Colors.black),
                          icon:Icon(Icons.perm_device_info)
                        ),
                        style: TextStyle(color:Colors.grey),
                        initialValue: slug,
                        enabled: false,
                      ),
                      TextFormField(
                        decoration:InputDecoration(
                          labelText: "名称",
                          labelStyle: TextStyle(color:Colors.black),
                          hintText: "请输入名称",
                          errorText:"此为必填项",
                          icon:Icon(Icons.device_unknown)
                        ),
                        //textInputAction: TextInputAction.done,
                        onChanged: (val){
                          postTmp['name'] = val;
                        },
                      ),
                      TextFormField(
                        decoration:InputDecoration(
                          labelText: "描述",
                          labelStyle: TextStyle(color:Colors.black,fontSize: 14),
                          icon:Icon(Icons.description_outlined)
                        ),

                        onChanged: (val){
                          postTmp['description'] = val;
                        },
                      ),
                      SizedBox(height:30),

                      Container(
                        padding: EdgeInsets.only(left:40.0),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            IconText(" 订阅类别",icon:Icon(Icons.category),style:TextStyle(color:Colors.black,fontSize: 14)),
                            MyCata(postTmp),
                            IconText(" 订阅标签",icon:Icon(Icons.label),style:TextStyle(color:Colors.black,fontSize: 14)),
                            MyAddLabel(postTmp, subLabels),
                          ]
                        )
                      )

                    ],
                  ),
                  onWillPop: () async{
                    return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('提示'),
                            content: Text('是否要取消添加订阅并退出？'),
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
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                )
              )
            ]
          )
        ]
      )

    );
  }
}

class MyAddLabel extends StatefulWidget{
  dynamic tmp;
  String subLabels;
  MyAddLabel(this.tmp,this.subLabels);
  @override
  _MyAddLabelState createState() => _MyAddLabelState();
}

class _MyAddLabelState extends State<MyAddLabel>{

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

class MyCata extends StatefulWidget{
  dynamic tmp;
  MyCata(this.tmp);
  @override
  _MyCataState createState() => _MyCataState();
}

class _MyCataState extends State<MyCata>{

  @override
  Widget build(BuildContext context) {
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