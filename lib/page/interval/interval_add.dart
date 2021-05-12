import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class IntervalAddPage extends StatefulWidget {
  @override
  _IntervalAddPageState createState() => _IntervalAddPageState();
}

class _IntervalAddPageState extends State<IntervalAddPage> {
  bool _runOnce=false;//只运行一次
  DateTime _startDateTime;//开始时间
  DateTime _endDateTime;//结束时间
  
  //提交表单
  void _formSubmit(){
    print("提交表单");
  }

  @override
  void initState() {
    super.initState();
    _startDateTime=DateTime.now();
  }

  
  
  Future<DateTime> _showDatePicker(){
    _startDateTime=DateTime.now();
    return showCupertinoModalPopup(
      context: context , 
      builder: (ctx){
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: _startDateTime,
            onDateTimeChanged: (DateTime selectedDate){
              print(selectedDate);
            },
            ),
        );
      },
      );
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
            TextFormField(
              onTap: () async {
                
              },
              initialValue: _startDateTime.toString(),
              enabled: false,
              decoration: InputDecoration(
                labelText: "开始时间",
                labelStyle: TextStyle(color: Colors.black),
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