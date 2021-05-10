import 'package:flutter/material.dart';

class IntervalAddPage extends StatelessWidget {

  //提交表单
  void _formSubmit(){
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增定时任务"),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: _formSubmit,
      child: Text("提交"),),
      body: Center(
        child: Text("添加定时任务页面")
      ),
    );
  }
}