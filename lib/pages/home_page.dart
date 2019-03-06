import 'package:flutter/material.dart';
import '../api/home_page.dart';
import 'dart:convert';


import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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
            String leaderImg = res['data']['shopInfo']['leaderImage'];
            String leaderPhone = res['data']['shopInfo']['leaderPhone'];
            List<Map> recomandList = (res['data']['recommend'] as List).cast();

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperCons(swiperItem: swiperlist),
                  TopNavigator(navigatorList: navigatorList,),
                  AdBanner(adPic:adPic),
                  LeaderPhone(leaderImg: leaderImg, leaderPhone: leaderPhone,),
                  Recomand(recomandList: recomandList,)
                ],
              ),
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

// 点击拨打电话
class LeaderPhone extends StatelessWidget {
  final String leaderImg; //店长图片
  final String leaderPhone; //店长图片

  LeaderPhone({Key key, this.leaderImg, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){
          _launcherURL();
        },
        child: Image.network(leaderImg),
      ),
    );
  }
  void _launcherURL() async {
    String url = 'tel:' + leaderPhone;
    if(await canLaunch(url)) {
      await launch(url);
    }else {
      throw '链接解析错误！！！';
    }
  }
}

// 商品推荐

class Recomand extends StatelessWidget {
  final List recomandList;
  Recomand({Key key, this.recomandList}) : super(key: key);
  //头部标题
  Widget _titWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.black12,)
        )
      ),
      child: Text('商品推荐', style: TextStyle(color: Colors.pink),),
    );
  }

  //商品单独项
  Widget _item(index) {
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: .5, color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recomandList[index]['image']),
            Text('￥${recomandList[index]['mallPrice']}'),
            Text(
              '￥${recomandList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color:  Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表
  Widget _recomandList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recomandList.length,
        itemBuilder: (context, index){
          return _item(index);
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titWidget(),
          _recomandList()
        ],
      ),
    );
  }
}