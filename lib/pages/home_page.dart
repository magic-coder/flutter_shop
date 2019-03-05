import 'package:flutter/material.dart';
import '../api/home_page.dart';
import 'dart:convert';


import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var res =json.decode(snapshot.data.toString());
            List<Map> swiperlist = (res['data']['slides'] as List).cast();
            List<Map> navigatorList = (res['data']['category'] as List).cast();
            String adPic = res['data']['advertesPicture']['PICTURE_ADDRESS'];
            return Column(
              children: <Widget>[
                SwiperCons(swiperItem: swiperlist),
                TopNavigator(navigatorList: navigatorList,),
                AdBanner(adPic:adPic)
              ],
            );
          } else {
            return Center(
              child: Text('暂无数据'),
            );
          }
        },
      ),
    );
  }
}

// 轮播组件
class SwiperCons extends StatelessWidget {
  final List swiperItem;
  SwiperCons({Key key, @required this.swiperItem}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(333),
        // width: ScreenUtil().setWidth(width),
        child: Swiper(
          itemBuilder: (context, index){
            final imgUrl = swiperItem[index]['image'];
            return Image.network(imgUrl, fit: BoxFit.fill);
          },
          itemCount: swiperItem.length,
          autoplay: true,
          pagination: SwiperPagination(),
        ),
    );
  }
}
// nav部分
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItem(context, item) {
    return InkWell(
      onTap: () {
        print('点击导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(navigatorList.length > 10) {
      navigatorList.removeLast();
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5),
        children: navigatorList.map((v){
          return _gridViewItem(context, v);
        }).toList()
      ),
    );
  }
}

// 广告横图部分
class AdBanner extends StatelessWidget {
  final String adPic;

  AdBanner({Key key, this.adPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPic),
    );
  }
}