import 'dart:async';

/**
 * 实现通用列表，适用所有列表页面
 */
import 'package:flutter/material.dart';
import 'package:flutter_app/router/router.dart';
import 'package:flutter_app/router/route_map.gr.dart';

class GeneralListWidget<T> extends StatefulWidget {
  final List<String> _selectedToDelete = [];
  final StreamController<T> _streamController = StreamController();

  GeneralListWidget(String text, {Key key}) : super(key: key);

  @override
  _GeneralListWidgetState createState() => _GeneralListWidgetState();
}

class _GeneralListWidgetState extends State<GeneralListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(),
    );
  }
}
