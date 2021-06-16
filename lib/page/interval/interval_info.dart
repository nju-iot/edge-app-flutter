import 'dart:convert';

import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/page/interval/interval_add.dart';
import "package:flutter_app/models/MyInterval.dart";

class IntervalInfoPage extends StatefulWidget {
  final String intervalString;
  IntervalInfoPage(@PathParam("intervalString") this.intervalString);

  @override
  _IntervalInfoPageState createState() => _IntervalInfoPageState();
}

class _IntervalInfoPageState extends State<IntervalInfoPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntervalAddPage(
      intervalString: widget.intervalString,
    );
  }
}
