import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CloudRoute extends StatefulWidget{
  @override
  _CloudRouteState createState() => new _CloudRouteState();
}

///云端界面，还没往里面填东西，留个空等后面再写
class _CloudRouteState extends State<CloudRoute>{

  int _count = 5;

  @override
  Widget build(BuildContext context){
    return EasyRefresh.custom(
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _count = 5;
          });
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _count += 5;
          });
        });
      },
      slivers: <Widget>[
        //=====轮播图=====//
        SliverToBoxAdapter(child: getBannerWidget()),


        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  '敬请期待',
                  style: TextStyle(fontSize: 18),
                ))),

      ],
    );
  }


  Widget getBannerWidget() {
    return SizedBox(
      height: 180,
      child: Swiper(
        autoplay: true,
        duration: 2000,
        autoplayDelay: 5000,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.blueGrey,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                /*child: Image(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    "http://photocdn.sohu.com/tvmobilemvms/20150907/144159406950245847.jpg",
                  ),
                )*/
            ),
          );
        },
        onTap: (value) {
        },
        itemCount: 5,
        pagination: SwiperPagination(),
      ),
    );
  }
}