
import 'package:flutter/material.dart';

class RulesPage extends StatefulWidget{
  @override
  _RulesPageState createState() => _RulesPageState();

}

class _RulesPageState extends State<RulesPage>{
  @override
  Widget build(BuildContext context) {
    MaterialColor appBarColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("规则引擎"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appBarColor[800],
              appBarColor[200],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
    );
  }
}