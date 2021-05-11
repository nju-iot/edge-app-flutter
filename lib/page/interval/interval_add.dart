import 'package:flutter/material.dart';
class IntervalAddPage extends StatefulWidget {
  @override
  _IntervalAddPageState createState() => _IntervalAddPageState();
}

class _IntervalAddPageState extends State<IntervalAddPage> {
  bool _runOnce=false;
  //提交表单
  void _formSubmit(){
    print("提交表单");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增定时任务"),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: _formSubmit,
      child: Text("提交"),),
      body: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "名称",
                labelStyle: TextStyle(color: Colors.black),
                hintText: "请输入名称",
                errorText: "此为必填项",
              ),
            ),
            Switch(
              value: _runOnce,
              onChanged: (value){
                setState(() {
                  _runOnce=value;
                });
              },
            ),
            if(!_runOnce)
              TextFormField(
                
                decoration: InputDecoration(
                  labelText: "执行频率",
                  labelStyle: TextStyle(color:Colors.black),
                  contentPadding: EdgeInsets.symmetric(horizontal: 100.0),
                  
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}